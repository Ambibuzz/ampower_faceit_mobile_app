import 'dart:convert';
import 'package:community/base_viewmodel.dart';
import 'package:community/helpers/null_checker.dart';
import 'package:community/screens/leave_application/api_requests/web_requests.dart';
import 'package:community/screens/leave_application/cache/leave_application_cache.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveDetailsViewModel extends BaseViewModel{
  var data;
  final formKey = GlobalKey<FormState>();
  var leaveTypes;
  var payload = null;
  var workflow = {};
  var workflow_actions = [];
  List<DropdownMenuItem<String>> leaveTypeMenuItems = [];
  var leaveTypeValue = "Casual Leave";
  var isHalfDay = false;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController reason = TextEditingController();
  TextEditingController postingDate = TextEditingController();
  TextEditingController halfDayDate = TextEditingController();
  var employee;
  var employeeName;
  var leaveApprover;
  var leaveApproverName;
  var status;
  var workflowState;
  var totalLeaveDays;
  var company;
  var letterHead;
  var name;
  bool docLoadingSequenceInProgress = false;

  void startDocLoadingSequence(String docName,bool force) async{
    docLoadingSequenceInProgress = true;
    notifyListeners();
    await clearFields();
    await leaveTypeList();
    await getLeaveDetails(docName, force);
    await getTransitionState(payload);
    docLoadingSequenceInProgress = false;
    notifyListeners();
  }

  Future<void> clearFields() async{
    payload = {};
    leaveTypeMenuItems = [];
    leaveTypeValue = "Casual Leave";
    isHalfDay = false;
    fromDate = TextEditingController(text: "");
    toDate = TextEditingController(text: "");
    reason = TextEditingController(text: "");
    postingDate = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
    halfDayDate = TextEditingController(text: "");
  }


  Future<void> leaveTypeList() async{
    var leaveTypeData = await WebRequests().getLeaveTypes();
    for(int i=0; i<leaveTypeData['data'].length; i++){
      leaveTypeMenuItems.add(DropdownMenuItem(
          value: leaveTypeData['data'][i]['name'],
          child: Text(leaveTypeData['data'][i]['name'])
      ));
    }
  }

  void changeLeaveTypeValue(value) {
    leaveTypeValue = value;
    notifyListeners();
  }

  void changeFromDate(formattedDate) {
    fromDate.text = formattedDate;
    notifyListeners();
  }

  void changeToDate(formattedDate) {
    toDate.text = formattedDate;
    notifyListeners();
  }

  void changeIsHalfDay(value) {
    isHalfDay = value;
    notifyListeners();
  }

  void changeHalfDayDate(formattedDate) {
    halfDayDate.text = formattedDate;
    notifyListeners();
  }

  void changePostingDate(formattedDate) {
    postingDate.text = formattedDate;
    notifyListeners();
  }


  Future<void> getLeaveDetails(String docName,bool force) async{
    var tempDetails = await LeaveApplicationCache().fetchLeaveDetailsFromCache(docName);
    if(tempDetails == false || force){
      tempDetails = await WebRequests().getLeaveDetails(docName);
      await LeaveApplicationCache().putLeaveApplicationDetailsInCache(docName, tempDetails);
      await initDetails(tempDetails);
    } else {
      await initDetails(jsonDecode(tempDetails));
    }
  }

  Future<void> initDetails(details) async {
    payload = details['data'];
    try {
      leaveTypeValue = payload['leave_type'];
      fromDate.text = DateFormat('yyyy-MM-dd').format(DateTime.parse(payload['from_date']));
      toDate.text = DateFormat('yyyy-MM-dd').format(DateTime.parse(payload['to_date']));
      postingDate.text = DateFormat('yyyy-MM-dd').format(DateTime.parse(payload['posting_date']));
      reason.text = payload['description'];
      isHalfDay = payload['half_day'] == 1 ? true : false;
      employee = payload['employee'];
      employeeName = payload['employee_name'];
      leaveApprover = payload['leave_approver'];
      leaveApproverName = payload['leave_approver_name'];
      status = payload['status'];
      workflowState = payload['workflow_state'];
      totalLeaveDays = payload['total_leave_days'].toString();
      company = payload['company'];
      letterHead = payload['letter_head'];
      name = payload['name'];
      if(isHalfDay) {
        halfDayDate.text = DateFormat('yyyy-MM-dd').format(DateTime.parse(payload['half_day_date']));
      }
    } catch (e) {
      print('Error processing payload: $e');
    }
  }

  Future<void> getTransitionState(payload) async{
    workflow_actions.clear();
    workflow = await WebRequests().getWorkflowTransition(payload);
    if (workflow['success'] == true) {
      Set<String> seenActions = {};
      for (int i = 0; i < workflow['message'].length; i++) {
        String action = workflow['message'][i]['action'];
        if (!seenActions.contains(action)) {
          seenActions.add(action);
          workflow_actions.add({
            'action': action,
            'next_state': workflow['message'][i]['next_state']
          });
        }
      }
    }
    notifyListeners();
  }
}