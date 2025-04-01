import 'package:community/base_viewmodel.dart';
import 'package:community/screens/task_list/api_requests/web_requests.dart';
import 'package:flutter/material.dart';

import '../../../helpers/shared_preferences.dart';

class TaskListViewModel extends BaseViewModel{
  String selectedStatus = 'All';
  String storyPointValue = 'Story Points';
  String assignedTo = '';

  List<dynamic> task_list = [];
  List<dynamic> users = [];
  TextEditingController nameLike = TextEditingController(text: '');
  TextEditingController baselineStartDate = TextEditingController(text: 'Baseline Start Date');
  TextEditingController baselineEndDate = TextEditingController(text: 'Baseline End Date');
  List<DropdownMenuItem<String>> userList = [

  ];

  void clearValues() {
    selectedStatus = 'All';
    storyPointValue = 'Story Points';
    assignedTo = '';
    task_list = [];
    users = [];
    nameLike = TextEditingController(text: '');
    baselineStartDate = TextEditingController(text: 'Baseline Start Date');
    baselineEndDate = TextEditingController(text: 'Baseline End Date');
    userList = [];
    notifyListeners();
  }


  getAllUsers() async{
    users = await WebRequests().getUsers() ?? [];
    users.toSet().toList();
    for(int i=0; i<users.length; i++){
      userList.add(DropdownMenuItem(value: users[i]['name'], child: Text(users[i]['name'])));
    }
    notifyListeners();
  }


  void getTaskListData(String filter) async{
    task_list.clear();
    task_list = await WebRequests().getTaskList(filter) ?? [];
    notifyListeners();
  }

  void getEmailandFetchTaskList() async {
    var email = await getEmail();
    assignedTo = Uri.decodeComponent(email ?? '');
    getTaskListData('[["Task","_assign","like","%${assignedTo}%"],["Task","status","!=","Completed"]]');
    notifyListeners();
  }


  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "All", child: Text("All")),
      const DropdownMenuItem(value: "Draft", child: Text("Draft")),
      const DropdownMenuItem(value: "Requirement and Design", child: Text("Requirement and Design")),
      const DropdownMenuItem(value: "Development", child: Text("Development")),
      const DropdownMenuItem(value: "Verification", child: Text("Verification")),
      const DropdownMenuItem(value: "Deployment", child: Text("Deployment")),
      const DropdownMenuItem(value: "Completed", child: Text("Completed")),
      const DropdownMenuItem(value: "Suspended", child: Text("Suspended")),
      const DropdownMenuItem(value: "Overdue", child: Text("Overdue")),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownStoryPointItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Story Points", child: Text("Story Points")),
      const DropdownMenuItem(value: "1", child: Text("1")),
      const DropdownMenuItem(value: "2", child: Text("2")),
      const DropdownMenuItem(value: "3", child: Text("3")),
      const DropdownMenuItem(value: "5", child: Text("5")),
      const DropdownMenuItem(value: "8", child: Text("8")),
      const DropdownMenuItem(value: "13", child: Text("13")),
      const DropdownMenuItem(value: "21", child: Text("21")),
    ];
    return menuItems;
  }
}