import 'package:community/apis/common_api_request/common_api.dart';
import 'package:community/base_viewmodel.dart';
import 'package:community/screens/timesheet/api_requests/web_requests.dart';
import 'package:flutter/material.dart';

class NewTimeSheetViewModel extends BaseViewModel{
  var data;
  var customer;
  var currency;
  List<DropdownMenuItem<String>> customerMenuItems = [];
  List<DropdownMenuItem<String>> currencyMenuItems = [];
  List<DropdownMenuItem<String>> projectMenuItems = [];
  var selectedCustomer = "";
  var selectedCurrency = "";
  var selectedProject = "";
  var timesheets = [];



  final formKey = GlobalKey<FormState>();

  void employeeDetails() async{
    data = await CommonApiRequest().employeeDetails();
    notifyListeners();
  }

  void getCustomers(String doctype,String referenceDoctype) async{
    var customerList = await WebRequests().doctypeSearch({
      'doctype':doctype,
      'ref_doctype':referenceDoctype,
      'apply_filter':false,
    });
    if(customerList.isNotEmpty){
      selectedCustomer = customerList[0]['value'];
    }
    for(int i=0; i<customerList.length; i++){
      customerMenuItems.add(DropdownMenuItem(value: customerList[i]['value'], child: Text(customerList[i]['value'])));
    }
    getProjectList('Project', 'Timesheet');
  }

  void getCurrency(String doctype,String referenceDoctype) async{
    var currencyList = await WebRequests().doctypeSearch({
      'doctype':doctype,
      'ref_doctype':referenceDoctype,
      'apply_filter':false,
    });
    if(currencyList.isNotEmpty){
      selectedCurrency = currencyList[0]['value'];
    }
    for(int i=0; i<currencyList.length; i++){
      currencyMenuItems.add(DropdownMenuItem(value: currencyList[i]['value'], child: Text(currencyList[i]['value'])));
    }
    notifyListeners();
  }

  void getProjectList(String doctype,String referenceDoctype) async{
    var projectList = await WebRequests().doctypeSearch({
      'doctype':doctype,
      'ref_doctype':referenceDoctype,
      'apply_filter':true,
      'filter_val': '{"customer": "$selectedCustomer"}'
    });
    if(projectList.isNotEmpty){
      selectedProject = projectList[0]['value'];
    }
    for(int i=0; i<projectList.length; i++){
      projectMenuItems.add(DropdownMenuItem(value: projectList[i]['value'], child: Text(projectList[i]['value'])));
    }
    notifyListeners();
  }

  void changeSelectedProject(value) {
    selectedProject = value;
    notifyListeners();
  }

  void changeCurrency(value){
    selectedCurrency = value;
    notifyListeners();
  }

  void changeCustomer(value){
    selectedCustomer = value;
    notifyListeners();
  }
}