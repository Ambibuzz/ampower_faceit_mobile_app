import 'dart:convert';

import 'package:hive/hive.dart';

class LeaveApplicationCache {
  Future<dynamic> fetchLeaveApplicationListFromCache() async {
    try{
      var doctypeBox = await Hive.openBox('doctypes');
      var tempSlips = await doctypeBox.get('LeaveApplication',defaultValue: false);
      return tempSlips;
    } catch(e) {
      return false;
    }
  }

  Future<void> putLeaveApplicationDataInCache(leaveApplications) async {
    try{
      var doctypeBox = await Hive.openBox('doctypes');
      await doctypeBox.put('LeaveApplication', jsonEncode(leaveApplications));
    } catch(e) {

    }
  }

  Future<dynamic> fetchLeaveDetailsFromCache(docName) async {
    try{
      var doctypeBox = await Hive.openBox('doctypes');
      var tempDetails = await doctypeBox.get('LeaveDetails-${docName}',defaultValue: false);
      return tempDetails;
    } catch(e) {
      return false;
    }
  }

  Future<void> putLeaveApplicationDetailsInCache(String docName,leaveApplication) async{
    try {
      var doctypeBox = await Hive.openBox('doctypes');
      await doctypeBox.put('LeaveDetails-$docName',jsonEncode(leaveApplication));
    } catch(e) {

    }
  }
}