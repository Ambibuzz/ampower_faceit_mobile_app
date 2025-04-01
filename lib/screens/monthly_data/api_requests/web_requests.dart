import 'dart:convert';
import 'package:dio/dio.dart' as DIO;
import '../../../helpers/shared_preferences.dart';
import '../../../utils/apiMethodHandlers.dart';

class WebRequests {
  Future<bool> checkSession() async{
    var response = await ApiMethodHandler().makeGETRequest(url: '/api/method/frappe.auth.get_logged_user');
    if(response!= null && response.statusCode == 200){
      return true;
    }
    return false;
  }


  Future<String> getMostRecentEmployeeCheckin(empid) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Employee Checkin?fields=["log_type"]&filters=[["Employee Checkin","employee","=","$empid"]]&order_by=time desc&limit=1');
    var finalData =  jsonDecode(response.toString());
    if(finalData['data'].isNotEmpty){
      return finalData['data'].first['log_type'];
    }
    return '';
  }

  Future<dynamic> getSelectedTypeListForCustomerOrLead(type) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type': 'multipart/form-data'};
    final DIO.FormData formData = DIO.FormData.fromMap({
      'txt':'',
      'doctype': '$type',
      'ignore_user_permissions': '0',
      'reference_doctype': "Employee Checkin",
    });
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/method/frappe.desk.search.search_link',
        data: formData
    );

    var finalData = jsonDecode(response.toString());
    if(finalData != null && finalData['results'].isNotEmpty){
      return finalData['results'];
    }
    return [];
  }

  Future<dynamic> getEmployeesList() async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type': 'multipart/form-data'};
    final DIO.FormData formData = DIO.FormData.fromMap({
      'txt':'',
      'doctype': 'Employee',
      'ignore_user_permissions': '0',
      'reference_doctype': "Employee Checkin",
    });
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/method/frappe.desk.search.search_link',
        data: formData
    );

    var finalData = jsonDecode(response.toString());
    if(finalData != null && finalData['results'].isNotEmpty){
      return finalData['results'];
    }
    return [];
  }


  Future<dynamic> getMonthlyAttendance(String startDate, String endDate,String employeeName) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/method/frappe.desk.reportview.get?doctype=Attendance&fields=["*"]&filters=[["Attendance","attendance_date","Between",["$startDate","$endDate"]],["Attendance","employee_name","=","$employeeName"]]&page_length=20&view=Report');
    var finalData =  jsonDecode(response.toString());
    if(finalData['message'].isNotEmpty){
      return finalData['message'];
    }
    return [];
  }

  Future<dynamic> getFinancialYear() async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Holiday List?fields=["*"]&order_by=from_date%20desc');
    var finalData =  jsonDecode(response.toString());
    return finalData['data'];
  }

  Future<dynamic> getHolidayCalendarName(context,int month,int year) async{
    var currentYear = DateTime.now().year;
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Holiday List?fields=["*"]&order_by=from_date%20desc');
    var finalData =  jsonDecode(response.toString());
    if(DateTime.now().month < 4 && DateTime.parse(finalData['data'].first['to_date']).year > DateTime.now().year){
      return finalData['data'][1]['name'];
    }
    return finalData['data'].first['name'];
  }


  Future<List<dynamic>?> getMonthlyHolidays(String holidayCalendarName,int month,int year) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Holiday List/$holidayCalendarName');
    var finalData =  jsonDecode(response.toString());
    if(finalData != null && finalData['data'].isNotEmpty){
      return finalData['data']['holidays'];
    }
    return [];
  }
}