import 'dart:convert';
import 'package:dio/dio.dart' as DIO;
import '../../../helpers/shared_preferences.dart';
import '../../../utils/apiMethodHandlers.dart';

class WebRequests {
  Future<dynamic> doctypeSearch(data) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type': 'multipart/form-data'};
    DIO.FormData formData;
    if(data['apply_filter']){
      formData = DIO.FormData.fromMap({
        "txt" : '',
        "doctype" : data['doctype'],
        "ignore_user_permissions" : data['permission'],
        "reference_doctype" : data['ref_doctype'],
        'filters' : data['filter_val']
      });
    }else {
      formData = DIO.FormData.fromMap({
        "txt" : '',
        "doctype" : data['doctype'],
        "ignore_user_permissions" : "0",
        "reference_doctype" : data['ref_doctype']
      });
    }
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

  Future<List<dynamic>?> getTimesheetListWithoutFilter() async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Timesheet?fields=["*"]&limit_page_length=*');
    var finalData =  jsonDecode(response.toString());
    if(finalData['data'].isNotEmpty){
      return finalData['data'];
    }
    return [];
  }

  Future<List<dynamic>?> getTimesheetList(String filter) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Timesheet?fields=["*"]&filters=[$filter]&limit_page_length=*');
    var finalData =  jsonDecode(response.toString());
    if(finalData['data'].isNotEmpty){
      return finalData['data'];
    }
    return [];
  }

  Future<dynamic> getTimesheetDetails(String name) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Timesheet/$name');
    var finalData =  jsonDecode(response.toString());
    if(finalData['data'].isNotEmpty){
      return finalData['data'];
    }
    return [];
  }

  Future<Map<String,dynamic>?> createTimesheet(Map<String,dynamic> body) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"application/x-www-form-urlencoded","Accept": "application/json",};
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/resource/Timesheet',
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

  Future<Map<String,dynamic>?> editTimeSheet(var body) async{

    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"application/json",};
    var response = await ApiMethodHandler().makePUTRequest(
        headers:headers,
        url: 'api/resource/Timesheet/${body['name']}',
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