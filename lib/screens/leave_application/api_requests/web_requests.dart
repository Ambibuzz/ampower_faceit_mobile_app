import 'dart:convert';
import 'package:dio/dio.dart' as DIO;
import 'package:intl/intl.dart';
import '../../../helpers/shared_preferences.dart';
import '../../../utils/apiMethodHandlers.dart';

class WebRequests {
  Future<dynamic> getLeaveBalance(String empId) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"application/x-www-form-urlencoded","Accept": "application/json",};
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/method/hrms.hr.doctype.leave_application.leave_application.get_leave_details',
        data: {
          'employee': empId,
          'date': DateFormat('yyyy-MM-dd').format(DateTime.now())
        }
    );
    var finalData =  json.decode(response.toString());
    if(finalData != null && response!.statusCode == 200){
      return {
        'success' : true,
        'message' : finalData['message']
      };
    } else {
      return {
        'success' : false,
        'data' : finalData
      };
    }
  }

  Future<dynamic> getWorkflowTransition(body) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"multipart/form-data","Accept": "application/json",};
    final DIO.FormData formData = DIO.FormData.fromMap({
      'doc': jsonEncode(body),
    });
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/method/frappe.model.workflow.get_transitions',
        data: formData
    );
    var finalData =  json.decode(response.toString());
    if(finalData != null && response!.statusCode == 200){
      return {
        'success' : true,
        'message' : finalData['message']
      };
    } else {
      return {
        'success' : false,
        'data' : finalData
      };
    }
  }

  Future<dynamic> applyWorkflowTransition(var body,String action) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"multipart/form-data","Accept": "application/json",};
    final DIO.FormData formData = DIO.FormData.fromMap({
      'doc': jsonEncode(body),
      'action': action
    });
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/method/frappe.model.workflow.apply_workflow',
        data: formData
    );
    var finalData =  json.decode(response.toString());
    if(finalData != null && response!.statusCode == 200){
      return {
        'success' : true,
        'message' : finalData['message']
      };
    } else {
      return {
        'success' : false,
        'data' : finalData
      };
    }
  }


  Future<dynamic> getLeaveList(String filter) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Leave Application?fields=["name","leave_type","from_date","to_date","creation","total_leave_days","status","workflow_state"]&filters=[$filter]&order_by=%60tabLeave+Application%60.%60modified%60+desc&limit_page_length=*');
    var finalData =  jsonDecode(response.toString());
    return finalData;
  }

  Future<dynamic> getLeaveDetails(String name) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Leave Application/$name');
    var finalData =  jsonDecode(response.toString());
    return finalData;
  }


  Future<dynamic> getLeaveTypes() async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Leave Type');
    var finalData =  jsonDecode(response.toString());
    return finalData;
  }


  Future<Map<String,dynamic>?> applyForLeave(context,Map<String,String> body) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"application/json","Accept": "application/json",};
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/resource/Leave Application',
        data: jsonEncode(body)
    );
    var finalData =  json.decode(response.toString());
    if(finalData['data'] != null && response!.statusCode == 200){
      return {
        'success' : true,
        'data' : finalData['data']
      };
    } else {
      return {
        'success' : false,
        'data' : finalData['exception']
      };
    }
  }


  Future<Map<String,dynamic>?> editLeave(context,Map<String,dynamic> body) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"application/json",};
    var response = await ApiMethodHandler().makePUTRequest(
        headers:headers,
        url: 'api/resource/Leave Application/${body['name']}',
        data: body
    );
    var finalData = jsonDecode(response.toString());
    if(finalData['data'] != null && response!.statusCode == 200){
      return {
        'success' : true,
        'data' : finalData['data']
      };
    } else {
      return {
        'success' : false,
        'data' : finalData['exception']
      };
    }
  }
}