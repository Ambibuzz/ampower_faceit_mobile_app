import 'package:community/base_view.dart';
import 'package:community/components/global_styles/text_field_design.dart';
import 'package:community/screens/home/viewmodel/homescreen_viewmodel.dart';
import 'package:community/screens/past_attendance_request/viewmodel/past_attendance_viewmodel.dart';
import 'package:community/screens/past_attendance_request/widgets/attendance_strip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../locator/locator.dart';
import 'NewAttendanceRequest.dart';
import 'AttendanceRequestDescription.dart';

class AttendanceRequest extends StatelessWidget{

  Widget _createAttendanceRequest(String text,model){
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
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                    ),
                    child: NewAttendanceRequest(botttomSheetContext: btmSheetContext,),
                  );
                },
              );
            }
        ).then((value){
          model.getPastRequestData();
        });
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF006CB5),
          borderRadius: BorderRadius.circular(15),
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
    return BaseView<PastAttendanceViewModel>(
      onModelReady: (model) async{
        model.getPastRequestData();
      },
      onModelClose: (model) async {
        model.pastAttendanceRequestList.clear();
        model.fromDate.text = 'From Date';
        model.toDate.text = 'To Date';
      },
      builder: (context,model,child) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: const Text('Past Attendance Request',style: TextStyle(color: Colors.black),),
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
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () async{
                                                  DateTime? pickedDate = await showDatePicker(
                                                      context: Get.context!,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime(1950),
                                                      //DateTime.now() - not to allow to choose before today.
                                                      lastDate: DateTime(2100));

                                                  if (pickedDate != null) {
                                                    String formattedDate =
                                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                                    btmSheetState(() {
                                                      model.fromDate.text =
                                                          formattedDate; //set output date to TextField value.
                                                    });
                                                  } else {}
                                                },
                                                child: Container(
                                                  height: 40,
                                                  padding: const EdgeInsets.all(10),
                                                  decoration: textFieldDecoration(),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(model.fromDate.text),
                                                      const Icon(Icons.date_range,size: 18,)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 20,),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () async{
                                                  DateTime? pickedDate = await showDatePicker(
                                                      context: Get.context!,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime(1950),
                                                      //DateTime.now() - not to allow to choose before today.
                                                      lastDate: DateTime(2100));

                                                  if (pickedDate != null) {
                                                    String formattedDate =
                                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                                    btmSheetState(() {
                                                      model.toDate.text =
                                                          formattedDate; //set output date to TextField value.
                                                    });
                                                  } else {}
                                                },
                                                child: Container(
                                                  height: 40,
                                                  padding: const EdgeInsets.all(10),
                                                  decoration: textFieldDecoration(),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(model.toDate.text),
                                                      const Icon(Icons.date_range,size: 18,)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  if(model.fromDate.text == 'From Date' || model.toDate.text == 'To Date'){
                                                    Get.snackbar(
                                                        'Error!',
                                                        'Please enter from date and to date properly',
                                                        backgroundColor: Colors.white
                                                    );
                                                    return;
                                                  }
                                                  model.getPastRequestDataWithFilters();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  width:100,
                                                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
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
                                                  model.fromDate.text = 'From Date';
                                                  model.toDate.text = 'To Date';
                                                  model.getPastRequestData();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  width:100,
                                                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      color: const Color(0xFF006CB5)
                                                  ),
                                                  child: const Center(
                                                    child: Text('Clear',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                  ),
                                                ),
                                              ),
                                            ),
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
              _createAttendanceRequest('New +',model)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: model.pastAttendanceRequestList.isNotEmpty ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(model.pastAttendanceRequestList.length, (index) {
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
                                          child: AttendanceRequestDescription(doc: model.pastAttendanceRequestList[index],bottomSheetContext: btmSheetContext,),
                                        );
                                      },
                                    );
                                  }
                              ).then((value){
                                if(model.fromDate.text != 'From Date' && model.toDate.text != 'To Date'){
                                  model.getPastRequestDataWithFilters();
                                } else {
                                  model.getPastRequestData();
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 5,right: 5),
                              child: AttendanceStrip(
                                  fromDate: model.pastAttendanceRequestList[index]['from_date'].toString(),
                                  toDate: model.pastAttendanceRequestList[index]['to_date'].toString(),
                                  description: model.pastAttendanceRequestList[index]['reason'].toString()
                              ),
                            )
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
                        const Text('No Request Found',style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}