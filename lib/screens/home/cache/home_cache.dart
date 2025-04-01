import 'package:hive/hive.dart';

class HomeCache{
  Future<dynamic> getUserDetailsFromCache() async {
    try {
      var doctypeBox = await Hive.openBox('doctypes');
      var employeeData = await doctypeBox.get('EmployeeData', defaultValue: false);
      return employeeData;
    } catch (e) {
      return false;
    }
  }

  Future<void> putUserDetailsInCache(dynamic employeeDetails) async {
    try{
      var doctypeBox = await Hive.openBox('doctypes');
      await doctypeBox.put('EmployeeData', employeeDetails);
    } catch(e) {

    }
  }

  Future<dynamic> getFaceITConfigurationFromCache() async {
    try {
      var doctypeBox = await Hive.openBox('doctypes');
      var features = await doctypeBox.get('Features', defaultValue: false);
      return features;
    } catch(e) {
      return false;
    }
  }

  Future<void> putFaceITConfigurationInCache(dynamic features) async {
    try {
      var doctypeBox = await Hive.openBox('doctypes');
      await doctypeBox.put('Features', features);
    } catch(e) {

    }
  }

  Future<dynamic> getMonthlyAttendanceFromCache(String startDate,String endDate) async {
    try{
      var doctypeBox = await Hive.openBox('doctypes');
      var tempDetails = await doctypeBox.get('Attendance-$startDate-$endDate', defaultValue: false);
      return tempDetails;
    } catch(e) {
      return false;
    }
  }

  Future<void> putMonthlyAttendanceInCache(String startDate, String endDate, dynamic attendanceDetails) async {
    try {
      var doctypeBox = await Hive.openBox('doctypes');
      await doctypeBox.put('Attendance-$startDate-$endDate',attendanceDetails);
    } catch(e) {

    }
  }

  Future<dynamic> getHolidayDetailsFromCache(int month, int year) async {
    try {
      var doctypeBox = await Hive.openBox('doctypes');
      var tempHolidays = await doctypeBox.get('Holiday-$month-$year', defaultValue: false);
      return tempHolidays;
    } catch(e) {
      return false;
    }
  }

  Future<void> putHolidayDetailsInCache(int month,int year,holidayDetails) async {
    try {
      var doctypeBox = await Hive.openBox('doctypes');
      await doctypeBox.put('Holiday-$month-$year', holidayDetails);
    } catch(e) {

    }
  }

  Future<void> deleteCache(String boxName) async {
    try {
      var doctypeBox = await Hive.openBox('doctypes');
      await doctypeBox.delete(boxName);
    } catch(e) {

    }
  }
}