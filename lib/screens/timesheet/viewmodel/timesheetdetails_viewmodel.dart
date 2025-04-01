import 'package:community/base_viewmodel.dart';
import 'package:community/screens/timesheet/api_requests/web_requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeSheetDetailsViewModel extends BaseViewModel{
  var customer;
  var currency;
  var timesheetData;
  var timesheets = [];
  List<DropdownMenuItem<String>> customerMenuItems = [];
  List<DropdownMenuItem<String>> currencyMenuItems = [];
  List<DropdownMenuItem<String>> projectMenuItems = [];
  var selectedCustomer = "";
  var selectedCurrency = "";
  var selectedProject = "";
  final formKey = GlobalKey<FormState>();

  void getTimesheetData(name) async{
    timesheetData = await WebRequests().getTimesheetDetails(name);
    for(int i=0; i<timesheetData['time_logs'].length; i++){
      timesheets.add({
        'expected_hrs': timesheetData['time_logs'][i]['expected_hours'].toString(),
        'hrs': timesheetData['time_logs'][i]['hours'].toString(),
        'activity_type': timesheetData['time_logs'][i]['activity_type'],
        'from_date': timesheetData['time_logs'][i]['from_time'],
        'to_date': timesheetData['time_logs'][i]['to_time'],
        'is_completed': timesheetData['time_logs'][i]['completed'],
        'is_billable': timesheetData['time_logs'][i]['is_billable'],
        'task': timesheetData['time_logs'][i]['task']
      });
    }
    selectedCustomer = timesheetData['customer'];
    selectedCurrency = timesheetData['currency'];
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