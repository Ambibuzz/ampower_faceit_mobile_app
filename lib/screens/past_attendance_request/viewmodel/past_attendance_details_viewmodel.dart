import 'package:community/base_viewmodel.dart';
import 'package:community/screens/home/viewmodel/homescreen_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../locator/locator.dart';

class PastAttendaceDetailsViewModel extends BaseViewModel{
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController explanation = TextEditingController();
  TextEditingController halfDayDate = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String reason = 'Work From Home';
  bool isHalfDay = false;
  var company = "";
  HomeScreenViewModel homeScreenViewModel = locator.get<HomeScreenViewModel>();
  List<DropdownMenuItem<String>> get dropdownReasonItems{
    List<DropdownMenuItem<String>> statuses = [
      const DropdownMenuItem(value: "On Duty", child: Text("On Duty")),
      const DropdownMenuItem(value: "Work From Home", child: Text("Work From Home")),
    ];
    return statuses;
  }

  void initValues(doc) {
    fromDate.text = doc['from_date'];
    toDate.text = doc['to_date'];
    reason = doc['reason'];
    explanation.text = doc['explanation'] ?? '';
    isHalfDay = doc['half_day'] == 1 ? true : false;
    halfDayDate.text = doc['half_day_date'] ?? '';
    company = homeScreenViewModel.company;
    notifyListeners();
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