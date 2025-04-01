import 'dart:convert';
import 'package:community/base_viewmodel.dart';
import 'package:community/screens/leave_application/cache/leave_application_cache.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../leave_application/api_requests/web_requests.dart';

class LeaveApplicationViewModel extends BaseViewModel{
  bool isLeaveDataAvailable = true;
  TextEditingController from_date = TextEditingController(text: 'From');
  TextEditingController to_date = TextEditingController(text: 'To');
  String selectedValue = 'All';
  List<dynamic> leave_list = [];
  List<dynamic> allLeave_list = [];
  String? profile_pic_url = "";
  String filter = '';
  var leave_balance = [];
  var balance = {};

  void clearFields() {
    from_date = TextEditingController(text: 'From');
    to_date = TextEditingController(text: 'To');
    selectedValue = 'All';
    getAllLeaves(false);
  }


  void getAllLeaves(bool force) async{
    allLeave_list.clear();
    var tempSlips = await LeaveApplicationCache().fetchLeaveApplicationListFromCache();
    if(tempSlips == false || force){
      tempSlips = await WebRequests().getLeaveList('');
      await LeaveApplicationCache().putLeaveApplicationDataInCache(tempSlips);
      getLeaveDataToDisplay(tempSlips['data']);
    } else {
      getLeaveDataToDisplay(jsonDecode(tempSlips)['data']);
    }
  }

  void getLeaveDataToDisplay(leaveApplicationList) async {
    allLeave_list = leaveApplicationList;
    if(from_date.text != 'From' && to_date.text != 'To') {
      await getLeaveDataFromStatusAndDate(selectedValue, from_date.text, to_date.text, allLeave_list);
    } else{
      await getLeaveDataFromStatus(selectedValue,allLeave_list);
    }
  }


  Future<void> getLeaveDataFromStatus(String status,List<dynamic> leaves) async{
    leave_list.clear();
    if(status == 'All'){
      leave_list.addAll(leaves);
      notifyListeners();
      return;
    }
    for (var element in leaves) {
      if(element['status'] == status){
        leave_list.add(element);
      }
    }
    notifyListeners();
  }

  Future<void> getLeaveDataFromStatusAndDate(String status,String fromDate,String toDate,List<dynamic> leaves) async{
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime from = format.parse(fromDate);
    DateTime to = format.parse(toDate);
    leave_list.clear();
    if(status == 'All') {
      for (var element in leaves) {
        if((DateTime.parse(element['from_date']).isAfter(from.subtract(Duration(days: 1))) && DateTime.parse(element['to_date']).isBefore(to.add(Duration(days: 1))) )){
          leave_list.add(element);
        }
      }
    } else {
      for (var element in leaves) {
        if(element['status'] == status && (DateTime.parse(element['from_date']).isAfter(from.subtract(Duration(days: 1))) && DateTime.parse(element['to_date']).isBefore(to.add(Duration(days: 1))) )){
          leave_list.add(element);
        }
      }
    }
    notifyListeners();
  }

  Future<void> getLeaveDataFromDate(String fromDate,String toDate,List<dynamic> leaves) async{
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime from = format.parse(fromDate);
    DateTime to = format.parse(toDate);
    leave_list.clear();
    for (var element in leaves) {
      if((DateTime.parse(element['from_date']).isAfter(from.subtract(Duration(days: 1))) && DateTime.parse(element['to_date']).isBefore(to.add(Duration(days: 1))) )){
        leave_list.add(element);
      }
    }
    notifyListeners();
  }

  Future<void> getLeaveDataFromFromDate(String fromDate,List<dynamic> leaves) async{
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime from = format.parse(fromDate);
    leave_list.clear();
    for (var element in leaves) {
      if(DateTime.parse(element['from_date']).isAtSameMomentAs(from)){
        leave_list.add(element);
      }
    }
    notifyListeners();
  }

  Future<void> getLeaveDataFromToDate(String toDate,List<dynamic> leaves) async{
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime to = format.parse(toDate);
    leave_list.clear();
    for (var element in leaves) {
      if(DateTime.parse(element['to_date']).isAtSameMomentAs(to)){
        leave_list.add(element);
      }
    }
    notifyListeners();
  }

  Future<void> getLeaveDataFromStatusAndFromDate(String status,String fromDate,List<dynamic> leaves) async{
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime from = format.parse(fromDate);
    leave_list.clear();
    if(status == 'All') {
      for (var element in leaves) {
        if(DateTime.parse(element['from_date']).isAtSameMomentAs(from)){
          leave_list.add(element);
        }
      }
    } else {
      for (var element in leaves) {
        if(element['status'] == status && DateTime.parse(element['from_date']).isAtSameMomentAs(from)){
          leave_list.add(element);
        }
      }
    }
    notifyListeners();
  }

  Future<void> getLeaveDataFromStatusAndToDate(String status,String toDate,List<dynamic> leaves) async{
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime to = format.parse(toDate);
    leave_list.clear();
    if(status == 'All') {
      for (var element in leaves) {
        if(DateTime.parse(element['to_date']).isAtSameMomentAs(to)){
          leave_list.add(element);
        }
      }
    } else {
      for (var element in leaves) {
        if(element['status'] == status && DateTime.parse(element['to_date']).isAtSameMomentAs(to)){
          leave_list.add(element);
        }
      }
    }
    notifyListeners();
  }

  void getLeaveBalance(empId) async{
    leave_balance.clear();
    balance = await WebRequests().getLeaveBalance(empId);
    if(balance.isNotEmpty){
      balance['message']['leave_allocation'].forEach((key, value) {
        leave_balance.add({
          'type':key,
          'data':value
        });
      });
      notifyListeners();
    }
  }


  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "All", child: Text("All")),
      const DropdownMenuItem(value: "Open", child: Text("Open")),
      const DropdownMenuItem(value: "Approved", child: Text("Approved")),
      const DropdownMenuItem(value: "Rejected", child: Text("Rejected")),
      const DropdownMenuItem(value: "Cancelled", child: Text("Cancelled")),
    ];
    return menuItems;
  }
}