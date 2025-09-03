import 'package:community/components/global_styles/strip_style.dart';
import 'package:community/helpers/null_checker.dart';
import 'package:community/locator/locator.dart';
import 'package:community/router/routing_constants.dart';
import 'package:community/screens/doc_details/view/doc_renderer.dart';
import 'package:community/screens/home/viewmodel/homescreen_viewmodel.dart';
import 'package:community/screens/leave_application/viewmodel/leaveapplication_viewmodel.dart';
import 'package:community/base_view.dart';
import 'package:community/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/global_styles/text_field_design.dart';
import 'apply_for_leave.dart';
import 'leave_details.dart';

class LeaveApplication extends StatelessWidget{
  HomeScreenViewModel homeScreenViewModel = locator.get<HomeScreenViewModel>();

  Widget _leaveListStrip(String leaveType,String fromDate,String totalLeaveDays,String status){
    return stripStyle(
        child: Row(
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
                        child: const Icon(Icons.logout,color: Colors.white,),
                      )
                    ],
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(leaveType,style: const TextStyle(fontSize: 16,color: Color(0xFF006CB5),fontWeight: FontWeight.bold),),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            FittedBox(child: Text('$totalLeaveDays Day',style: const TextStyle(fontSize: 14,color: Colors.grey,),),),
                            Expanded(child: Container(),),
                            FittedBox(child: Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(fromDate)),style: const TextStyle(fontSize: 14,color: Colors.grey,),),)
                          ],
                        )
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
                  status == 'Cancelled' ? Colors.green : Colors.green,width: 1)
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
        )
    );
  }

  Widget _applyForLeave(String text,context){
    return InkWell(
      onTap: (){
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            isDismissible: true,
            builder: (btmSheetContext){
              return StatefulBuilder(
                builder: (context, StateSetter btmSheetState){
                  return SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height/2,
                      padding: EdgeInsets.only(top:10,left:10,right: 10, bottom: MediaQuery.of(context).viewInsets.bottom,),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                      ),
                      child: ApplyForLeave(bottomSheetContext: btmSheetContext,),
                    ),
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
    return BaseView<LeaveApplicationViewModel>(
      onModelReady: (model) async {
        model.getAllLeaves(false);
        model.getLeaveBalance(homeScreenViewModel.empId);
      },
      onModelClose: (model) async {
        model.clearFields();
      },
      builder: (context,model,child) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: const Text('Leave History',style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  onPressed: () {
                    model.getAllLeaves(true);
                    Get.snackbar(
                      'Syncing...',
                      'Please wait we are syncing all your leaves',
                      backgroundColor: const Color(0xFF006CB5),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 5),
                      icon: const Icon(
                        Icons.sync,
                        color: Colors.white,
                      ),
                      mainButton: TextButton(
                        onPressed: () => Get.back(), // Close the snackbar if needed
                        child: const Text(
                          'Dismiss',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      showProgressIndicator: true, // Shows a linear progress indicator
                      progressIndicatorBackgroundColor: Colors.white24,
                    );
                  },
                  icon: const Icon(Icons.refresh,color: Color(0xFF006CB5),size: 30,)
              ),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        backgroundColor: Colors.transparent,
                        isDismissible: true,
                        builder: (btmSheetContext){
                          return StatefulBuilder(
                            builder: (context, StateSetter btmSheetState){
                              return SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(top:10,left:10,right: 10, bottom: MediaQuery.of(context).viewInsets.bottom,),
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
                                            color: Colors.grey[600],
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      SizedBox(
                                        height: 50,
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(width: 1,color: Colors.grey),
                                              borderRadius: BorderRadius.circular(20)
                                          ),
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
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 5,),
                                                Container(
                                                  padding: const EdgeInsets.all(5),
                                                  decoration: textFieldDecoration(),
                                                  child: TextFormField(
                                                      readOnly: true,
                                                      controller: model.from_date,
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
                                                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                                          btmSheetState(() {
                                                            model.from_date.text =
                                                                formattedDate; //set output date to TextField value.
                                                          });
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
                                                      controller: model.to_date,
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
                                                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                                          btmSheetState(() {
                                                            model.to_date.text =
                                                                formattedDate; //set output date to TextField value.
                                                          });
                                                        } else {}
                                                      }
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 20,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child:InkWell(
                                              onTap: () {
                                                final isSelected = model.selectedValue.isNotEmpty;
                                                final isFromDateSet = model.from_date.text != 'From';
                                                final isToDateSet = model.to_date.text != 'To';

                                                if (isSelected && !isFromDateSet && !isToDateSet) {
                                                  model.getLeaveDataFromStatus(model.selectedValue, model.allLeave_list);
                                                } else if (!isSelected && isFromDateSet && !isToDateSet) {
                                                  model.getLeaveDataFromFromDate(model.from_date.text, model.allLeave_list);
                                                } else if (!isSelected && !isFromDateSet && isToDateSet) {
                                                  model.getLeaveDataFromToDate(model.to_date.text, model.allLeave_list);
                                                } else if (!isSelected && isFromDateSet && isToDateSet) {
                                                  model.getLeaveDataFromDate(model.from_date.text, model.to_date.text, model.allLeave_list);
                                                } else if (isSelected && !isFromDateSet && isToDateSet) {
                                                  model.getLeaveDataFromStatusAndToDate(model.selectedValue, model.to_date.text, model.allLeave_list);
                                                } else if (isSelected && isFromDateSet && !isToDateSet) {
                                                  model.getLeaveDataFromStatusAndFromDate(model.selectedValue, model.from_date.text, model.allLeave_list);
                                                } else if(!isSelected) {

                                                } else {
                                                  model.getLeaveDataFromStatusAndDate(model.selectedValue, model.from_date.text, model.to_date.text, model.allLeave_list);
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
                                          const SizedBox(width: 10,),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                model.clearFields();
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
                                  ),
                                ),
                              );
                            },
                          );
                        }
                    );
                  },
                  icon: const Icon(Icons.filter_alt,color: Color(0xFF006CB5),size: 30,)
              ),
              _applyForLeave('New +',context)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Leave Balance',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Color(0xFF006CB5)),),
                    Expanded(child: Container(),),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            isDismissible: true,
                            builder: (btmSheetContext){
                              return StatefulBuilder(
                                builder: (context, StateSetter btmSheetState){
                                  return Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
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
                                          child: Container(
                                            // height: MediaQuery.sizeOf(context).height*0.4,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                                            ),
                                            child: model.balance.isNotEmpty && (checkForNull(model.balance['success'], false) && model.leave_balance.isNotEmpty)?
                                            GridView.count(
                                              crossAxisCount: 2,
                                              childAspectRatio:1,
                                              children: [
                                                ...List.generate(model.leave_balance.length, (index) {
                                                  return Container(
                                                    margin: const EdgeInsets.only(top: 10,right: 10,bottom: 10,left: 2),
                                                    padding: const EdgeInsets.all(20),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              spreadRadius: 3,
                                                              blurRadius: 1,
                                                              color: Colors.grey.withOpacity(0.3)
                                                          )
                                                        ]
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            SizedBox(
                                                              height: MediaQuery.sizeOf(context).shortestSide*0.18,
                                                              width: MediaQuery.sizeOf(context).shortestSide*0.18,
                                                              child: CircularProgressIndicator(
                                                                value: (checkForNull<double>(model.leave_balance[index]['data']['leaves_taken'], 0) / checkForNull<double>(model.leave_balance[index]['data']['total_leaves'], 1)).clamp(0.0, 1.0),
                                                                strokeWidth: 8,
                                                                backgroundColor: Color(0xFFFF731D),
                                                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.grey),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: MediaQuery.sizeOf(context).shortestSide*0.18,
                                                              width: MediaQuery.sizeOf(context).shortestSide*0.18,
                                                              child: Container(
                                                                padding: const EdgeInsets.all(10),
                                                                child: Center(
                                                                  child: Text('${model.leave_balance[index]['data']['total_leaves']-model.leave_balance[index]['data']['remaining_leaves']}/${checkForNull(model.leave_balance[index]['data']['total_leaves'], '0')}',style: const TextStyle(color: Color(0xFF006CB5),fontWeight: FontWeight.bold,fontSize: 10),),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 10,),
                                                        Text('${checkForNull(model.leave_balance[index]['type'], '')}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Color(0xFF006CB5)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                        const SizedBox(height: 5,),
                                                        Text('Used - ${checkForNull(model.leave_balance[index]['data']['leaves_taken'], '0')}',style: const TextStyle(fontSize: 12,color: Color(0xFFFF731D)),),
                                                      ],
                                                    ),
                                                  );
                                                })
                                              ],
                                            ):Container(),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            width:double.infinity,
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
                      child: const Row(
                        children: [
                          Text('view all',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Color(0xFF006CB5)),),
                          SizedBox(width: 5,),
                          Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Color(0xFF006CB5)
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                model.balance.isNotEmpty && (checkForNull(model.balance['success'], false) && model.leave_balance.isNotEmpty)?
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...List.generate(model.leave_balance.length, (index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 10,right: 10,bottom: 10,left: 2),
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.sizeOf(context).width*.45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 3,
                                    blurRadius: 1,
                                    color: Colors.grey.withOpacity(0.3)
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.sizeOf(context).shortestSide*0.18,
                                    width: MediaQuery.sizeOf(context).shortestSide*0.18,
                                    child: CircularProgressIndicator(
                                      value: (checkForNull<double>(model.leave_balance[index]['data']['leaves_taken'], 0.0) / checkForNull<double>(model.leave_balance[index]['data']['total_leaves'], 1.0)).clamp(0.0, 1.0),
                                      strokeWidth: 8,
                                      backgroundColor: Color(0xFFFF731D),
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.grey),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.sizeOf(context).shortestSide*0.18,
                                    width: MediaQuery.sizeOf(context).shortestSide*0.18,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Center(
                                        child: Text('${model.leave_balance[index]['data']['total_leaves']-model.leave_balance[index]['data']['remaining_leaves']}/${checkForNull(model.leave_balance[index]['data']['total_leaves'], '0')}',style: const TextStyle(color: Color(0xFF006CB5),fontWeight: FontWeight.bold,fontSize: 10),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Text('${checkForNull(model.leave_balance[index]['type'], '')}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Color(0xFF006CB5)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                              const SizedBox(height: 5,),
                              Text('Used - ${checkForNull(model.leave_balance[index]['data']['leaves_taken'], '0')}',style: const TextStyle(fontSize: 12,color: Color(0xFFFF731D)),),
                            ],
                          ),
                        );
                      })
                    ],
                  ),
                ):Container(),
                const  SizedBox(height: 10,),
                Expanded(
                  child: model.leave_list.isNotEmpty ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5,bottom: 5,left: 2,right: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(model.leave_list.length, (index) {
                            return InkWell(
                              onTap: (){
                                locator.get<NavigationService>().navigateTo(docDetailsScreen,arguments: {
                                  'doctype': 'Leave Application',
                                  'reference_name': model.leave_list[index]['name'],
                                });
                              },
                              child: _leaveListStrip(
                                checkForNull(model.leave_list[index]['leave_type'], ''),
                                checkForNull(model.leave_list[index]['from_date'], ''),
                                checkForNull(model.leave_list[index]['total_leave_days'], '0.0').toString(),
                                checkForNull(model.leave_list[index]['workflow_state'], ''),
                              ),
                            );
                          })

                        ],
                      ),
                    ),
                  ):Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/empty.png',height: 140,),
                      const SizedBox(height: 10,),
                      const Text('No Leave Application Found',style: TextStyle(color: Colors.grey),),
                      const SizedBox(height:10,),
                    ],
                  ),
                )
              ],
            ),
          )
        );
      },
    );
  }
}