import 'dart:convert';
import 'package:dio/dio.dart' as DIO;
import '../../../helpers/shared_preferences.dart';
import '../../../utils/apiMethodHandlers.dart';

class WebRequests {
  Future<List<dynamic>?> getTaskList(String filter) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Task?fields=["*"]&filters=$filter&order_by=%60tabTask%60.%60modified%60+desc&limit_page_length=*');
    var finalData =  jsonDecode(response.toString());
    if(finalData['data'].isNotEmpty){
      return finalData['data'];
    }
    return [];
  }

  Future<List<dynamic>?> getTagList(String tag) async{
    final DIO.FormData formData = DIO.FormData.fromMap({
      "txt" : tag,
      "doctype" : 'Task',
    });
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type': 'multipart/form-data'};
    var response = await ApiMethodHandler().makePOSTRequest(
        url: 'api/method/frappe.desk.doctype.tag.tag.get_tags',
        data: formData,
        headers: headers
    );
    var finalData =  jsonDecode(response.toString());
    if(finalData['message'].isNotEmpty){
      return finalData['message'];
    }
    return [];
  }

  Future<dynamic> addTag(String tag,String docName) async{
    final DIO.FormData formData = DIO.FormData.fromMap({
      "tag" : tag,
      "dt" : 'Task',
      "dn" : docName
    });
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type': 'multipart/form-data'};
    var response = await ApiMethodHandler().makePOSTRequest(
        url: 'api/method/frappe.desk.doctype.tag.tag.add_tag',
        data: formData,
        headers: headers
    );
    var finalData =  jsonDecode(response.toString());
    if(finalData['message'].isNotEmpty){
      return finalData['message'];
    }
    return [];
  }

  Future<List<dynamic>?> getUsers() async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/User?filters=[["User","enabled","=","1"]]&limit_page_length=*');
    var finalData =  jsonDecode(response.toString());
    if(finalData['data'].isNotEmpty){
      return finalData['data'];
    }
    return [];
  }


  Future<List<dynamic>?> getTaskProgress(String referenceName) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Task/$referenceName');
    var finalData =  jsonDecode(response.toString());
    if(finalData['data'].isNotEmpty){
      return finalData['data']['task_progress'];
    }
    return [];
  }


  Future<Map<String,dynamic>?> createNewTask(Map<String,dynamic> body) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"application/x-www-form-urlencoded","Accept": "application/json",};
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/resource/Task',
        data: jsonEncode(body)
    );
    print(response.toString());
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

  Future<Map<String,dynamic>?> addTaskUpdate(Map<String,dynamic> body) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"application/x-www-form-urlencoded","Accept": "application/json",};
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/resource/Task Progress Summary',
        data: body
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

  Future<dynamic> getTaskDetails(String docName) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Task/$docName');
    var finalData =  jsonDecode(response.toString());
    if(finalData['data'].isNotEmpty){
      return finalData['data'];
    }
    return [];
  }


  Future<Map<String,dynamic>?> editTask(Map<String,dynamic> body,var docName) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"application/x-www-form-urlencoded","Accept": "application/json",};
    var response = await ApiMethodHandler().makePUTRequest(
        headers:headers,
        url: 'api/resource/Task/$docName',
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

  Future<dynamic> doctypeSearch(data) async{
    print(data);
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
        "ignore_user_permissions" : data['permission'],
        "reference_doctype" : data['ref_doctype']
      });
    }
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/method/frappe.desk.search.search_link',
        data: formData
    );

    var finalData = jsonDecode(response.toString());
    if(finalData['message'].isNotEmpty){
      return finalData['message'];
    }
    return [];
  }
}