import 'package:community/base_view.dart';
import 'package:community/components/global_styles/text_field_design.dart';
import 'package:community/screens/expense_claim/api_requests/web_requests.dart';
import 'package:community/screens/expense_claim/viewmodel/newexpenseclaim_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../helpers/toast.dart';


class NewExpenseClaim extends StatelessWidget{
  final BuildContext bottomSheetContext;
  NewExpenseClaim({super.key,
    required this.bottomSheetContext
  });

  Future<void> _showDialog(context,model) async{
    bool isAttachmentChecked = false;
    final TextEditingController attachmentController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
              builder: (context, setState){
                return AlertDialog(
                  //scrollable: true,
                  title: const Text('Enter Expense Details'),
                  content:
                  SingleChildScrollView(
                    child:
                    Form(
                      key: model.expenseFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                                readOnly: true,
                                controller: model.expenseDate,
                                decoration: inputDecoration('Expense Date', true),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Expense Date';
                                  }
                                  return null;
                                },
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                    setState(() {
                                      model.expenseDate.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {}
                                }
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                            width: double.infinity,
                            decoration: textFieldDecoration(),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: model.expenseTypeValue,
                                  onChanged: (String? newValue){
                                    setState(() {
                                      model.expenseTypeValue = newValue!;
                                    });
                                  },
                                  items: model.expenseTypeMenuItems
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              controller: model.description,
                              decoration: inputDecoration('Description', false),
                            ),
                          ),

                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              controller: model.amount,
                              keyboardType: TextInputType.number,
                              decoration: inputDecoration('Amount', true),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Expense Amount';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Checkbox(
                                value: isAttachmentChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isAttachmentChecked = value ?? false;
                                  });
                                },
                              ),
                              const Text('Attachment'),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              controller: attachmentController,
                              decoration: inputDecoration('Attachment Name', false),
                              enabled: isAttachmentChecked, // Disable when unchecked
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Done'),
                      onPressed: () {
                        if(isAttachmentChecked == false) {
                          Get.snackbar(
                              "Error!","",
                              messageText: Text('Attachment required'),
                              icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                              snackPosition: SnackPosition.TOP,
                              duration: const Duration(seconds: 5),
                              backgroundColor: Colors.white//Color(0xFFE38080)
                          );
                          return;
                        }
                        if(model.expenseFormKey.currentState!.validate()){
                          model.expenses.add({
                            "expense_date" : model.expenseDate.text,
                            "expense_type" : model.expenseTypeValue,
                            "description" : model.description.text,
                            "amount" : model.amount.text,
                            "custom_attachment": "1",
                            "custom_attachment_name" : attachmentController.text
                          });
                          model.description.text = '';
                          model.amount.text = '';
                          Navigator.of(context).pop();
                        }else{
                          fluttertoast(context, 'Please fil all the details');
                        }

                      },
                    ),
                  ],
                );
              }
          );
        }
    );
  }

  Future<void> _showEditDialog(String date,String type,String desc,String amt,int index,context,model) async{
    TextEditingController expDate = TextEditingController();
    TextEditingController descp = TextEditingController();
    TextEditingController amnt = TextEditingController();
    final TextEditingController attachmentController = TextEditingController();
    bool isAttachmentChecked = model.expenses[index]['custom_attachment'] == '0' ? false : true;
    attachmentController.text = model.expenses[index]['custom_attachment_name'] ?? '';
    expDate.text = date;
    descp.text = desc;
    amnt.text = amt;
    String dropdownVal = type;
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
              builder: (context, setState){
                return AlertDialog(
                  title: const Text('Enter Expense Details'),
                  content: SingleChildScrollView(
                    child: Form(
                      key: model.editExpenseFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                                readOnly: true,
                                controller: expDate,
                                decoration: inputDecoration('Expense Date', true),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Expense Date';
                                  }
                                  return null;
                                },
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                    setState(() {
                                      expDate.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {}
                                }
                            ),
                          ),

                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(5),
                            width: double.infinity,
                            decoration: textFieldDecoration(),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  isExpanded: true,
                                  value: dropdownVal,
                                  onChanged: (String? newValue){
                                    setState(() {
                                      dropdownVal = newValue!;
                                    });
                                  },
                                  items: model.expenseTypeMenuItems
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              controller: descp,
                              decoration: inputDecoration('Description', false),
                            ),
                          ),

                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              controller: amnt,
                              keyboardType: TextInputType.number,
                              decoration: inputDecoration('Amount', true),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Expense Amount';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Checkbox(
                                value: isAttachmentChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isAttachmentChecked = value ?? false;
                                  });
                                },
                              ),
                              const Text('Attachment'),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: textFieldDecoration(),
                            child: TextFormField(
                              controller: attachmentController,
                              decoration: inputDecoration('Attachment Name', false),
                              enabled: isAttachmentChecked, // Disable when unchecked
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Done'),
                      onPressed: () {
                        if(model.editExpenseFormKey.currentState!.validate()){
                          model.expenses[index] = {
                            "expense_date" : expDate.text,
                            "expense_type" : dropdownVal,
                            "description" : descp.text,
                            "amount" : amnt.text,
                            "custom_attachment": isAttachmentChecked == true ? '1' : '0',
                            "custom_attachment_name" : attachmentController.text
                          };
                          descp.text = '';
                          amnt.text = '';
                          Navigator.of(context).pop();
                        }else{
                          fluttertoast(context, 'Please fil all the details');
                        }

                      },
                    ),
                  ],
                );
              }
          );
        }
    );
  }

  @override
  Widget build(BuildContext context){
    return BaseView<NewExpenseClaimViewModel>(
      onModelReady: (model) async {
        model.expenseMenuItems.clear();
        model.getExpenseApprover(model.homeScreenViewModel.empId);
        model.expenseTypes();
      },
      onModelClose: (model) async {
        model.clearValues();
      },
      builder: (context,model,child) {
        return
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: Column(
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
                const SizedBox(height: 10,),
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
                          enabled: false,
                          initialValue: model.homeScreenViewModel.empId,
                          decoration: inputDecoration('From Employee', true),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: textFieldDecoration(),
                        child: TextFormField(
                          enabled: false,
                          initialValue: model.homeScreenViewModel.name,
                          decoration: inputDecoration('Employee Name', false),
                        ),
                      ),

                      const SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: textFieldDecoration(),
                        child: TextFormField(
                            readOnly: true,
                            controller: model.postingDate,
                            decoration: inputDecoration('Posting Date', true),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Posting Date';
                              }
                              return null;
                            },
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2100));

                              if (pickedDate != null) {
                                String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                                model.changePostingDate(formattedDate);
                              } else {}
                            }
                        ),
                      ),

                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 15),
                        width: double.infinity,
                        decoration: textFieldDecoration(),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              value: model.selectedExpenseApprover,
                              onChanged: (String? newValue){
                                model.changeExpenseApproverValue(newValue);
                              },
                              items: model.expenseMenuItems
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: textFieldDecoration(),
                        child: TextFormField(
                          enabled: false,
                          initialValue: model.homeScreenViewModel.company,
                          decoration: inputDecoration('Company', true),
                        ),
                      ),

                      const SizedBox(height: 10,),
                      Text('Expense Details'),
                      const SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFFF2F2F2),
                        ),
                        child: Table(
                            border: TableBorder.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 1,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            children:[
                              TableRow( children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Column(children:[Text('Date',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)]),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Column(children:[Text('Expense Type',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)]),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Column(
                                      children:[Text('Description',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold))]
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Column(
                                      children:[Text('Amount',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)]
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Column(
                                      children:[Icon(Icons.edit,size: 16,)]
                                  ),
                                )
                              ],
                              ),
                              ...List.generate(model.expenses.length,(index) {
                                return TableRow( children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(children:[Text('${model.expenses[index]['expense_date']}',style: const TextStyle(fontSize: 12),)]),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(children:[Text('${model.expenses[index]['expense_type']}',style: const TextStyle(fontSize: 12),)]),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                        children:[Text('${model.expenses[index]['description']}',style: const TextStyle(fontSize: 12),)]
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                        children:[Text('₹${model.expenses[index]['amount']}',style: const TextStyle(fontSize: 12),)]
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                        children:[
                                          InkWell(
                                            onTap: (){

                                              _showEditDialog(
                                                  model.expenses[index]['expense_date']!,
                                                  model.expenses[index]['expense_type']!,
                                                  model.expenses[index]['description']!,
                                                  model.expenses[index]['amount']!,
                                                  index,
                                                  context,
                                                  model
                                              ).then((value) => model.pingNotifyListener());
                                            },
                                            child: const Icon(Icons.edit,size: 16,),
                                          )
                                        ]
                                    ),
                                  ),
                                ],
                                );
                              })
                            ]
                        ),
                      ),
                      const SizedBox(height: 5,),
                      InkWell(
                        onTap: (){
                          _showDialog(context,model).then((value) => model.pingNotifyListener());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF006CB5),
                          ),
                          child: const Text('Add Row',style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          model.pickImages();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 10,right: 20,top: 10,bottom: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Column(
                            children: [
                              Text('Attachments',style: TextStyle(color: Colors.grey,fontSize: 18),),
                              Icon(Icons.upload,size: 50,color: Colors.grey,),
                              SizedBox(height: 10,),
                              Text('Upload images and documents',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey),),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 5,),
                      model.files.isNotEmpty ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...List.generate(model.files.length, (index) => Row(
                            children: [

                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: textFieldDecoration(),
                                  child: Text(model.files[index].path.toString()),
                                ),
                              ),
                              IconButton(
                                onPressed: (){

                                },
                                icon: const Icon(Icons.clear),
                              )
                            ],
                          ))
                        ],
                      )
                          :Container(),

                      const SizedBox(height: 10,),
                      Row(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              if(model.formKey.currentState!.validate()){
                                Map<String,dynamic> expenseData = {
                                  "employee": model.homeScreenViewModel.empId,
                                  "expense_approver": model.selectedExpenseApprover,
                                  "posting_date": model.postingDate.text,
                                  "company": model.homeScreenViewModel.company,
                                  "expenses": model.expenses
                                };
                                WebRequests().applyForExpenseClaim(context, expenseData).then((value) => {
                                  if(value!['success']){
                                    model.uploadFiles(value['data']['name']),
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
                                              const Text('Your Expense Claim is Registered Successfully!',textAlign: TextAlign.center,),
                                              const SizedBox(height: 20),
                                              InkWell(
                                                onTap: (){
                                                  model.clearValues();
                                                  Navigator.of(Get.context!).pop();
                                                  Navigator.of(bottomSheetContext).pop();
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
                                        content: Text(value['data'].split(':')[1].trim()+" "+value['data'].split(':')[2].trim()),
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
                              width: 100,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xFF006CB5),
                              ),
                              child: const Center(
                                child: Text('Save',style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20,),
                        ],
                      )
                    ],
                  ),
                )

              ],
            ),
          ),
        );
      },
    );
  }
}