import 'package:community/base_view.dart';
import 'package:community/components/global_styles/text_field_design.dart';
import 'package:community/screens/task_list/api_requests/web_requests.dart';
import 'package:community/screens/task_list/viewmodel/task_description_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../helpers/toast.dart';



class TaskDescription extends StatelessWidget{
  final dynamic doc;
  final String empId;
  const TaskDescription({super.key, 
    required this.doc,
    required this.empId
  });

  @override
  Widget build(BuildContext context){
    return BaseView<TaskDescriptionViewModel>(
      onModelReady: (model) async{
        model.getTaskDetails(doc['name']);
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
                              controller: model.team,
                              decoration: inputDecoration('Team', true),
                              validator: (value){
                                if(value!.isNotEmpty) {
                                  return null;
                                }
                                return 'Please provide a team';
                              },
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              controller: model.type,
                              decoration: inputDecoration('Type', true),
                              validator: (value){
                                if(value!.isNotEmpty) {
                                  return null;
                                }
                                return 'Please provide a type';
                              },
                            ),
                          ),
                          const SizedBox(height: 5,),
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
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              controller: model.assigneeName,
                              decoration: inputDecoration('Assignee Name', true),
                              validator: (value){
                                if(value!.isNotEmpty) {
                                  return null;
                                }
                                return 'Please provide an assignee name';
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
                                    model.changeStatus(newValue);
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
                                    model.changePriorityValue(newValue);
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
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              readOnly: true,
                                controller: model.actualStartDate,
                                decoration: inputDecoration('Actual Start Date', false, suffixIcon: Icon(Icons.calendar_today_outlined)),
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
                                    model.changeActualStartDate(formattedDate);
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
                                controller: model.actualEndDate,
                                decoration: inputDecoration('Actual End Date', false, suffixIcon: Icon(Icons.calendar_today_outlined)),
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
                                    model.changeActualEndDate(formattedDate);
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
                          Text('Tags'),
                          const SizedBox(height: 5,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...List.generate(model.addedTags.length, (index) {
                                return model.addedTags[index] != '' ? Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(bottom: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(width: 1,color: Colors.grey)
                                  ),
                                  child: Text(model.addedTags[index]),
                                ):Container();
                              })
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              controller: model.tag,
                              onChanged: (value) async{
                                if(value.isEmpty){
                                  model.clearTagList();
                                  return;
                                }
                                model.tagList = await WebRequests().getTagList(value) ?? [];
                                model.callNotifier();
                              },
                              decoration: inputDecoration('Search Tag', true),

                            ),
                          ),
                          const SizedBox(height: 5,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...List.generate(model.tagList.length, (index) {
                                return model.tagList[index] != '' ? InkWell(
                                  onTap: () async{
                                    var responseTag = await WebRequests().addTag(model.tagList[index], doc['name']);
                                    model.addTags(responseTag);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(width: 1,color: Colors.grey)
                                    ),
                                    child: Text(model.tagList[index]),
                                  ),
                                ):Container();
                              })
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Text('Task Progress'),
                          const SizedBox(height: 5,),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...List.generate(model.taskProgress.length, (index){
                                  return Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: Colors.grey,width: 1)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context).width*0.25,
                                              child: const Text('Date:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                            ),
                                            Expanded(
                                              child: Text(
                                                DateFormat('dd-MM-yyyy').format(DateTime.parse(model.taskProgress[index]['tps_date'])),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context).width*0.25,
                                              child: const Text('Update:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                            ),
                                            Expanded(
                                              child: Text(
                                                model.taskProgress[index]['tps_update'],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
                          InkWell(
                            onTap: (){
                              if(model.formKey.currentState!.validate()){
                                Map<String,String> taskData = {
                                  "status": model.selectedValueStatus,
                                  "priority": model.selectedValuePriority,
                                  "description": model.description.text,
                                  "exp_start_date": model.baseLineStartDate.text != '' ? DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(model.baseLineStartDate.text)) : '',
                                  "exp_end_date" : model.baseLineEndDate.text != '' ? DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(model.baseLineEndDate.text)) : '',
                                  "actual_start_date" : model.actualStartDate.text != '' ? DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(model.actualStartDate.text)) : '',
                                  "actual_end_date" : model.actualEndDate.text != '' ? DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(model.actualEndDate.text)) : '',
                                  "type": model.type.text,
                                  "team": model.team.text,
                                  "assignedTo": model.assignedTo.text,
                                  "subject" : model.subject.text,
                                  "effort": model.storyPoints,
                                  "sprint_status":"Planned"
                                };
                                WebRequests().editTask(taskData,doc['name']).then((value) => {
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
                                              const Text('Your task is updated successfully!',textAlign: TextAlign.center,),
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
                                child: Text('Save',style: TextStyle(color: Colors.white),),
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