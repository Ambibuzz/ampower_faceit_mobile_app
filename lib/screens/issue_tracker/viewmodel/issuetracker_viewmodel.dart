import 'package:community/base_viewmodel.dart';
import 'package:community/screens/issue_tracker/api_requests/web_requests.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IssueTrackerViewModel extends BaseViewModel{
  String selectedValue = 'All';
  List<dynamic> issue_list = [];
  List<dynamic> allissue_list = [];
  TextEditingController from_date = TextEditingController(text: 'From');
  TextEditingController to_date = TextEditingController(text: 'To');

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "All", child: Text("All")),
      const DropdownMenuItem(value: "Open", child: Text("Open")),
      const DropdownMenuItem(value: "Replied", child: Text("Replied")),
      const DropdownMenuItem(value: "On Hold", child: Text("On Hold")),
      const DropdownMenuItem(value: "Resolved", child: Text("Resolved")),
      const DropdownMenuItem(value: "Closed", child: Text("Closed")),
    ];
    return menuItems;
  }

  void clearFilters() {
    selectedValue = 'All';
    from_date = TextEditingController(text: 'From');
    to_date = TextEditingController(text: 'To');
    getIssueListData();
    notifyListeners();
  }

  void getIssueListData() async{
    issue_list.clear();
    allissue_list = await WebRequests().getIssueList() ?? [];
    getIssueDataFromStatus(selectedValue, allissue_list);
  }

  Future<void> getIssueDataFromStatus(String status,List<dynamic> issues) async{
    issue_list.clear();
    if(status == 'All'){
      issue_list.addAll(issues);
      notifyListeners();
      return;
    }
    for (var element in issues) {
      if(element['status'] == status){
        issue_list.add(element);
      }
    }
    notifyListeners();
  }

  Future<void> getIssueDataFromStatusAndDate(String status,String fromDate,String toDate,List<dynamic> issues) async{
    DateFormat format = DateFormat("dd-MM-yyyy");
    DateTime from = format.parse(fromDate);
    DateTime to = format.parse(toDate);
    issue_list.clear();
    if(status == 'All') {
      for (var element in issues) {
        if((DateTime.parse(element['creation']).isAfter(from.subtract(Duration(days: 1))) && DateTime.parse(element['creation']).isBefore(to.add(Duration(days: 1))) )){
          issue_list.add(element);
        }
      }
    } else {
      for (var element in issues) {
        if(element['status'] == status && (DateTime.parse(element['creation']).isAfter(from.subtract(Duration(days: 1))) && DateTime.parse(element['creation']).isBefore(to.add(Duration(days: 1))) )){
          issue_list.add(element);
        }
      }
    }
    notifyListeners();
  }

  Future<void> getIssueDataFromDate(String fromDate,String toDate,List<dynamic> issues) async{
    DateFormat format = DateFormat("dd-MM-yyyy");
    DateTime from = format.parse(fromDate);
    DateTime to = format.parse(toDate);
    issue_list.clear();
    for (var element in issues) {
      if((DateTime.parse(element['creation']).isAfter(from.subtract(Duration(days: 1))) && DateTime.parse(element['creation']).isBefore(to.add(Duration(days: 1))) )){
        issue_list.add(element);
      }
    }
    notifyListeners();
  }

  Future<void> getIssueDataFromFromDate(String fromDate,List<dynamic> issues) async{
    DateFormat format = DateFormat("dd-MM-yyyy");
    DateTime from = format.parse(fromDate);
    // Create new DateTime objects with only year, month, and day
    DateTime fromDateOnly = DateTime(from.year, from.month, from.day);
    issue_list.clear();
    for (var element in issues) {
      DateTime tempCreationDate = DateTime.parse(element['creation']);
      DateTime creationDate = DateTime(tempCreationDate.year, tempCreationDate.month, tempCreationDate.day);
      if(creationDate.isAfter(fromDateOnly)){
        issue_list.add(element);
      }
    }
    notifyListeners();
  }

  Future<void> getIssueDataFromToDate(String toDate,List<dynamic> issues) async{
    DateFormat format = DateFormat("dd-MM-yyyy");
    DateTime to = format.parse(toDate);
    // Create new DateTime objects with only year, month, and day
    DateTime toDateOnly = DateTime(to.year, to.month, to.day);
    issue_list.clear();
    for (var element in issues) {
      DateTime tempCreationDate = DateTime.parse(element['creation']);
      DateTime creationDate = DateTime(tempCreationDate.year, tempCreationDate.month, tempCreationDate.day);
      if(creationDate.isBefore(toDateOnly)){
        issue_list.add(element);
      }
    }
    notifyListeners();
  }

  Future<void> getIssueDataFromStatusAndFromDate(String status,String fromDate,List<dynamic> issues) async{
    DateFormat format = DateFormat("dd-MM-yyyy");
    DateTime from = format.parse(fromDate);
    // Create new DateTime objects with only year, month, and day
    DateTime fromDateOnly = DateTime(from.year, from.month, from.day);
    issue_list.clear();
    if(status == 'All') {
      for (var element in issues) {
        DateTime tempCreationDate = DateTime.parse(element['creation']);
        DateTime creationDate = DateTime(tempCreationDate.year, tempCreationDate.month, tempCreationDate.day);
        if(fromDateOnly.isAtSameMomentAs(creationDate)){
          issue_list.add(element);
        }
      }
    } else {
      for (var element in issues) {
        DateTime tempCreationDate = DateTime.parse(element['creation']);
        DateTime creationDate = DateTime(tempCreationDate.year, tempCreationDate.month, tempCreationDate.day);
        if(element['status'] == status && fromDateOnly.isAtSameMomentAs(creationDate)){
          issue_list.add(element);
        }
      }
    }
    notifyListeners();
  }

  Future<void> getIssueDataFromStatusAndToDate(String status,String toDate,List<dynamic> issues) async{
    DateFormat format = DateFormat("dd-MM-yyyy");
    DateTime to = format.parse(toDate);
    // Create new DateTime objects with only year, month, and day
    DateTime toDateOnly = DateTime(to.year, to.month, to.day);
    issue_list.clear();
    if(status == 'All') {
      for (var element in issues) {
        DateTime tempCreationDate = DateTime.parse(element['creation']);
        DateTime creationDate = DateTime(tempCreationDate.year, tempCreationDate.month, tempCreationDate.day);
        if(toDateOnly.isAtSameMomentAs(creationDate)){
          issue_list.add(element);
        }
      }
    } else {
      for (var element in issues) {
        DateTime tempCreationDate = DateTime.parse(element['creation']);
        DateTime creationDate = DateTime(tempCreationDate.year, tempCreationDate.month, tempCreationDate.day);
        if(element['status'] == status && toDateOnly.isAtSameMomentAs(creationDate)){
          issue_list.add(element);
        }
      }
    }
    notifyListeners();
  }
}