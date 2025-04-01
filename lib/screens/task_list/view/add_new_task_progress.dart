import 'package:community/base_view.dart';
import 'package:community/screens/task_list/api_requests/web_requests.dart';
import 'package:community/screens/task_list/viewmodel/add_new_task_progress_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../components/global_styles/text_field_design.dart';
import '../../../helpers/toast.dart';


class AddNewTaskProgress extends StatelessWidget{
  final String taskId;
  final String empId;
  final String subject;
  final String priority;
  final String status;
  const AddNewTaskProgress({super.key, 
    required this.taskId,
    required this.empId,
    required this.subject,
    required this.priority,
    required this.status
});

  @override
  Widget build(BuildContext context){
    return BaseView<AddNewTaskProgressViewModel>(
      onModelReady: (model) async{
        model.ownerMenuItems.clear();
        model.selectedOwner = empId;
        model.setEmpId(empId);
        model.getOwnerList('Employee', 'Task Progress Summary');
      },
      onModelClose: (model) async{
        model.clearFields();
      },
      builder: (context,model,child){
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.zero,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: model.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    color: Color(0xFF006CB5),
                                    shape: BoxShape.circle
                                ),
                                child: const Icon(Icons.task,color: Colors.white,),
                              ),
                              Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: status == 'Open' ? Colors.red :
                                    status == 'Rejected' ? Colors.red :
                                    status == 'Cancelled' ? Colors.green : Colors.green,width: 2)
                                ),
                                child: Center(
                                  child: FittedBox(
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
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Text(subject,style: const TextStyle(fontSize: 16,color: Color(0xFF006CB5)),maxLines: 3,overflow: TextOverflow.ellipsis,),
                          const SizedBox(height: 10,),
                          FittedBox(child: Text('Priority: $priority',style: const TextStyle(fontSize: 16,color: Colors.grey,fontWeight: FontWeight.bold),),),
                          const SizedBox(height: 10,),
                        const SizedBox(height: 5,),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: textFieldDecoration(),
                          child: TextFormField(
                            readOnly: true,
                              controller: model.date,
                              decoration: inputDecoration('Date', false, suffixIcon: Icon(Icons.calendar_today_outlined)),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter Date';
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
                                  model.changeDate(formattedDate);
                                } else {}
                              }
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: textFieldDecoration(),
                          child: TextFormField(
                            controller: model.description,
                            maxLines: 1,
                            decoration: inputDecoration('Description', true),
                            validator: (value){
                              if(value!.isNotEmpty) {
                                return null;
                              }
                              return 'Please provide your task update.';
                            },
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text('Owner'),
                        const SizedBox(height: 5,),
                        Container(
                          padding: const EdgeInsets.all(5),
                          width: double.infinity,
                          decoration: textFieldDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                value: model.selectedOwner,
                                onChanged: (String? newValue){
                                  model.changeOwner(newValue!);
                                },
                                items: model.ownerMenuItems
                            ),
                          ),
                        ),
                          Text('Effort'),
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            width: double.infinity,
                            decoration: textFieldDecoration(),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  value: model.selectedEffort,
                                  onChanged: (String? newValue){
                                    model.changeEffort(newValue!);
                                  },
                                  items: model.effortMenuItems
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          InkWell(
                            onTap: (){
                              if(model.formKey.currentState!.validate()){
                                Map<String,String> taskProgressData = {
                                  "parent": taskId,
                                  "parentfield": "task_progress",
                                  "parenttype": "Task",
                                  "tps_date": model.date.text != '' ? DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(model.date.text)) : '',
                                  "tps_update": model.description.text,
                                  "doctype": "Task Progress Summary",
                                  "tps_owner": model.selectedOwner,
                                  "tps_effort": model.selectedEffort
                                };
                                WebRequests().addTaskUpdate(taskProgressData).then((value) => {
                                  if(value!['success']){
                                    Get.snackbar(
                                        "Success",
                                        "Your task is updated successfully!",
                                        icon: const Icon(Icons.check, color: Colors.white),
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: const Color(0xFF67DE81),
                                        colorText: Colors.black
                                    )
                                  }else{
                                    Get.snackbar(
                                        "Oops...",
                                        value['data'].split(':')[1].trim(),
                                        icon: const Icon(Icons.cancel, color: Colors.white),
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.redAccent,
                                        colorText: Colors.black
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
                                child: Text('Update',style: TextStyle(color: Colors.white),),
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