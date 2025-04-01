import 'package:community/apis/common_api_request/common_api.dart';
import 'package:community/base_viewmodel.dart';
import 'package:community/screens/timesheet/api_requests/web_requests.dart';
import 'package:flutter/material.dart';

class EditAddTimeSheetViewModel extends BaseViewModel{
  var data;
  bool isBillable = false;
  bool isCompleted = false;
  List<DropdownMenuItem<String>> activityMenuItems = [const DropdownMenuItem(value: '-', child: Text('-'))];
  List<DropdownMenuItem<String>> taskMenuItems = [const DropdownMenuItem(value: '-', child: Text('-'))];
  var selectedActivity = "-";
  var selectedTask = "-";
  TextEditingController expectedHrs = TextEditingController();
  TextEditingController hrs = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();

  final formKey = GlobalKey<FormState>();
  void employeeDetails() async{
    data = await CommonApiRequest().employeeDetails();
    notifyListeners();
  }
  
  void initTimeSheet(timesheets,index) async{
    expectedHrs.text = timesheets[index]['expected_hrs'];
    hrs.text = timesheets[index]['hrs'];
    fromDate.text = timesheets[index]['from_date'];
    toDate.text = timesheets[index]['to_date'];
    selectedActivity = timesheets[index]['activity_type'];
    isCompleted = timesheets[index]['is_completed'].runtimeType == bool ?
    timesheets[index]['is_completed'] ? true : false :
    timesheets[index]['is_completed'] == 1 ? true : false;
    isBillable = timesheets[index]['is_billable'].runtimeType == bool ?
    timesheets[index]['is_billable'] ? true : false :
    timesheets[index]['is_billable'] == 1 ? true : false;
    notifyListeners();
  }

  void getActivity(String doctype,String referenceDoctype,String selectedProject) async{
    var activityList = await WebRequests().doctypeSearch({
      'doctype':doctype,
      'ref_doctype':referenceDoctype,
      'apply_filter':false,
    });
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