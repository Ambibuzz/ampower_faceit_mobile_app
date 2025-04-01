import 'package:community/base_view.dart';
import 'package:community/components/global_styles/text_field_design.dart';
import 'package:community/screens/issue_tracker/view/issue_details.dart';
import 'package:community/screens/issue_tracker/viewmodel/issuetracker_viewmodel.dart';
import 'package:community/screens/issue_tracker/widgets/issue_tracker_strip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'create_issue.dart';

class IssueTracker extends StatelessWidget{

  Widget _createIssue(String text,context){
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
                    child: CreateIssue(),
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
          borderRadius: BorderRadius.circular(20),
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
    return BaseView<IssueTrackerViewModel>(
      onModelReady: (model) async{
        model.getIssueListData();
      },
      onModelClose: (model) async{
        model.selectedValue = 'All';
        model.from_date = TextEditingController(text: 'From');
        model.to_date = TextEditingController(text: 'To');
      },
      builder: (context,model,child) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: const Text('Issue List',style: TextStyle(color: Colors.black),),
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
                                              color: Colors.grey[600],
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                        ),
                                        const SizedBox(height: 20,),
                                        SizedBox(
                                          height: 40,
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(10),
                                            decoration: textFieldDecoration(),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                  value: model.selectedValue,
                                                  onChanged: (String? newValue){
                                                    btmSheetState(() {
                                                      model.selectedValue = newValue!;
                                                    });
                                                  },
                                                  items: model.dropdownItems
                                              ),
                                            ),
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
                                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                                                    btmSheetState(() {
                                                      model.from_date.text =
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
                                                      Text(model.from_date.text),
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
                                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                                                    btmSheetState(() {
                                                      model.to_date.text =
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
                                                      Text(model.to_date.text),
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
                                                  final isSelected = model.selectedValue.isNotEmpty;
                                                  final isFromDateSet = model.from_date.text != 'From';
                                                  final isToDateSet = model.to_date.text != 'To';

                                                  if (isSelected && !isFromDateSet && !isToDateSet) {
                                                    model.getIssueDataFromStatus(model.selectedValue, model.allissue_list);
                                                  } else if (!isSelected && isFromDateSet && !isToDateSet) {
                                                    model.getIssueDataFromFromDate(model.from_date.text, model.allissue_list);
                                                  } else if (!isSelected && !isFromDateSet && isToDateSet) {
                                                    model.getIssueDataFromToDate(model.to_date.text, model.allissue_list);
                                                  } else if (!isSelected && isFromDateSet && isToDateSet) {
                                                    model.getIssueDataFromDate(model.from_date.text, model.to_date.text, model.allissue_list);
                                                  } else if (isSelected && !isFromDateSet && isToDateSet) {
                                                    model.getIssueDataFromStatusAndToDate(model.selectedValue, model.to_date.text, model.allissue_list);
                                                  } else if (isSelected && isFromDateSet && !isToDateSet) {
                                                    model.getIssueDataFromStatusAndFromDate(model.selectedValue, model.from_date.text, model.allissue_list);
                                                  } else if(!isSelected){

                                                  } else {
                                                    model.getIssueDataFromStatusAndDate(model.selectedValue, model.from_date.text, model.to_date.text, model.allissue_list);
                                                  }
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
                                            const SizedBox(width: 20,),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  model.clearFilters();
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
              _createIssue('New +',context)
            ],
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.all(10),
            child:
            model.issue_list.isNotEmpty ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(model.issue_list.length, (index) {
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
                                    child: model.issue_list.isEmpty ? Container() : IssueDetails(docName: model.issue_list[index]['name']),
                                  );
                                },
                              );
                            }
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 5,right: 5,top: 2),
                        child: IssueTrackerStrip(
                          description: model.issue_list[index]['description'].toString(),
                          status: model.issue_list[index]['status'].toString(),
                          priority: model.issue_list[index]['priority'].toString(),
                        ),
                      ),
                    );
                  })

                ],
              ),
            ):Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/empty.png',height: 140,),
                const SizedBox(height: 10,),
                const Text('No Issue List Found',style: TextStyle(color: Colors.grey),),
              ],
            ),
          ),
        );
      },
    );
  }
}