import 'package:community/base_view.dart';
import 'package:community/screens/timesheet/viewmodel/editaddtimesheet_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../components/global_styles/text_field_design.dart';
import '../../../helpers/toast.dart';


class EditAddTimeSheet extends StatelessWidget{
  String selectedProject;
  var timesheets;
  var index;
  EditAddTimeSheet({super.key, 
    required this.selectedProject,
    this.timesheets,
    this.index
  });

  @override
  Widget build(BuildContext context){
    return BaseView<EditAddTimeSheetViewModel>(
      onModelReady: (model) async{
        model.initTimeSheet(timesheets, index);
        model.employeeDetails();
        model.getActivity('Activity Type', 'Timesheet Detail', selectedProject);
      },
      onModelClose: (model) async{

      },
      builder: (context,model,child){
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
                color: Colors.black
            ),
            title: const Text('New Timesheet',style: TextStyle(color: Colors.black),),
            centerTitle: true,
            backgroundColor: const Color(0xFF1E88E5),
          ),
          body: model.data == null ?
          const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(child: CupertinoActivityIndicator(),),
          ):
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
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
                            controller: model.expectedHrs,
                            keyboardType: TextInputType.number,
                            decoration: inputDecoration('Expected Hrs', true),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: textFieldDecoration(),
                          child: TextFormField(
                            controller: model.hrs,
                            keyboardType: TextInputType.number,
                            decoration: inputDecoration('Hrs', false),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                          width: double.infinity,
                          decoration: textFieldDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                value: model.selectedActivity,
                                onChanged: (String? newValue){
                                  model.changeSelectedActivityValue(newValue);
                                },
                                items: model.activityMenuItems
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
                                value: model.selectedTask,
                                onChanged: (String? newValue){
                                  model.changeSelectedTaskValue(newValue);
                                },
                                items: model.taskMenuItems
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
                                        controller: model.fromDate,
                                        decoration: inputDecoration('From Date', true),
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
                                        controller: model.toDate,
                                        decoration: inputDecoration('To Date', true),
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
                            Expanded(
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: model.isCompleted,
                                      onChanged: (value){
                                        model.changeIsCompletedValue(value);
                                      }
                                  ),
                                  Text('Completed'),
                                ],
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: model.isBillable,
                                      onChanged: (value){
                                        model.changeBillableValue(value);
                                      }
                                  ),
                                  Text('Billable'),
                                ],
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                if(model.formKey.currentState!.validate()){
                                  timesheets[index] =
                                  {
                                    'expected_hrs': model.expectedHrs.text,
                                    'hrs': model.hrs.text,
                                    'activity_type': model.selectedActivity,
                                    'from_date': model.fromDate.text,
                                    'to_date': model.toDate.text,
                                    'is_completed': model.isCompleted,
                                    'is_billable': model.isBillable,
                                    'task': model.selectedTask
                                  };
                                  Navigator.pop(context);
                                }else{
                                  fluttertoast(context, 'Something went wrong');
                                }


                              },
                              child: Container(
                                width: 100,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFF1E88E5),
                                ),
                                child: const Center(
                                  child: Text('Save',style: TextStyle(color: Colors.black),),
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
        );
      },
    );
  }
}