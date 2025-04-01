import 'package:community/base_viewmodel.dart';
import 'package:flutter/material.dart';

class CreateIssueViewModel extends BaseViewModel{
  TextEditingController description = TextEditingController();
  TextEditingController subject = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String selectedValueStatus = 'Open';
  String selectedValuePriority = 'Medium';


  List<DropdownMenuItem<String>> get dropdownStatusItems{
    List<DropdownMenuItem<String>> statuses = [
      const DropdownMenuItem(value: "Open", child: Text("Open")),
      const DropdownMenuItem(value: "Replied", child: Text("Replied")),
      const DropdownMenuItem(value: "On Hold", child: Text("On Hold")),
      const DropdownMenuItem(value: "Resolved", child: Text("Resolved")),
      const DropdownMenuItem(value: "Closed", child: Text("Closed")),
    ];
    return statuses;
  }

  List<DropdownMenuItem<String>> get dropdownPriorityItems{
    List<DropdownMenuItem<String>> priorities = [
      const DropdownMenuItem(value: "High", child: Text("High")),
      const DropdownMenuItem(value: "Medium", child: Text("Medium")),
      const DropdownMenuItem(value: "Low", child: Text("Low")),
    ];
    return priorities;
  }

  void clearFields() {
    description = TextEditingController();
    subject = TextEditingController();
  }

  void changeStatusValue(value) {
    selectedValueStatus = value;
    notifyListeners();
  }

  void changePriorityValue(value) {
    selectedValuePriority = value;
    notifyListeners();
  }
}