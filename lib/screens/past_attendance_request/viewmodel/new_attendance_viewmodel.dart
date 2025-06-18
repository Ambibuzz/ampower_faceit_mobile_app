import 'package:community/base_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:community/screens/past_attendance_request/api_requests/web_requests.dart';
import '../../../locator/locator.dart';
import '../../home/viewmodel/homescreen_viewmodel.dart';

class NewAttendanceViewModel extends BaseViewModel {
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController explanation = TextEditingController();
  TextEditingController halfDayDate = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String reason = 'Work From Home';
  bool isHalfDay = false;
  HomeScreenViewModel homeScreenViewModel = locator.get<HomeScreenViewModel>();

  void clearControllerData() {
    fromDate = TextEditingController();
    toDate = TextEditingController();
    explanation = TextEditingController();
    halfDayDate = TextEditingController();
    isHalfDay = false;
  }

  List<DropdownMenuItem<String>> get dropdownReasonItems{
    List<DropdownMenuItem<String>> statuses = [
      const DropdownMenuItem(value: "On Duty", child: Text("On Duty")),
      const DropdownMenuItem(value: "Work From Home", child: Text("Work From Home")),
    ];
    return statuses;
  }

  void changeFromDate(String formattedDate) {
    fromDate.text = formattedDate;
    notifyListeners();
  }

  void changeToDate(String formattedDate) {
    toDate.text = formattedDate;
    notifyListeners();
  }

  void changeHalfDayDate(String formattedDate) {
    halfDayDate.text = formattedDate;
    notifyListeners();
  }

  void changeHalfDayValue(bool checked) {
    isHalfDay = checked;
    notifyListeners();
  }

  void changeReasonValue(String newReason) {
    reason = newReason;
    notifyListeners();
  }

  Future<bool> createAttendance() async {
    Map<String,String> attendanceData = isHalfDay ?
    {
      'from_date': fromDate.text,
      'to_date': toDate.text,
      'reason' : reason,
      'explanation': explanation.text,
      'half_day' : '1',
      'half_day_date':  DateTime.parse(fromDate.text).isBefore(DateTime.parse(toDate.text)) ? halfDayDate.text : fromDate.text,
      'company' : homeScreenViewModel.company,
      'employee' : homeScreenViewModel.empId
    }:
    {
      'from_date': fromDate.text,
      'to_date': toDate.text,
      'reason' : reason,
      'explanation': explanation.text,
      'company' : homeScreenViewModel.company,
      'employee' : homeScreenViewModel.empId
    };
    var value = await WebRequests().createNewAttendanceRequest(attendanceData);
    return value == null ? false : value['success'] ?? false;
  }
}