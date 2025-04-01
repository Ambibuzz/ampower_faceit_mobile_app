import 'package:community/base_viewmodel.dart';
import 'package:community/screens/past_attendance_request/api_requests/web_requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PastAttendanceViewModel extends BaseViewModel{
  String selectedStatus = 'Open';
  String priorityValue = 'Medium';
  List<dynamic> pastAttendanceRequestList = [];
  TextEditingController fromDate = TextEditingController(text: 'From Date');
  TextEditingController toDate = TextEditingController(text: 'To Date');

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Open", child: Text("Open")),
      const DropdownMenuItem(value: "Closed", child: Text("Closed")),
      const DropdownMenuItem(value: "Cancelled", child: Text("Cancelled")),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownPriorityItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Low", child: Text("Low")),
      const DropdownMenuItem(value: "Medium", child: Text("Medium")),
      const DropdownMenuItem(value: "High", child: Text("High")),
    ];
    return menuItems;
  }

  void getPastRequestData() async{
    pastAttendanceRequestList.clear();
    String filter = "";
    pastAttendanceRequestList = await WebRequests().getPastAttendanceRequestList(filter) ?? [];
    notifyListeners();
  }

  void getPastRequestDataWithFilters() async{
    pastAttendanceRequestList.clear();
    String filter = '["Attendance Request","from_date",">=","${fromDate.text}"],["Attendance Request","to_date","<=","${toDate.text}"]';
    pastAttendanceRequestList = await WebRequests().getPastAttendanceRequestList(filter) ?? [];
    notifyListeners();
  }
}