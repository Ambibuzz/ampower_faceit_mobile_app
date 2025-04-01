import 'package:community/base_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNewTaskViewModel extends BaseViewModel{
  TextEditingController subject = TextEditingController(text: '');
  TextEditingController description = TextEditingController(text: '');
  TextEditingController assignedTo = TextEditingController(text: '');
  TextEditingController baseLineStartDate = TextEditingController(text: 'Baseline Start Date');
  TextEditingController baseLineEndDate = TextEditingController(text: 'Baseline End Date');

  final formKey = GlobalKey<FormState>();
  String selectedValueStatus = 'Draft';
  String selectedValuePriority = 'Medium';
  String storyPoints = '1';

  void setAssignedTo(empId) {
    assignedTo.text = empId;
    notifyListeners();
  }

  void changeStoryPointValue(value) {
    storyPoints = value;
    notifyListeners();
  }

  void changeStatus(value) {
    selectedValueStatus = value;
    notifyListeners();
  }

  void changePriority(value) {
    selectedValuePriority = value;
    notifyListeners();
  }

  void changeBaseLineStartDate(String formattedDate) {
    baseLineStartDate.text = formattedDate;
    notifyListeners();
  }

  void changeBaseLineEndDate(String formattedDate) {
    baseLineEndDate.text = formattedDate;
    notifyListeners();
  }


  List<DropdownMenuItem<String>> get dropdownStatusItems{
    List<DropdownMenuItem<String>> statuses = [
      const DropdownMenuItem(value: "Draft", child: Text("Draft")),
      const DropdownMenuItem(value: "Requirement and Design", child: Text("Requirement and Design")),
      const DropdownMenuItem(value: "Development", child: Text("Development")),
      const DropdownMenuItem(value: "Verification", child: Text("Verification")),
      const DropdownMenuItem(value: "Deployment", child: Text("Deployment")),
      const DropdownMenuItem(value: "Completed", child: Text("Completed")),
      const DropdownMenuItem(value: "Suspended", child: Text("Suspended")),
      const DropdownMenuItem(value: "Overdue", child: Text("Overdue")),
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

  List<DropdownMenuItem<String>> get dropdownStoryPoints{
    List<DropdownMenuItem<String>> storyPoints = [
      const DropdownMenuItem(value: "1", child: Text("1")),
      const DropdownMenuItem(value: "2", child: Text("2")),
      const DropdownMenuItem(value: "3", child: Text("3")),
      const DropdownMenuItem(value: "5", child: Text("5")),
      const DropdownMenuItem(value: "8", child: Text("8")),
      const DropdownMenuItem(value: "13", child: Text("13")),
      const DropdownMenuItem(value: "21", child: Text("21")),
    ];
    return storyPoints;
  }
}