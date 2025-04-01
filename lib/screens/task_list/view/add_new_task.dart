import 'package:community/base_view.dart';
import 'package:community/locator/locator.dart';
import 'package:community/screens/home/viewmodel/homescreen_viewmodel.dart';
import 'package:community/screens/task_list/api_requests/web_requests.dart';
import 'package:community/screens/task_list/viewmodel/add_new_task_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../components/global_styles/text_field_design.dart';
import '../../../helpers/toast.dart';


class AddNewTask extends StatelessWidget{
  HomeScreenViewModel homeScreenViewModel = locator.get<HomeScreenViewModel>();
  @override
  Widget build(BuildContext context){
    return BaseView<AddNewTaskViewModel>(
      onModelReady: (model) async{

      },
      onModelClose: (model) async{

      },
      builder: (context,model,child){
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
                        const SizedBox(height: 5,),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: textFieldDecoration(),
                          child: TextFormField(
                            controller: model.subject,
                            decoration: inputDecoration('Subject', true),
                            validator: (value){
                              if(value!.isNotEmpty) {
                                return null;
                              }
                              return 'Please provide a subject';
                            },
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: textFieldDecoration(),
                          child: TextFormField(
                            controller: model.assignedTo,
                            decoration: inputDecoration('Assigned To', true),
                            validator: (value){
                              if(value!.isNotEmpty) {
                                return null;
                              }
                              return 'Please provide an assigned to';
                            },
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                          width: double.infinity,
                          decoration: textFieldDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                value: model.selectedValueStatus,
                                onChanged: (String? newValue){
                                  model.changeStatus(newValue!);
                                },
                                items: model.dropdownStatusItems
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                          width: double.infinity,
                          decoration: textFieldDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                value: model.selectedValuePriority,
                                onChanged: (String? newValue){
                                  model.changePriority(newValue!);
                                },
                                items: model.dropdownPriorityItems
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: textFieldDecoration(),
                          child: TextFormField(
                            readOnly: true,
                              controller: model.baseLineStartDate,
                              decoration: inputDecoration('Baseline Start Date', false, suffixIcon: Icon(Icons.calendar_today_outlined)),
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
                                  DateFormat('dd-MM-yyyy').format(pickedDate); //formatted date output using intl package =>  2021-03-16
                                  model.changeBaseLineStartDate(formattedDate);
                                } else {}
                              }
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: textFieldDecoration(),
                          child: TextFormField(
                            readOnly: true,
                              controller: model.baseLineEndDate,
                              decoration: inputDecoration('Baseline End Date', false, suffixIcon: Icon(Icons.calendar_today_outlined)),
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
                                  DateFormat('dd-MM-yyyy').format(pickedDate); //formatted date output using intl package =>  2021-03-16
                                  model.changeBaseLineEndDate(formattedDate);
                                } else {}
                              }
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                          width: double.infinity,
                          decoration: textFieldDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: model.storyPoints,
                              onChanged: (String? newValue){
                                model.changeStoryPointValue(newValue!);
                              },
                              items: model.dropdownStoryPoints,
                            ),
                          ),
                        ),
                          const SizedBox(height: 10,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              controller: model.description,
                              maxLines: 6,
                              minLines: 6,
                              decoration: inputDecoration('Description', true),
                              validator: (value){
                                if(value!.isNotEmpty) {
                                  return null;
                                }
                                return 'Please provide a description';
                              },
                            ),
                          ),
                          const SizedBox(height: 10,),
                          InkWell(
                            onTap: (){
                              if(model.formKey.currentState!.validate()){
                                Map<String,String> taskBody = {
                                  "status": model.selectedValueStatus,
                                  "priority": model.selectedValuePriority,
                                  "description": model.description.text,
                                  "exp_start_date": model.baseLineStartDate.text != '' ? DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(model.baseLineStartDate.text)) : '',
                                  "exp_end_date" : model.baseLineEndDate.text != '' ? DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(model.baseLineEndDate.text)) : '',
                                  "assignedTo": model.assignedTo.text,
                                  "subject" : model.subject.text,
                                  "effort": model.storyPoints,
                                  "sprint_status":"Planned"
                                };
                                WebRequests().createNewTask(taskBody).then((value) => {
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
                                              const Text('Your task is created successfully!',textAlign: TextAlign.center,),
                                              const SizedBox(height: 20),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.of(context).pop();
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
                                child: Text('Create',style: TextStyle(color: Colors.white),),
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