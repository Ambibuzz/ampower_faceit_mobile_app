import 'dart:io';
import 'package:community/base_viewmodel.dart';
import 'package:community/locator/locator.dart';
import 'package:community/screens/expense_claim/api_requests/web_requests.dart';
import 'package:community/screens/home/viewmodel/homescreen_viewmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewExpenseClaimViewModel extends BaseViewModel{
  var data;
  final formKey = GlobalKey<FormState>();
  final expenseFormKey = GlobalKey<FormState>();
  final editExpenseFormKey = GlobalKey<FormState>();
  var expenseTypeList;
  List<DropdownMenuItem<String>> expenseTypeMenuItems = [];
  List<DropdownMenuItem<String>> expenseMenuItems = [];
  TextEditingController postingDate = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
  TextEditingController expenseDate = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
  TextEditingController expenseType = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController amount = TextEditingController();
  dynamic expenses = [];
  List<dynamic>? expense_approvers = [];
  var expenseTypeValue = 'Others';
  var selectedExpenseApprover = '';
  var payableAccount = '';
  List<File> files = [];
  HomeScreenViewModel homeScreenViewModel = locator.get<HomeScreenViewModel>();

  void clearValues() {
    expenseTypeMenuItems = [];
    expenseMenuItems = [];
    postingDate = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
    expenseDate = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
    expenseType = TextEditingController();
    description = TextEditingController();
    amount = TextEditingController();
    expenses = [];
    expense_approvers = [];
    expenseTypeValue = 'Others';
    selectedExpenseApprover = '';
    payableAccount = '';
    files = [];
  }


  void pingNotifyListener() {
    notifyListeners();
  }



  void expenseTypes() async{
    expenseTypeMenuItems.clear();
    expenseTypeList = await WebRequests().getExpenseClaimType();
    for(int i=0; i<expenseTypeList.length; i++){
      expenseTypeMenuItems.add(DropdownMenuItem(value: expenseTypeList[i]['value'], child: Text(expenseTypeList[i]['value'])));
    }
  }

  void getExpenseApprover(employee) async{
    expense_approvers = await WebRequests().getExpenseApproverList(employee);
    selectedExpenseApprover = expense_approvers!.first['value'];
    for(int i=0; i<expense_approvers!.length; i++){
      expenseMenuItems.add(DropdownMenuItem(value: expense_approvers![i]['value'], child: Text(expense_approvers![i]['value'])));
    }
    notifyListeners();
  }

  void pickImages() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
      notifyListeners();
    } else {
      // User canceled the picker
    }

  }

  void uploadFiles(String docName) async{
    await WebRequests().uploadFiles(files: files,docName: docName,docType: 'Expense Claim');
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