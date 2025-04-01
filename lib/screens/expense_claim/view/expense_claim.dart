import '../../../base_view.dart';
import '../../../components/global_styles/strip_style.dart';
import '../../../helpers/null_checker.dart';
import '../../../screens/expense_claim/viewmodel/expenseclaim_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/global_styles/text_field_design.dart';
import 'expense_claim_details.dart';
import 'new_expense_claim.dart';


class ExpenseClaim extends StatelessWidget{

  Widget _expenseListStrip(String expenseType,String fromDate,String totalClaimedAmount,String status){
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
                      child: const Icon(Icons.currency_rupee,color: Colors.white,),
                    )
                  ],
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(expenseType,style: const TextStyle(fontSize: 16,color: Color(0xFF006CB5),fontWeight: FontWeight.bold),),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          FittedBox(child: Text('₹ $totalClaimedAmount',style: const TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.w600),),),
                          Expanded(child: Container(),),
                          FittedBox(child: Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(fromDate)),style: const TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.w600),),)
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
                borderRadius: BorderRadius.circular(20),
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

  Widget _applyForExpenses(String text,context){
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
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                    ),
                    child: NewExpenseClaim(bottomSheetContext: btmSheetContext,),
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
    return BaseView<ExpenseClaimViewModel>(
      onModelReady: (model) async {
        model.getAllClaims(false);
      },
      onModelClose: (model) async {
        model.clearFields();
      },
      builder: (context,model,child){
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: const Text('Expense Claims',style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  onPressed: () {
                    model.getAllClaims(true);
                    Get.snackbar(
                      'Syncing...',
                      'Please wait we are syncing all your expense claims',
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
                                            child: InkWell(
                                              onTap: () {
                                                final isSelected = model.selectedValue.isNotEmpty;
                                                final isFromDateSet = model.from_date.text != 'From';
                                                final isToDateSet = model.to_date.text != 'To';

                                                if (isSelected && !isFromDateSet && !isToDateSet) {
                                                  model.getExpenseDataFromStatus(model.selectedValue, model.allExpense_list);
                                                } else if (!isSelected && isFromDateSet && !isToDateSet) {
                                                  model.getExpenseDataFromFromDate(model.from_date.text, model.allExpense_list);
                                                } else if (!isSelected && !isFromDateSet && isToDateSet) {
                                                  model.getExpenseDataFromToDate(model.to_date.text, model.allExpense_list);
                                                } else if (!isSelected && isFromDateSet && isToDateSet) {
                                                  model.getExpenseDataFromDate(model.from_date.text, model.to_date.text, model.allExpense_list);
                                                } else if (isSelected && !isFromDateSet && isToDateSet) {
                                                  model.getExpenseDataFromStatusAndToDate(model.selectedValue, model.to_date.text, model.allExpense_list);
                                                } else if (isSelected && isFromDateSet && !isToDateSet) {
                                                  model.getExpenseDataFromStatusAndFromDate(model.selectedValue, model.from_date.text, model.allExpense_list);
                                                } else if(!isSelected) {

                                                }else {
                                                  model.getExpenseDataFromStatusAndDate(model.selectedValue, model.from_date.text, model.to_date.text, model.allExpense_list);
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
              _applyForExpenses('New +',context)
            ],
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Expanded(
                  child: model.expense_list.isNotEmpty ?
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(model.expense_list.length, (index) {
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
                                            child: ExpenseClaimDetails(docName: checkForNull(model.expense_list[index]['name'], ''),bottomSheetContext: btmSheetContext,),
                                        );
                                      },
                                    );
                                  }
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10,right: 10,top: 2),
                              child: _expenseListStrip(
                                  checkForNull(model.expense_list[index]['employee_name'], ''),
                                  checkForNull(model.expense_list[index]['posting_date'], '1972-01-01'),
                                  checkForNull(model.expense_list[index]['total_claimed_amount'], 0).toString(),
                                  checkForNull(model.expense_list[index]['workflow_state'], '')
                              ),
                            ),
                          );
                        })

                      ],
                    ),
                  ):Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/empty.png',height: 140,),
                      const SizedBox(height: 10,),
                      const Text('No Expense Claim Found',style: TextStyle(color: Colors.grey),),
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