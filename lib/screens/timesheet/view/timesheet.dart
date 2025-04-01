import 'package:community/base_view.dart';
import 'package:community/components/global_styles/strip_style.dart';
import 'package:community/components/global_styles/text_field_design.dart';
import 'package:community/screens/timesheet/viewmodel/timesheet_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'new_timesheet.dart';
import 'timesheet_details.dart';

class TimeSheet extends StatelessWidget{
  Widget _timeSheetStrip(String employeeName,String timeSheetName,String customer,String totalHours,String status){
    return stripStyle(
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                          color: Color(0xFF006CB5),
                          shape: BoxShape.circle
                      ),
                      child: const Icon(Icons.timelapse_sharp,color: Colors.white,),
                    )
                  ],
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(timeSheetName,style: const TextStyle(fontSize: 20,color: Color(0xFF006CB5)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: Text(customer,style: const TextStyle(fontSize: 16,color: Colors.grey,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          ),
                          Text(totalHours,style: const TextStyle(fontSize: 16,color: Colors.grey,fontWeight: FontWeight.bold),),

                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 20,),
          Container(
            height: 30,
            width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: status == 'Open' ? Colors.red :
                status == 'Rejected' ? Colors.red :
                status == 'Cancelled' ? Colors.green : Colors.green,width: 1)
            ),
            child: Center(
              child: Text(
                status,
                style: TextStyle(
                    color: status == 'Open' ? const Color(0xFFC52F2F) :
                    status == 'Rejected' ? const Color(0xFFC52F2F) :
                    status == 'Cancelled' ? Colors.green : Colors.green
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget _newTimeSheet(String text,context){
    return InkWell(
      onTap: (){
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isDismissible: true,
            builder: (btmSheetContext){
              return StatefulBuilder(
                builder: (context, StateSetter btmSheetState){
                  return Container(
                    height: MediaQuery.sizeOf(context).height,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                    ),
                    child: NewTimeSheet(),
                  );
                },
              );
            }
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF006CB5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(text,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return BaseView<TimesheetViewModel>(
      onModelReady: (model) async {
        model.getTimesheetData();
      },
      onModelClose: (model) async {
        model.clearFields();
      },
      builder: (context,model,child){
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: const Text('Timesheet',style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isDismissible: true,
                        builder: (btmSheetContext){
                          return StatefulBuilder(
                            builder: (context, StateSetter btmSheetState){
                              return Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                                ),
                                child: Wrap(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height:6,
                                          width: 60,
                                          margin: const EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[600]
                                          ),
                                        ),
                                        const SizedBox(height: 20,),
                                        SizedBox(
                                          height: 40,
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(10),
                                            decoration: textFieldDecoration(),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                  value: model.selectedValue,
                                                  onChanged: (String? newValue){
                                                    btmSheetState(() {
                                                      model.selectedValue = newValue!;
                                                      if(newValue == ''){
                                                        model.getTimesheetData();
                                                      }else {
                                                        model.getTimesheetDataFromStatus(model.selectedValue);
                                                      }
                                                    });
                                                  },
                                                  items: model.dropdownItems
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20,),
                                        InkWell(
                                          onTap: () async{
                                            DateTime? pickedDate = await showDatePicker(
                                                context: Get.context!,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1950),
                                                //DateTime.now() - not to allow to choose before today.
                                                lastDate: DateTime(2100));

                                            if (pickedDate != null) {
                                              String formattedDate =
                                              DateFormat('dd-MM-yyyy').format(pickedDate);
                                              btmSheetState(() {
                                                model.filterDate.text =
                                                    formattedDate; //set output date to TextField value.
                                              });
                                              model.getTimesheetDataFromStatusAndDate(model.selectedValue, DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(model.filterDate.text)));
                                            } else {}
                                          },
                                          child: Container(
                                            height: 40,
                                            padding: const EdgeInsets.all(10),
                                            decoration: textFieldDecoration(),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(model.filterDate.text),
                                                const Icon(Icons.date_range,size: 18,)
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: const Color(0xFF006CB5)
                                                  ),
                                                  child: const Center(
                                                    child: Text('Done',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  model.clearFields();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: const Color(0xFF006CB5)
                                                  ),
                                                  child: const Center(
                                                    child: Text('Clear',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10,)
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                    );
                  },
                  icon: const Icon(Icons.filter_alt,color: Color(0xFF006CB5),size: 30,)
              ),
              _newTimeSheet('New +',context)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: model.timesheet_list.isNotEmpty ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        ...List.generate(model.timesheet_list.length, (index) {
                          return InkWell(
                            onTap: (){
                              showModalBottomSheet(
                                  context: Get.context!,
                                  backgroundColor: Colors.transparent,
                                  isDismissible: true,
                                  builder: (btmSheetContext){
                                    return StatefulBuilder(
                                      builder: (context, StateSetter btmSheetState){
                                        return Container(
                                          height: MediaQuery.sizeOf(context).height,
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                                          ),
                                          child: TimeSheetDetails(name: model.timesheet_list[index]['name'],),
                                        );
                                      },
                                    );
                                  }
                              );
                              },
                            child: _timeSheetStrip(
                                model.timesheet_list[index]['employee_name'].toString(),
                                model.timesheet_list[index]['name'].toString(),
                                model.timesheet_list[index]['customer'].toString(),
                                model.timesheet_list[index]['total_hours'].toString(),
                                model.timesheet_list[index]['status'].toString()
                            ),
                          );
                        })

                      ],
                    ),
                  ):SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/empty.png',height: 140,),
                        const SizedBox(height: 10,),
                        const Text('No Timesheet Found',style: TextStyle(color: Colors.grey),),
                        const SizedBox(height:10,),

                      ],
                    ),
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