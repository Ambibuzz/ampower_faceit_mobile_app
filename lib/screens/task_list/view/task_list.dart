import 'package:community/base_view.dart';
import 'package:community/components/global_styles/strip_style.dart';
import 'package:community/locator/locator.dart';
import 'package:community/screens/home/viewmodel/homescreen_viewmodel.dart';
import 'package:community/screens/task_list/view/task_description.dart';
import 'package:community/screens/task_list/viewmodel/task_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../components/global_styles/text_field_design.dart';
import 'add_new_task.dart';
import 'add_new_task_progress.dart';

class TaskList extends StatelessWidget{
  HomeScreenViewModel homeScreenViewModel = locator.get<HomeScreenViewModel>();


  Widget _TaskListStrip(String description,String status,String priority,String referenceName){
    return stripStyle(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: Color(0xFF006CB5),
                              shape: BoxShape.circle
                          ),
                          child: const Icon(Icons.task,color: Colors.white,),
                        )
                      ],
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(description,style: const TextStyle(fontSize: 20,color: Color(0xFF006CB5)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          const SizedBox(height: 20,),
                          Row(
                            children: [
                              FittedBox(child: Text(priority,style: const TextStyle(fontSize: 16,color: Colors.grey,fontWeight: FontWeight.bold),),),
                              Expanded(child: Container(),),
                              //FittedBox(child: Text('${postingDate}',style: TextStyle(fontSize: 16,color: Colors.grey,fontWeight: FontWeight.bold),),)
                            ],
                          ),
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
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: status == 'Open' ? Colors.red :
                    status == 'Rejected' ? Colors.red :
                    status == 'Cancelled' ? Colors.green : Colors.green,width: 2)
                ),
                child: Text(
                  status,
                  style: TextStyle(
                      color: status == 'Open' ? const Color(0xFFC52F2F) :
                      status == 'Rejected' ? const Color(0xFFC52F2F) :
                      status == 'Cancelled' ? Colors.green : Colors.green
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: Get.context!,
                  backgroundColor: Colors.transparent,
                  isDismissible: true,
                  isScrollControlled: true,
                  builder: (btmSheetContext){
                    return StatefulBuilder(
                      builder: (context, StateSetter btmSheetState){
                        return Container(
                          height: MediaQuery.sizeOf(context).height/1.8,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AddNewTaskProgress(taskId: referenceName,empId: homeScreenViewModel.empId,subject: description,status: status,priority: priority,),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF006CB5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text('Update Task Progress',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              ),
            ),
          )
        ],
      )
    );
  }

  Widget _createNewTask(String text,context){
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
                    child: AddNewTask(),
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
    return BaseView<TaskListViewModel>(
      onModelReady: (model) async{
        model.getEmailandFetchTaskList();
        model.getAllUsers();
      },
      onModelClose: (model) async{
        model.clearValues();
      },
      builder: (context,model,child){
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: const Text('Task List',style: TextStyle(color: Colors.black),),
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
                                  children: [Column(
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
                                          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                                          width: double.infinity,
                                          decoration: textFieldDecoration(),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: model.assignedTo,
                                              onChanged: (String? newValue){
                                                btmSheetState(() {
                                                  model.assignedTo = newValue!;
                                                });
                                              },
                                              items: model.userList,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      SizedBox(
                                        height: 40,
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                                          decoration: textFieldDecoration(),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                                value: model.storyPointValue,
                                                onChanged: (String? newValue){
                                                  btmSheetState(() {
                                                    model.storyPointValue = newValue!;
                                                  });
                                                },
                                                items: model.dropdownStoryPointItems
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      SizedBox(
                                        height: 40,
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                                          decoration: textFieldDecoration(),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                                value: model.selectedStatus,
                                                onChanged: (String? newValue){
                                                  btmSheetState(() {
                                                    model.selectedStatus = newValue!;
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
                                              model.baselineStartDate.text =
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
                                              Text(model.baselineStartDate.text),
                                              const Icon(Icons.date_range,size: 18,)
                                            ],
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
                                              model.baselineEndDate.text =
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
                                              Text(model.baselineEndDate.text),
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
                                                List<String> appliedFilters = [];
                                                if(model.selectedStatus == 'All'){
                                                  appliedFilters = [
                                                    '["Task","_assign","like","%${model.assignedTo}%"],["Task","status","!=","Completed"]'
                                                  ];
                                                } else {
                                                  appliedFilters = [
                                                    '["Task","_assign","like","%${model.assignedTo}%"],["Task","status","=","${model.selectedStatus}"]'
                                                  ];
                                                }
                                                if(model.storyPointValue != 'Story Points'){
                                                  appliedFilters.add('["Task","effort","=","${model.storyPointValue}"]');
                                                }
                                                if(model.baselineStartDate.text != 'Baseline Start Date'){
                                                  appliedFilters.add('["Task","exp_start_date",">=","${DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(model.baselineStartDate.text))}"]');
                                                }
                                                if(model.baselineEndDate.text != 'Baseline End Date'){
                                                  appliedFilters.add('["Task","exp_end_date","<=","${DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(model.baselineEndDate.text))}"]');
                                                }
                                                model.getTaskListData(appliedFilters.toString());
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
                                                model.clearValues();
                                                model.getEmailandFetchTaskList();
                                                model.getAllUsers();
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
                                  )],
                                ),
                              );
                            },
                          );
                        }
                    );
                  },
                  icon: const Icon(Icons.filter_alt,color: Color(0xFF006CB5),size: 30,)
              ),
              _createNewTask('New +',context)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: model.task_list.isNotEmpty ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(model.task_list.length, (index) {
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
                                            child: TaskDescription(doc: model.task_list[index], empId: homeScreenViewModel.empId)//TodoDescription(docName: task_list[index]['name'],empId: widget.empId,),
                                        );
                                      },
                                    );
                                  }
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 2,left: 2,right: 2),
                              child: _TaskListStrip(
                                  model.task_list[index]['subject'].toString(),
                                  model.task_list[index]['status'].toString(),
                                  model.task_list[index]['priority'].toString(),
                                  model.task_list[index]['name'].toString()
                              ),
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
                        const Text('No Task Found',style: TextStyle(color: Colors.grey),),
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