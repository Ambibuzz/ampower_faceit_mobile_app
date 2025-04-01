import 'package:community/base_viewmodel.dart';
import 'package:community/screens/task_list/api_requests/web_requests.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDescriptionViewModel extends BaseViewModel{
  TextEditingController subject = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController team = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController assignedTo = TextEditingController();
  TextEditingController assigneeName = TextEditingController();
  TextEditingController baseLineStartDate = TextEditingController();
  TextEditingController baseLineEndDate = TextEditingController();
  TextEditingController actualStartDate = TextEditingController();
  TextEditingController actualEndDate = TextEditingController();
  TextEditingController tag = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String selectedValueStatus = '';
  String selectedValuePriority = 'Medium';
  String storyPoints = '1';
  List<dynamic> taskProgress = [];
  List<dynamic> addedTags = [];
  List<dynamic> tagList = [];

  List<DropdownMenuItem<String>> get dropdownStatusItems{
    List<DropdownMenuItem<String>> statuses = [
      const DropdownMenuItem(value: "", child: Text("")),
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

  void initValues(docData) {
    selectedValueStatus = docData['status'] ?? '';
    selectedValuePriority = docData['priority'] ?? '';
    description.text = docData['description'] ?? '';
    storyPoints = docData['effort'] ?? '';
    baseLineStartDate.text = docData['exp_start_date'] == null ? '' : DateFormat('dd-MM-yyyy').format(DateTime.parse(docData['exp_start_date']));
    baseLineEndDate.text = docData['exp_end_date'] == null ? '' : DateFormat('dd-MM-yyyy').format(DateTime.parse(docData['exp_end_date']));
    actualStartDate.text = docData['actual_start_date'] == null ? '' : DateFormat('dd-MM-yyyy').format(DateTime.parse(docData['actual_start_date']));
    actualEndDate.text = docData['actual_start_date'] == null ? '' : DateFormat('dd-MM-yyyy').format(DateTime.parse(docData['actual_end_date']));
    team.text = docData['team'] ?? '';
    type.text = docData['type'] ?? '';
    assignedTo.text = docData['assigned_to'] ?? '';
    assigneeName.text = docData['assignee_name'] ?? '';
    subject.text = docData['subject'] ?? '';
    taskProgress = docData['task_progress'] ?? '';
    addedTags = docData['_user_tags'].split(',') ?? '';
    notifyListeners();
  }

  void getTaskDetails(docName) async{
    var docData = await WebRequests().getTaskDetails(docName);
    initValues(docData);
  }

  void addTags(responseTag) {
    addedTags.add(responseTag);
    notifyListeners();
  }

  void callNotifier() {
    notifyListeners();
  }

  void clearTagList() {
    tagList.clear();
    notifyListeners();
  }

  void changeStatus(value) {
    selectedValueStatus = value;
    notifyListeners();
  }

  void changePriorityValue(value){
    selectedValuePriority = value;
    notifyListeners();
  }

  void changeBaseLineStartDate(formattedDate) {
    baseLineStartDate.text = formattedDate;
    notifyListeners();
  }

  void changeBaseLineEndDate(formattedDate) {
    baseLineEndDate.text = formattedDate;
    notifyListeners();
  }

  void changeActualStartDate(formattedDate) {
    actualStartDate.text = formattedDate;
    notifyListeners();
  }

  void changeActualEndDate(formattedDate) {
    actualEndDate.text = formattedDate;
    notifyListeners();
  }

  void changeStoryPointValue(value) {
    storyPoints = value;
    notifyListeners();
  }
}