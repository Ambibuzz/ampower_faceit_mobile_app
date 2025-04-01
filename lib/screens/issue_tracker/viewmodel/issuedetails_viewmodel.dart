import 'package:community/base_viewmodel.dart';
import 'package:community/screens/issue_tracker/api_requests/web_requests.dart';
import 'package:flutter/material.dart';

class IssueDetailsViewModel extends BaseViewModel{
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

  getIssueDetails(docName) async{
    var data = await WebRequests().getIssueDetails(docName);
    subject.text = data['subject'];
    selectedValueStatus = data['status'];
    selectedValuePriority = data['priority'];
    description.text = data['description'];
    notifyListeners();
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