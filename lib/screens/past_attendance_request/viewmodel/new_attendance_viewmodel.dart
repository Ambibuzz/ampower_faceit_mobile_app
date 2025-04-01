import 'package:community/base_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewAttendanceViewModel extends BaseViewModel {
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController explanation = TextEditingController();
  TextEditingController halfDayDate = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String reason = 'Work From Home';
  bool isHalfDay = false;
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
}