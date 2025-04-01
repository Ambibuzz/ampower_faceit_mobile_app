import 'package:community/apis/common_api_request/common_api.dart';
import 'package:community/base_viewmodel.dart';
import 'package:community/screens/timesheet/api_requests/web_requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTimeSheetViewModel extends BaseViewModel{
  var data;
  bool isBillable = false;
  bool isCompleted = false;
  List<DropdownMenuItem<String>> activityMenuItems = [];
  List<DropdownMenuItem<String>> taskMenuItems = [];
  var selectedActivity = "";
  var selectedTask = "";
  TextEditingController expectedHrs = TextEditingController(text: '');
  TextEditingController hrs = TextEditingController(text: '');
  TextEditingController fromDate = TextEditingController(text: '');
  TextEditingController toDate = TextEditingController(text: '');



  final formKey = GlobalKey<FormState>();
  void employeeDetails() async{
    data = await CommonApiRequest().employeeDetails();
    notifyListeners();
  }

  void getActivity(String doctype,String referenceDoctype,String selectedProject) async{
    var activityList = await WebRequests().doctypeSearch({
      'doctype':doctype,
      'ref_doctype':referenceDoctype,
      'apply_filter':false,
    });
    if(activityList.isNotEmpty){
      selectedActivity = activityList[0]['value'];
    }
    for(int i=0; i<activityList.length; i++){
      activityMenuItems.add(DropdownMenuItem(value: activityList[i]['value'], child: Text(activityList[i]['value'])));
    }
    getTaskList('Task', 'Timesheet Detail',selectedProject);
  }


  void getTaskList(String doctype,String referenceDoctype,String selectedProject) async{
    var taskList = await WebRequests().doctypeSearch({
      'doctype':doctype,
      'ref_doctype':referenceDoctype,
      'apply_filter':true,
      'filter_val': '{"project":"${selectedProject}","status":["!=","Cancelled"]}'
    });
    if(taskList.isNotEmpty){
      selectedTask = taskList[0]['value'];
    }
    for(int i=0; i<taskList.length; i++){
      taskMenuItems.add(DropdownMenuItem(value: taskList[i]['value'], child: Text(taskList[i]['value'])));
    }
  }

  void changeSelectedActivityValue(value) {
    selectedActivity = value;
    notifyListeners();
  }

  void changeSelectedTaskValue(value) {
    selectedTask = value;
    notifyListeners();
  }

  void changeFromDate(formattedDate) {
    fromDate.text = formattedDate;
    notifyListeners();
  }

  void changeToDate(formattedDate) {
    toDate.text = formattedDate;
    notifyListeners();
  }

  void changeIsCompletedValue(value) {
    isCompleted = value;
    notifyListeners();
  }

  void changeBillableValue(value) {
    isBillable = value;
    notifyListeners();
  }
}