import 'dart:convert';
import 'dart:io';
import 'package:community/base_viewmodel.dart';
import 'package:community/locator/locator.dart';
import 'package:community/screens/expense_claim/api_requests/web_requests.dart';
import 'package:community/screens/expense_claim/cache/expense_claim_cache.dart';
import 'package:community/screens/home/viewmodel/homescreen_viewmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseClaimDetailsViewModel extends BaseViewModel{
  var data;
  final formKey = GlobalKey<FormState>();
  final expenseFormKey = GlobalKey<FormState>();
  var expenseTypeList;
  List<DropdownMenuItem<String>> expenseTypeMenuItems = [];
  List<DropdownMenuItem<String>> expenseMenuItems = [];
  TextEditingController postingDate = TextEditingController();
  List<File>? files = [];
  List<dynamic>? uploaded_files = [];
  final editExpenseFormKey = GlobalKey<FormState>();
  TextEditingController expenseDate = TextEditingController();
  TextEditingController expenseType = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController amount = TextEditingController();
  List<Map<String,String>> expenses = [];
  var expenseTypeValue = 'Others';
  var selectedExpenseApprover = '';
  List<dynamic>? expense_approvers = [];
  var workflow = {};
  var workflow_actions = [];
  var payload = {};
  HomeScreenViewModel homeScreenViewModel = locator.get<HomeScreenViewModel>();

  void pingNotifyListener() {
    notifyListeners();
  }


  void expenseDetails(String docName,bool force) async{
    var tempDetails = await ExpenseClaimCache().getExpenseClaimDetailsFromCache(docName);
    if(tempDetails == false || force){
      tempDetails = await WebRequests().getExpenseClaimDetails(docName);
      await ExpenseClaimCache().putExpenseClaimDetailsInCache(docName, tempDetails);
      payload = tempDetails;
      data = tempDetails;
      initExpenseDetails(payload);
    } else {
      payload = jsonDecode(tempDetails);
      data = payload;
      initExpenseDetails(payload);
    }
  }

  void initExpenseDetails(details) async {
    selectedExpenseApprover = details['docs'].first['expense_approver'];
    getExpenseApprover(homeScreenViewModel.empId);
    postingDate.text = DateFormat('yyyy-MM-dd').format(DateTime.parse(details['docs'].first['posting_date']));
    if(details['docs'].first['status'] == "Draft"){
      getTransitionState();
    }
    notifyListeners();
  }

  void expenseTypes() async{
    expenseTypeMenuItems.clear();
    expenseTypeList = await WebRequests().getExpenseClaimType();
    for(int i=0; i<expenseTypeList.length; i++){
      expenseTypeMenuItems.add(DropdownMenuItem(value: expenseTypeList[i]['value'], child: Text(expenseTypeList[i]['value'])));
    }
    notifyListeners();
  }
  void getExpenseApprover(employee) async{
    expenseMenuItems.clear();
    expense_approvers = await WebRequests().getExpenseApproverList(employee);
    for(int i=0; i<expense_approvers!.length; i++){
      expenseMenuItems.add(DropdownMenuItem(value: expense_approvers![i]['value'], child: Text(expense_approvers![i]['value'])));
    }
    notifyListeners();
  }

  void getTransitionState() async{
    workflow_actions.clear();
    workflow = await WebRequests().getWorkflowTransition(payload);
    if(workflow['success'] == true){
      for(int i=0; i<workflow['message'].length; i++){
        workflow_actions.add({
          'action': workflow['message'][i]['action'],
          'next_state': workflow['message'][i]['next_state']
        });
      }
    }
    notifyListeners();
  }

  Future<List<File>?> pickImages() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      return files;
    } else {
      // User canceled the picker
    }
    return null;

  }

  void uploadFiles(docName) async{
    files = await pickImages();
    int result = await WebRequests().uploadFiles(files: files!,docName: docName,docType: 'Expense Claim');
    expenseDetails(docName,true);
    if(result > 0){
      notifyListeners();
    }
  }

  void changeExpenseDate(formattedDate) {
    expenseDate.text = formattedDate;
    notifyListeners();
  }

  void changePostingDate(formattedDate){
    postingDate.text = formattedDate;
    notifyListeners();
  }

  void changeExpenseApproverValue(value) {
    selectedExpenseApprover = value;
    notifyListeners();
  }
}