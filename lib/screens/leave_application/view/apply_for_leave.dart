import 'package:community/base_view.dart';
import 'package:community/helpers/null_checker.dart';
import 'package:community/screens/leave_application/api_requests/web_requests.dart';
import 'package:community/screens/leave_application/viewmodel/applyforleave_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../components/global_styles/text_field_design.dart';
import '../../../helpers/toast.dart';

class ApplyForLeave extends StatelessWidget{
  final BuildContext bottomSheetContext;
  const ApplyForLeave({super.key,
    required this.bottomSheetContext
  });


  @override
  Widget build(BuildContext context){
    return BaseView<ApplyForLeaveViewModel>(
      onModelReady: (model) async {
        model.initAllVariables();
        model.employeeDetails();
        model.leaveTypeList();
      },
      onModelClose: (model) async {

      },
      builder: (context,model,child) {
        return model.employeeData == null ? const Center(child: CupertinoActivityIndicator(),):
        Column(
          children: [
            Container(
              height:6,
              width: 60,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(8)
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left:10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10,),
                      Form(
                        key: model.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10,),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: textFieldDecoration(),
                              child: TextFormField(
                                enabled: false,
                                initialValue: checkForNull(model.employeeData.first['employee'], ''),
                                decoration: inputDecoration('Employee', true),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: textFieldDecoration(),
                              child: TextFormField(
                                enabled: false,
                                initialValue: checkForNull(model.employeeData.first['employee_name'], ''),
                                decoration: inputDecoration('Employee Name', false),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                              width: double.infinity,
                              decoration: textFieldDecoration(),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    value: model.leaveTypeValue,
                                    onChanged: (String? newValue){
                                      model.changeLeaveTypeValue(newValue);
                                    },
                                    items: model.leaveTypeMenuItems
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5,),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: textFieldDecoration(),
                                        child: TextFormField(
                                            readOnly: true,
                                            controller: model.fromDate,
                                            decoration: inputDecoration('From Date', true,suffixIcon: Icon(Icons.calendar_today_outlined)),
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
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5,),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: textFieldDecoration(),
                                        child: TextFormField(
                                            readOnly: true,
                                            controller: model.toDate,
                                            decoration: inputDecoration('To Date', true,suffixIcon: Icon(Icons.calendar_today_outlined)),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter To Date';
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
                                                DateFormat('yyyy-MM-dd').format(pickedDate);
                                                model.changeToDate(formattedDate);
                                              } else {}
                                            }
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10,),

                            Row(
                              children: [
                                Checkbox(
                                    value: model.isHalfDay,
                                    onChanged: (value){
                                      if(model.fromDate.text.isNotEmpty && model.toDate.text.isNotEmpty){
                                        model.changeIsHalfDay(value);
                                      }
                                    }
                                ),
                                const Text('Half Day')
                              ],
                            ),
                            model.isHalfDay && DateTime.parse(model.fromDate.text).isBefore(DateTime.parse(model.toDate.text)) ? const SizedBox(height: 10,):Container(),
                            model.isHalfDay && DateTime.parse(model.fromDate.text).isBefore(DateTime.parse(model.toDate.text)) ? Container(
                              padding: const EdgeInsets.all(5),
                              decoration: textFieldDecoration(),
                              child: TextFormField(
                                  readOnly: true,
                                  controller: model.halfDayDate,
                                  decoration: inputDecoration('Half Day Date',true,suffixIcon: Icon(Icons.calendar_today_outlined)),
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
                              padding: const EdgeInsets.all(5),
                              decoration: textFieldDecoration(),
                              child: TextFormField(
                                controller: model.reason,
                                decoration: inputDecoration('Reason', false),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: textFieldDecoration(),
                              child: TextFormField(
                                  readOnly: true,
                                  controller: model.postingDate,
                                  decoration: inputDecoration('Posting Date', true,suffixIcon: Icon(Icons.calendar_today_outlined)),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Posting Date';
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
                                      DateFormat('yyyy-MM-dd').format(pickedDate);
                                      model.changePostingDate(formattedDate);
                                    } else {}
                                  }
                              ),
                            ),

                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: textFieldDecoration(),
                              child: TextFormField(
                                enabled: false,
                                initialValue: checkForNull(model.employeeData.first['leave_approver'], ''),
                                decoration: inputDecoration('Leave Approver', true),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: textFieldDecoration(),
                              child: TextFormField(
                                enabled: false,
                                initialValue: checkForNull(model.employeeData.first['company'], ''),
                                decoration: inputDecoration('Company', true),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: (){
                                    if(model.formKey.currentState!.validate()){
                                      Map<String,String> leaveData = {
                                        "leave_type": model.leaveTypeValue,
                                        "employee": checkForNull(model.employeeData.first['employee'], ''),
                                        "from_date": model.fromDate.text,
                                        "to_date": model.toDate.text,
                                        "half_day": model.isHalfDay ? "1":"0",
                                        "half_day_date": model.halfDayDate.text,
                                        "description": model.reason.text,
                                        "leave_approver": checkForNull(model.employeeData.first['leave_approver'], ''),
                                        "posting_date": model.postingDate.text,
                                        "company": checkForNull(model.employeeData.first['company'], '')
                                      };
                                      WebRequests().applyForLeave(context, leaveData).then((value) => {
                                        if(value!['success']){
                                          showDialog(
                                            context: Get.context!,
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
                                                    const Text('Your Leave Application has been Successfully Applied!',textAlign: TextAlign.center,),
                                                    const SizedBox(height: 20),
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.of(Get.context!).pop();
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
                                            context: Get.context!,
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
                                                    child: const Text("ok",style: TextStyle(color: Colors.black),),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          //fluttertoast(context, value['data'])
                                        }
                                      });

                                    }else{
                                      fluttertoast(Get.context!, 'Something went wrong');
                                    }


                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color(0xFF006CB5),
                                    ),
                                    child: const Center(
                                      child: Text('Save',style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );

  }
}