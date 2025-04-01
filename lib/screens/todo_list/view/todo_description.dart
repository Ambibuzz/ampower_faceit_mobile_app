import 'package:community/base_view.dart';
import 'package:community/screens/todo_list/api_requests/web_requests.dart';
import 'package:community/screens/todo_list/viewmodel/tododescription_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../components/global_styles/text_field_design.dart';
import '../../../helpers/toast.dart';


class TodoDescription extends StatelessWidget{
  final String docName;
  final String empId;
  TodoDescription({super.key,
    required this.docName,
    required this.empId
  });


  @override
  Widget build(BuildContext context){
    return BaseView<TodoDescriptionViewModel>(
      onModelReady: (model) async {
        model.allocatedTo.clear();
        model.getAllUsers();
        model.getTodoDetails(docName);
      },
      onModelClose: (model) async {

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
                          Container(
                            padding: const EdgeInsets.all(5),
                            width: double.infinity,
                            decoration: textFieldDecoration(),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  value: model.selectedValueStatus,
                                  onChanged: (String? newValue){
                                    model.changeStatusValue(newValue);
                                  },
                                  items: model.dropdownStatusItems
                              ),
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.all(5),
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
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                                controller: model.dueDate,
                                decoration: inputDecoration('Due Date', false, suffixIcon: Icon(Icons.calendar_today_outlined)),
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
                                    model.changeDueDate(formattedDate);
                                  } else {}
                                }
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            width: double.infinity,
                            decoration: textFieldDecoration(),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: model.allocateTo,
                                onChanged: (String? newValue){
                                  model.changeAllocatedToValue(newValue);
                                },
                                items: model.allocatedTo,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              controller: model.description,
                              maxLines: 6,
                              minLines: 6,
                              decoration: inputDecoration('Description', false),
                              validator: (value){
                                if(value!.isNotEmpty) {
                                  return null;
                                }
                                return 'Please provide a description';
                              },
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              controller: model.role,
                              decoration: inputDecoration('Role', false),
                              onTap: (){
                                model.changeRoleListVisibility(true);
                              },
                            ),
                          ),
                          model.isRoleListVisible ? SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: model.roleList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: (){
                                    model.role.text = model.roleList[index]['value'];
                                    model.isRoleListVisible = false;
                                    model.pingNotifyListener();
                                  },
                                  child: ListTile(
                                    title: Text(model.roleList[index]['value']),
                                    subtitle: Text(model.roleList[index]['description']),

                                  ),
                                );
                              },
                            ),
                          ):Container(),
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              controller: model.assignedBy,
                              decoration: inputDecoration('Assigned By', false),
                              onTap: (){
                                model.changeAssignedByVisibility(true);
                              },
                            ),
                          ),
                          model.isAssignedByVisible ? SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: model.users.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: (){
                                    model.assignedBy.text = model.users[index]['name'];
                                    model.isAssignedByVisible = false;
                                    model.pingNotifyListener();
                                  },
                                  child: ListTile(
                                    title: Text(model.users[index]['name']),
                                  ),
                                );
                              },
                            ),
                          ):Container(),
                          const SizedBox(height: 20,),
                          InkWell(
                            onTap: (){
                              if(model.formKey.currentState!.validate()){
                                Map<String,String> todoData = {
                                  "status": model.selectedValueStatus,
                                  "priority": model.selectedValuePriority,
                                  "description": model.description.text,
                                  "date": model.dueDate.text,
                                  "owner": model.allocateTo,
                                  "reference_type": model.referenceType.text,
                                  "reference_name": model.referenceName.text,
                                  "role": model.role.text,
                                  "assigned_by": model.assignedBy.text
                                };
                                WebRequests().editTodo(todoData,docName).then((value) => {
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