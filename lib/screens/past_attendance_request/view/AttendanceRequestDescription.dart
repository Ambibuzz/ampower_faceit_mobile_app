import 'package:community/base_view.dart';
import 'package:community/screens/past_attendance_request/api_requests/web_requests.dart';
import 'package:community/screens/past_attendance_request/viewmodel/past_attendance_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../components/global_styles/text_field_design.dart';
import '../../../helpers/toast.dart';



class AttendanceRequestDescription extends StatelessWidget{
  dynamic doc;
  final BuildContext bottomSheetContext;
  AttendanceRequestDescription({super.key, 
    required this.doc,
    required this.bottomSheetContext
  });

  Widget _wrapper({Widget? child}){
    return Container(
      child: child,
    );
  }

  @override
  Widget build(BuildContext context){
    return BaseView<PastAttendaceDetailsViewModel>(
      onModelReady: (model) async{
        model.initValues(doc);
      },
      onModelClose: (model) async{

      },
      builder: (context,model,child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: model.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _wrapper(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5,),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: textFieldDecoration(),
                                    child: TextFormField(
                                        controller: model.fromDate,
                                        decoration: inputDecoration('From Date', false),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter From Date';
                                          }
                                          return null;
                                        },
                                        onTap: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                              context: Get.context!,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1950),
                                              //DateTime.now() - not to allow to choose before today.
                                              lastDate: DateTime(2100));

                                          if (pickedDate != null) {
                                            String formattedDate =
                                            DateFormat('yyyy-MM-dd').format(pickedDate); //formatted date output using intl package =>  2021-03-16
                                            model.changeFromDate(formattedDate);
                                          } else {}
                                        }
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: textFieldDecoration(),
                                    child: TextFormField(
                                        controller: model.toDate,
                                        decoration: inputDecoration('To Date', false),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter From Date';
                                          }
                                          return null;
                                        },
                                        onTap: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                              context: Get.context!,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1950),
                                              //DateTime.now() - not to allow to choose before today.
                                              lastDate: DateTime(2100));

                                          if (pickedDate != null) {
                                            String formattedDate =
                                            DateFormat('yyyy-MM-dd').format(pickedDate); //formatted date output using intl package =>  2021-03-16
                                            model.changeToDate(formattedDate);
                                          } else {}
                                        }
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: model.isHalfDay,
                                          onChanged: (value){
                                            if(model.fromDate.text.isNotEmpty && model.toDate.text.isNotEmpty){
                                              model.changeHalfDayValue(value!);
                                            }
                                          }
                                      ),
                                      Text('Half Day'),
                                    ],
                                  ),
                                  model.isHalfDay ? const SizedBox(height: 10,):Container(),
                                  model.isHalfDay && DateTime.parse(model.fromDate.text).isBefore(DateTime.parse(model.toDate.text)) ? Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: textFieldDecoration(),
                                    child: TextFormField(
                                        controller: model.halfDayDate,
                                        decoration: inputDecoration('Half Day Date', false),
                                        onTap: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                              context: Get.context!,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1950),
                                              //DateTime.now() - not to allow to choose before today.
                                              lastDate: DateTime(2100));

                                          if (pickedDate != null) {
                                            String formattedDate =
                                            DateFormat('yyyy-MM-dd').format(pickedDate);
                                            model.changeHalfDayDate(formattedDate);
                                          } else {}
                                        }
                                    ),
                                  ):Container(),
                                  const SizedBox(height: 10,),
                                  Container(
                                    padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                                    width: double.infinity,
                                    decoration: textFieldDecoration(),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        value: model.reason,
                                        onChanged: (String? newValue){
                                          model.changeReasonValue(newValue!);
                                        },
                                        items: model.dropdownReasonItems,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              controller: model.explanation,
                              maxLines: 6,
                              minLines: 6,
                              decoration: inputDecoration('Explanation', true),
                              validator: (value){
                                if(value!.isNotEmpty) {
                                  return null;
                                }
                                return 'Please provide an explanation';
                              },
                            ),
                          ),
                          const SizedBox(height: 20,),
                          doc['docstatus'] == 1 ? Container():
                          InkWell(
                            onTap: (){
                              if(model.formKey.currentState!.validate()){
                                if(model.isHalfDay)
                                {
                                  doc['from_date'] = model.fromDate.text;
                                  doc['to_date'] = model.toDate.text;
                                  doc['reason'] = model.reason;
                                  doc['explanation'] = model.explanation.text;
                                  doc['half_day'] = 1;
                                  doc['half_day_date'] =  DateTime.parse(model.fromDate.text).isBefore(DateTime.parse(model.toDate.text)) ? model.halfDayDate.text : model.fromDate.text;
                                }else
                                {
                                  doc['from_date'] = model.fromDate.text;
                                  doc['to_date'] = model.toDate.text;
                                  doc['reason'] = model.reason;
                                  doc['explanation'] = model.explanation.text;
                                }
                                WebRequests().updateAttendanceRequest(doc).then((value) => {
                                  if(value!['success']){
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        content: SizedBox(
                                          height: 260,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const Text("Success!",style: TextStyle(color: Color(0xFF10C500),fontSize: 30 ),),
                                              const SizedBox(height: 20,),
                                              Image.asset('assets/images/checkmark.png',height: 80,width: 80,),
                                              const SizedBox(height: 20,),
                                              const Text('Your Attendance Request has been Updated Successfully!',textAlign: TextAlign.center,),
                                              const SizedBox(height: 20),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.of(context).pop("Updated");
                                                  Navigator.of(bottomSheetContext).pop();
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    color: const Color(0xFF9DFFB2),
                                                  ),

                                                  child: const Center(
                                                    child: Text("Done",style: TextStyle(color: Colors.black),),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  }else{
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text("Something went wrong"),
                                        content: Text(value['data'].split(':')[1].trim()),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Container(
                                              color: const Color(0xFF006CB5),
                                              padding: const EdgeInsets.all(14),
                                              child: const Text("ok",style: TextStyle(color: Colors.white),),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    //fluttertoast(context, value['data'])
                                  }
                                });

                              }else{
                                fluttertoast(context, 'Something went wrong');
                              }


                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xFF006CB5),
                              ),
                              child: const Center(
                                child: Text('Submit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              ),
                            ),
                          )
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

  }
}