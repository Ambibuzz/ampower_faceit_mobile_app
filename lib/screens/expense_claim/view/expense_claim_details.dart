import 'package:community/base_view.dart';
import 'package:community/helpers/null_checker.dart';
import 'package:community/screens/expense_claim/api_requests/web_requests.dart';
import 'package:community/screens/expense_claim/viewmodel/expenseclaimdetails_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../components/global_styles/text_field_design.dart';
import '../../../helpers/toast.dart';


class ExpenseClaimDetails extends StatelessWidget{
  final String docName;
  final BuildContext bottomSheetContext;
  ExpenseClaimDetails({super.key,
    required this.docName,
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
                          model.data['docs'].first['expenses'].add({
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
    bool isAttachmentChecked = model.data['docs'].first['expenses'][index]['custom_attachment'].toString() == '0' ? false : true;
    attachmentController.text = model.data['docs'].first['expenses'][index]['custom_attachment_name'] ?? '';
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
                          model.data['docs'].first['expenses'][index] = {
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
    return BaseView<ExpenseClaimDetailsViewModel>(
      onModelReady: (model) async {
        model.payload = {};
        model.data = {};
        model.expenseDetails(docName,false);
        model.expenseTypes();
      },
      onModelClose: (model) async {

      },
      builder: (context,model,child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: (model.payload['docs'] == null || model.payload == {}) ?
          const Center(child: CupertinoActivityIndicator(),):
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height:6,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                model.expenseDetails(docName,true);
                                Get.snackbar(
                                  'Syncing...',
                                  'Please wait we are syncing the details',
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
                              child: Icon(Icons.refresh,color: Color(0xFF1E88E5),),
                            )
                          ],
                        )
                      ],
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
                                    context: Get.context!,
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
                          child: model.expenseMenuItems.isNotEmpty?
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                                value: model.selectedExpenseApprover,
                                onChanged: (String? newValue){
                                  model.changeExpenseApproverValue(newValue);
                                },
                                items: model.expenseMenuItems
                            ),
                          ):Container(),
                        ),

                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: textFieldDecoration(),
                          child: TextFormField(
                            enabled: false,
                            initialValue: checkForNull(model.payload['docs'].first['status'], ''),
                            decoration: inputDecoration('Status', false),
                          ),
                        ),

                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: textFieldDecoration(),
                          child: TextFormField(
                            enabled: false,
                            initialValue: model.payload['docs'].first['total_claimed_amount'].toString(),
                            decoration: inputDecoration('Total Claimed Amount', false),
                          ),
                        ),

                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: textFieldDecoration(),
                          child: TextFormField(
                            enabled: false,
                            initialValue: model.payload['docs'].first['total_sanctioned_amount'].toString(),
                            decoration: inputDecoration('Total Sanctioned Amount', false),
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
                        Text('Expenses'),
                        const SizedBox(height: 5,),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.withOpacity(0.1),
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
                                        children:[Text('Description',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,))]
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: const Column(
                                        children:[Text('Amount',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)]
                                    ),
                                  ),
                                  if(model.payload['docs'].first['workflow_state'] == 'Draft')
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Column(
                                          children:[Icon(Icons.settings,size: 16,)]
                                      ),
                                    )
                                ],
                                ),
                                ...List.generate(model.data == null ? 0 : model.data['docs'].first['expenses'].length,(index) {
                                  return TableRow( children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(children:[Text('${model.data['docs'].first['expenses'][index]['expense_date']}',style: const TextStyle(fontSize: 12),)]),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(children:[Text('${model.data['docs'].first['expenses'][index]['expense_type']}',style: const TextStyle(fontSize: 12),)]),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                          children:[Text('${model.data['docs'].first['expenses'][index]['description']}',style: const TextStyle(fontSize: 12),textAlign: TextAlign.center,)]
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                          children:[Text('₹${model.data['docs'].first['expenses'][index]['amount']}',style: const TextStyle(fontSize: 12),)]
                                      ),
                                    ),
                                    if(model.payload['docs'].first['workflow_state'] == 'Draft')
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                            children:[
                                              InkWell(
                                                onTap: (){
                                                  _showEditDialog(
                                                      model.data['docs'].first['expenses'][index]['expense_date'],
                                                      model.data['docs'].first['expenses'][index]['expense_type'],
                                                      model.data['docs'].first['expenses'][index]['description'],
                                                      model.data['docs'].first['expenses'][index]['amount'].toString(),
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
                        model.payload['docs'].first['workflow_state'] == 'Draft'?
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
                        ):Container(),
                        const SizedBox(height: 10,),
                        model.payload['docs'].first['workflow_state'] == 'Draft' ?
                        InkWell(
                          onTap: (){
                            model.uploadFiles(docName);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 10,right: 20,top: 10,bottom: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Column(
                              children: [
                                Text('Attachments',style: TextStyle(color: Colors.grey,fontSize: 18),),
                                Icon(Icons.upload,size: 50,color: Colors.grey,),
                                Text("Upload your document files",style: TextStyle(color: Colors.grey,fontSize: 18 ),),
                                SizedBox(height: 10,),
                                Text('in JPEG, PNG, ZIP and PDF',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey),),
                              ],
                            ),
                          ),
                        ):Container(),
                        Text('Attachments'),
                        const SizedBox(height: 5,),
                        model.payload['docinfo']['attachments'] != null ?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...List.generate(model.payload['docinfo']['attachments'].length, (index) => Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    padding: const EdgeInsets.all(10),
                                    decoration: textFieldDecoration(),
                                    child: Text(model.payload['docinfo']['attachments'][index]['file_name'].toString()),
                                  ),
                                ),
                                model.payload['docs'].first['workflow_state'] == 'Draft' ?
                                  IconButton(
                                    onPressed: (){
                                      WebRequests().deleteAttachements(fid: model.payload['docinfo']['attachments'][index]['name'].toString(), docName: docName,docType: 'Expense Claim').then((value) =>
                                          model.expenseDetails(docName,true)
                                      );
                                    },
                                    icon: const Icon(Icons.clear),
                                  ) :Container()
                              ],
                            ))
                          ],
                        )
                            :Container(),

                        const SizedBox(height: 10,),
                        (
                            model.payload['docs'].first['workflow_state'] != 'Draft' ||
                                model.payload['docs'].first['workflow_state'] == "In Review"
                        ) ?
                        Container():
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ...List.generate(model.workflow_actions.length, (index){
                                return InkWell(
                                  onTap: () async{
                                    var result = await WebRequests().applyWorkflowTransition(model.payload,model.workflow_actions[index]['action']);
                                    if(result['success'] == true){
                                      model.getTransitionState();
                                    }
                                  },
                                  child: Container(
                                    //width: 100,
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xFF006CB5),
                                    ),
                                    child: Center(
                                      child: Text('${model.workflow_actions[index]['action']}',style: const TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                );
                              }),
                              model.payload['docs'].first['workflow_state'] == 'Draft' ?
                              InkWell(
                                onTap: (){
                                  if(model.formKey.currentState!.validate()){
                                    WebRequests().editExpenseClaimDetails(model.data).then((value) => {
                                      if(value!['success']){
                                        showDialog(
                                          context: Get.context!,
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
                                                  const Text('Your Expense Claim has been Successfully Updated!',textAlign: TextAlign.center,),
                                                  const SizedBox(height: 20),
                                                  InkWell(
                                                    onTap: (){
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
                                          context: Get.context!,
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
                                      }
                                    });
                                  }else{
                                    fluttertoast(Get.context!, 'Something went wrong');
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
                              ):Container(),
                              const SizedBox(width: 20,),
                            ],
                          ),
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