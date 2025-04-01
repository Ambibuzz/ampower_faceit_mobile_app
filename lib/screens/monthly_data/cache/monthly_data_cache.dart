import 'dart:convert';

import 'package:hive/hive.dart';

class MonthlyDataCache {
  Future<dynamic> getMonthlyAttendanceFromCache(String startDate,String endDate) async {
    try {
      var doctypeBox = await Hive.openBox('doctypes');
      var tempDetails = await doctypeBox.get('Attendance-$startDate-$endDate',defaultValue: false);
      return tempDetails;
    } catch(e) {
      return false;
    }
  }

  Future<void> putMonthlyDataInCache(String startDate,String endDate,monthlyData) async {
    try{
      var doctypeBox = await Hive.openBox('doctypes');
      await doctypeBox.put('Attendance-$startDate-$endDate',jsonEncode(monthlyData));
    } catch(e) {

    }
  }

  Future<void> putMonthlyHolidayInCache(String month,String year,holidays) async {
    try {
      var doctypeBox = await Hive.openBox('doctypes');
      await doctypeBox.put('Holiday-$month-$year', jsonEncode(holidays));
    } catch(e) {

    }
  }
}