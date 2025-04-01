import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../base_view.dart';
import '../../monthly_data/widgets/pie_chart.dart';
import '../constants/home_constants.dart';
import '../viewmodel/homescreen_viewmodel.dart';

class AttendanceDetailsWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return BaseView<HomeScreenViewModel>(
      onModelReady: (model){
      },
      onModelClose: (model){

      },
      builder: (context, model,child){
        return Container(
          width: double.infinity,
          margin:
          const EdgeInsets.only(left: 20, right: 20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 1.0,
                  spreadRadius: 1, //New
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        width: 1,
                        color: const Color(0xFF006CB5)),
                    color: const Color(0xFFE6F0F8)),
                child: Text(
                  '${months[DateTime.now().month - 1]} ${DateTime.now().year}',
                  style: const TextStyle(
                      color: Color(0xFF006CB5),
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    '${model.daysPresent} Days',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 5,
                    height: 15,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${model.daysAbsent} Days',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.red),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 5,
                    height: 15,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${model.sorted_holidays_for_current_month.length} Days',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.yellow[800]),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    '${model.daysInMonth(DateTime.now())} Days',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF006CB5)),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size(200, 200), // Canvas size
                      painter: PieChartPainter(
                          data: {
                            'Present': double.parse(model.daysPresent.toString()),
                            'Absent': double.parse(model.daysAbsent.toString()),
                            'Leave': double.parse(model.daysLeave.toString()),
                            'Holiday': double.parse(model.sorted_holidays_for_current_month.length.toString()),
                            'Partial' : double.parse((model.totalNoOfDaysInTheMonth - (model.daysPresent+model.daysAbsent+model.daysLeave+model.sorted_holidays_for_current_month.length)).toString())
                          },
                          totalDays: model.totalNoOfDaysInTheMonth
                      ),
                    ),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                      ),
                      child: Center(
                        child: Text(
                            'TOTAL DAYS \n ${model.daysInMonth(DateTime.now())}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF006CB5),
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
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
                            Text('Holiday | ${model.sorted_holidays_for_current_month.length.toString()} Days',style: TextStyle(color: Colors.grey,fontSize: 14),),
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
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  model.navigateToPage('Attendance record');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(20),
                      color: const Color(0xFF006CB5)),
                  child: const Center(
                    child: Text(
                      'View Record',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}