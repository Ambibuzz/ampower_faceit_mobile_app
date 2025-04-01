import 'package:community/apis/common_api_request/common_api.dart';
import 'package:community/base_viewmodel.dart';
import 'package:community/screens/leave_application/api_requests/web_requests.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ApplyForLeaveViewModel extends BaseViewModel{
  var data;
  var leaveTypes;
  List<DropdownMenuItem<String>> leaveTypeMenuItems = [];
  var leaveTypeValue = "Casual Leave";
  var isHalfDay = false;
  TextEditingController fromDate = TextEditingController(text: "");
  TextEditingController toDate = TextEditingController(text: "");
  TextEditingController reason = TextEditingController(text: "");
  TextEditingController postingDate = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
  TextEditingController halfDayDate = TextEditingController(text: "");
  dynamic employeeData = null;

  void initAllVariables() {
     leaveTypeMenuItems = [];
    leaveTypeValue = "Casual Leave";
    isHalfDay = false;
    fromDate = TextEditingController(text: "");
    toDate = TextEditingController(text: "");
    reason = TextEditingController(text: "");
    postingDate = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
    halfDayDate = TextEditingController(text: "");
    employeeData = null;
    notifyListeners();
  }


  final formKey = GlobalKey<FormState>();
  void employeeDetails() async{
    employeeData = await CommonApiRequest().employeeDetails();
    notifyListeners();
  }

  void leaveTypeList() async{
    var leaveTypeData = await WebRequests().getLeaveTypes();
    for(int i=0; i<leaveTypeData['data'].length; i++){
      leaveTypeMenuItems.add(DropdownMenuItem(
          value: leaveTypeData['data'][i]['name'],
          child: Text(leaveTypeData['data'][i]['name'])
      ));
    }
    notifyListeners();
  }

  void changeLeaveTypeValue(value) {
    leaveTypeValue = value;
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

  void changeIsHalfDay(value) {
    isHalfDay = value;
    notifyListeners();
  }

  void changeHalfDayDate(formattedDate) {
    halfDayDate.text = formattedDate;
    notifyListeners();
  }

  void changePostingDate(formattedDate) {
    postingDate.text = formattedDate;
    notifyListeners();
  }
}