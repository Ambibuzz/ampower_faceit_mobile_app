import 'package:community/base_viewmodel.dart';
import 'package:community/screens/todo_list/api_requests/web_requests.dart';
import 'package:flutter/material.dart';

class TodoDescriptionViewModel extends BaseViewModel{
  TextEditingController dueDate = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController referenceType = TextEditingController();
  TextEditingController referenceName = TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController assignedBy = TextEditingController();
  TextEditingController assignedByFullName = TextEditingController();
  bool isReferenceTypeListVisible = false;
  bool isReferenceNameListVisible = false;
  bool isRoleListVisible = false;
  bool isAssignedByVisible = false;
  final formKey = GlobalKey<FormState>();
  String selectedValueStatus = 'Open';
  String selectedValuePriority = 'Medium';
  String allocateTo = '';
  List<dynamic> referenceTypeList = [];
  List<dynamic> referenceNameList = [];
  List<dynamic> roleList = [];
  List<dynamic> users = [];
  List<DropdownMenuItem<String>> allocatedTo = [

  ];

  List<DropdownMenuItem<String>> get dropdownStatusItems{
    List<DropdownMenuItem<String>> statuses = [
      const DropdownMenuItem(value: "Open", child: Text("Open")),
      const DropdownMenuItem(value: "Closed", child: Text("Closed")),
      const DropdownMenuItem(value: "Cancelled", child: Text("Cancelled")),
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

  void getAllUsers() async{
    users = await WebRequests().getUsers() ?? [];
    users.toSet().toList();
    for(int i=0; i<users.length; i++){
      allocatedTo.add(DropdownMenuItem(value: users[i]['name'], child: Text(users[i]['name'])));
    }
  }

  void getTodoDetails(docName) async{
    var docData = await WebRequests().getTodoDetails(docName);
      selectedValueStatus = docData['status'];
      selectedValuePriority = docData['priority'];
      allocateTo = docData['owner'];
      dueDate.text = docData['date'];
      description.text = docData['description'];
      referenceType.text = docData['reference_type'];
      referenceName.text = docData['reference_name'];
      role.text = docData['role'] ?? '';
      assignedBy.text = docData['assigned_by'];
      notifyListeners();
  }

  void pingNotifyListener() {
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

  void changeDueDate(formattedDate){
    dueDate.text = formattedDate;
    notifyListeners();
  }

  void changeAllocatedToValue(value) {
    allocateTo = value;
    notifyListeners();
  }

  void changeReferenceTypeListVisibility(value) {
    isReferenceTypeListVisible = value;
    notifyListeners();
  }

  void chagneReferenceNameListVisibility(value) {
    isReferenceNameListVisible = value;
    notifyListeners();
  }

  void changeRoleListVisibility(value) {
    isRoleListVisible = value;
    notifyListeners();
  }

  void changeAssignedByVisibility(value){
    isAssignedByVisible = value;
    notifyListeners();
  }

  void changeAssignedBy(value) {
    assignedBy.text = value;
    notifyListeners();
  }
}