import 'package:community/base_view.dart';
import 'package:community/locator/locator.dart';
import 'package:community/screens/home/view/home.dart';
import 'package:community/screens/home/viewmodel/homescreen_viewmodel.dart';
import 'package:community/screens/monthly_data/viewmodel/monthly_data_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../home/constants/home_constants.dart';
import '../widgets/calendar_view.dart';
import '../widgets/pie_chart_view.dart';

class MonthlyData extends StatelessWidget{
  HomeScreenViewModel homeScreenViewModel = locator.get<HomeScreenViewModel>();
  @override
  Widget build(BuildContext context){
    return BaseView<MonthlyDataViewModel>(
      onModelReady: (model) async {
        model.initValues();
        model.selectedDate = "${months[DateTime.now().month-1]} ${DateTime.now().year}";//get the current month & year
        model.getHolidays(DateTime.now().month,DateTime.now().year).then((value) =>model.getMonthlyData(
            startDate: "${DateTime.now().year}-${DateTime.now().month}-01",
            endDate: "${DateTime.now().year}-${DateTime.now().month}-${model.daysInMonth(DateTime(model.year,model.month))}",
            force: false
        ));
      },
      onModelClose: (model) async {

      },
      builder: (context,model,child) {
        return Scaffold(
          backgroundColor: const Color(0xFFE6F0F8),
          appBar: AppBar(
            title: const Text('Attendance Record',style: TextStyle(color: Colors.black),),
            iconTheme: const IconThemeData(
                color: Colors.black
            ),
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  onPressed: () {
                    model.setDateAndGetMonthlyData(model.currentDate.month,model.currentDate.year,true);
                    Get.snackbar('Syncing...', 'Please wait we are syncing your monthly data',backgroundColor: const Color(0xFF006CB5));
                  },
                  icon: Icon(Icons.refresh,color: Color(0xFF006CB5),)
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                      onTap: () async{
                                        final selected = await showDatePicker(
                                          //initialDatePickerMode: DatePickerMode.year,
                                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: model.selectedValue == "Holiday" ? DateTime(DateTime.now().year,4) : DateTime(2000),
                                          lastDate: model.selectedValue == "Holiday" ? DateTime(DateTime.now().year+1,3,31) : DateTime.now(),
                                        );
                                        if(selected != null){
                                          model.data.clear();
                                          model.currentDate = selected;
                                          model.month = model.currentDate.month;
                                          model.year = model.currentDate.year;
                                          if(model.currentDate.isAfter(DateTime(DateTime.now().year,3)) && model.currentDate.isBefore(DateTime(DateTime.now().year+1,3,31))){
                                            model.getHolidays(model.currentDate.month,model.currentDate.year);
                                          }
                                          model.setDateAndGetMonthlyData(selected.month,selected.year,false);
                                        }
                                      },
                                      child:Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(width: 1,color: const Color(0xFF006CB5)),
                                            color: const Color(0xFFE6F0F8)
                                        ),
                                        child:  Row(
                                          children: [
                                            Text(model.selectedDate,style: const TextStyle(color: Color(0xFF006CB5),fontWeight: FontWeight.bold),),
                                            const SizedBox(width: 20,),
                                            const Icon(Icons.calendar_month,color: Color(0xFF006CB5),)
                                          ],
                                        ),
                                      )
                                  ),
                                  InkWell(
                                    onTap: (){

                                    },
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          style: const TextStyle(fontSize: 15.5,color: Colors.black),
                                          value: model.selectedValue,
                                          onChanged: (String? newValue){
                                            model.changeViewSelector(newValue);
                                          },
                                          items: model.dropdownItems
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),
                              (model.selectedValue == 'Calendar' && model.current_holidays.isNotEmpty) ?
                              CalendarView(data: model.data,year: model.year,month: model.month) :
                              model.selectedValue == 'Chart' ?
                              PieChartView(
                                presentDays: model.daysPresent,
                                absentDays: model.daysAbsent,
                                leaveDays: model.daysLeave,
                                holidays: model.current_holidays.length,
                                partialDays: model.daysPartial,
                                totalWorkingDays: model.totalNoOfDaysInTheMonth,
                              ) : Container(),

                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF189333),
                                                  shape: BoxShape.circle
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Text('Present | ${model.daysPresent.toString()} Days',style: TextStyle(color: Colors.grey,fontSize: 14),),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFC52F2F),
                                                  shape: BoxShape.circle
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Text('Absent | ${model.daysAbsent.toString()} Days',style: TextStyle(color: Colors.grey,fontSize: 14),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text('Holiday | ${model.current_holidays.length.toString()} Days',style: TextStyle(color: Colors.grey,fontSize: 14),),
                                            const SizedBox(width: 10,),
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFFF731D),
                                                  shape: BoxShape.circle
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text('Leaves | ${model.daysLeave.toString()} Days',style: TextStyle(color: Colors.grey,fontSize: 14),),
                                            const SizedBox(width: 10,),
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF006CB5),
                                                  shape: BoxShape.circle
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                      ),
                      const SizedBox(height: 20,),
                      const SizedBox(
                        //padding: EdgeInsets.all(20),
                        width: double.infinity,
                        child: Text('Upcoming Holidays',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        //margin: EdgeInsets.only(left: 20,right: 20),
                        padding: const EdgeInsets.all(15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 1.0,
                                spreadRadius: 1, //New
                              )
                            ]
                        ),
                        child: Column(
                          children: [
                            ...List.generate(model.current_holidays.length, (index){
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Text('${DateFormat('yyyy-MM-dd').format(DateTime.parse(model.current_holidays[index]['holiday_date']!))}',style: TextStyle(fontWeight: FontWeight.bold,color: (int.parse(model.current_holidays[index]['holiday_date']!.split('-')[2]) < DateTime.now().day || int.parse(model.current_holidays[index]['holiday_date']!.split('-')[0]) < DateTime.now().year) ? Colors.grey:const Color(0xFF006CB5)),),
                                    Expanded(child: Container(),),
                                    HtmlWidget(model.current_holidays[index]['description']!,textStyle: TextStyle(fontWeight: FontWeight.bold,color: (int.parse(model.current_holidays[index]['holiday_date']!.split('-')[2]) < DateTime.now().day || int.parse(model.current_holidays[index]['holiday_date']!.split('-')[0]) < DateTime.now().year) ? Colors.grey:const Color(0xFF006CB5)))
                                  ],
                                ),
                              );
                            })
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}