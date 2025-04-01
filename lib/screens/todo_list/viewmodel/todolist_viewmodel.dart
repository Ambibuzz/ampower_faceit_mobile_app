import 'package:community/base_viewmodel.dart';
import 'package:community/screens/todo_list/api_requests/web_requests.dart';
import 'package:flutter/material.dart';

class TodoListViewModel extends BaseViewModel{
  String selectedStatus = 'Open';
  String priorityValue = 'Medium';
  List<dynamic> todo_list = [];
  TextEditingController filterDate = TextEditingController(text: 'Due Date');

  void getTodoListData() async{
    todo_list.clear();
    String filter = '["ToDo","status","=","$selectedStatus"],["ToDo","priority","=","$priorityValue"]';
    if(filterDate.text != 'Due Date'){
      filter += ',["ToDo","date",">","${filterDate.text}"]';
    }
    todo_list = await WebRequests().getTodoList(filter) ?? [];
    notifyListeners();
  }

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

}