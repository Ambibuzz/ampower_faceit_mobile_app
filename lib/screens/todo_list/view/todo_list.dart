import 'package:community/base_view.dart';
import 'package:community/components/global_styles/strip_style.dart';
import 'package:community/locator/locator.dart';
import 'package:community/screens/home/viewmodel/homescreen_viewmodel.dart';
import 'package:community/screens/todo_list/viewmodel/todolist_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'create_new_todo.dart';
import 'todo_description.dart';

class TodoList extends StatelessWidget{
  HomeScreenViewModel homeScreenViewModel = locator.get<HomeScreenViewModel>();

  Widget _todoListStrip(String description,String status,String priority,String referenceName){
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: status == 'Open' ? Colors.red :
                      status == 'Rejected' ? Colors.red :
                      status == 'Cancelled' ? Colors.green : Colors.green,width: 2)
                  ),
                  child: Center(
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
              ],
            ),
          ],
        )
    );
  }

  Widget _createTodo(String text,context){
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
                    child: CreateNewTodo(),
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
    return BaseView<TodoListViewModel>(
      onModelReady: (model) async{
        model.getTodoListData();
      },
      onModelClose: (model) async{

      },
      builder: (context,model,child){
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: const Text('ToDo List',style: TextStyle(color: Colors.black),),
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
                                height: MediaQuery.sizeOf(context).height*0.4,
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                                ),
                                child: Column(
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
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFF2F2F2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                offset: const Offset(0, 1), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                              value: model.priorityValue,
                                              onChanged: (String? newValue){
                                                btmSheetState(() {
                                                  model.priorityValue = newValue!;
                                                  model.getTodoListData();
                                                });
                                              },
                                              items: model.dropdownPriorityItems
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    SizedBox(
                                      height: 40,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFF2F2F2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                offset: const Offset(0, 1), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                              value: model.selectedStatus,
                                              onChanged: (String? newValue){
                                                btmSheetState(() {
                                                  model.selectedStatus = newValue!;
                                                  model.getTodoListData();
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
                                          DateFormat('yyyy-MM-dd').format(pickedDate);
                                          btmSheetState(() {
                                            model.filterDate.text =
                                                formattedDate; //set output date to TextField value.
                                          });
                                          model.getTodoListData();
                                        } else {}
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFF2F2F2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                offset: const Offset(0, 1), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(model.filterDate.text),
                                            const Icon(Icons.date_range,size: 18,)
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    InkWell(
                                      onTap: () {
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
                                    const SizedBox(height: 10,)
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
              _createTodo('New +',context)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: model.todo_list.isNotEmpty ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(model.todo_list.length, (index) {
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
                                          child: TodoDescription(docName: model.todo_list[index]['name'],empId: homeScreenViewModel.empId,),
                                        );
                                      },
                                    );
                                  }
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 2,right: 2,top: 2),
                              child: _todoListStrip(
                                  model.todo_list[index]['description'].toString(),
                                  model.todo_list[index]['status'].toString(),
                                  model.todo_list[index]['priority'].toString(),
                                  model.todo_list[index]['reference_name'].toString()
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