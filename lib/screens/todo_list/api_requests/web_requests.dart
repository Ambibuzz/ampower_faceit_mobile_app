import 'dart:convert';
import 'package:dio/dio.dart' as DIO;
import '../../../helpers/shared_preferences.dart';
import '../../../utils/apiMethodHandlers.dart';

class WebRequests {
  Future<List<dynamic>?> getTodoList(String filter) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/ToDo?fields=["*"]&filters=[$filter]&order_by=%60tabToDo%60.%60modified%60+desc&limit_page_length=*');
    var finalData =  jsonDecode(response.toString());
    if(finalData['data'].isNotEmpty){
      return finalData['data'];
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

  Future<List<dynamic>?> getReferenceType() async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type': 'multipart/form-data'};
    final DIO.FormData formData = DIO.FormData.fromMap({
      "txt" : '',
      "doctype" : 'DocType',
      "ignore_user_permissions" : "0",
      "reference_doctype" : "ToDo",
      "filters" : '{"isSingle":"0"}'
    });
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/method/frappe.desk.search.search_link',
        data: formData
    );

    var finalData = jsonDecode(response.toString());
    if(finalData['results'].isNotEmpty){
      return finalData['results'];
    }
    return [];
  }

  Future<List<dynamic>?> getReferenceName(String docType) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type': 'multipart/form-data'};
    final DIO.FormData formData = DIO.FormData.fromMap({
      "txt" : '',
      "doctype" : docType,
      "ignore_user_permissions" : "0",
      "reference_doctype" : "ToDo",
    });
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/method/frappe.desk.search.search_link',
        data: formData
    );

    var finalData = jsonDecode(response.toString());
    if(finalData['results'].isNotEmpty){
      return finalData['results'];
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

  Future<List<dynamic>?> getRole() async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type': 'multipart/form-data'};
    final DIO.FormData formData = DIO.FormData.fromMap({
      "txt" : '',
      "doctype" : 'Role',
      "ignore_user_permissions" : "0",
      "reference_doctype" : "ToDo",
    });
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/method/frappe.desk.search.search_link',
        data: formData
    );

    var finalData = jsonDecode(response.toString());
    if(finalData['results'].isNotEmpty){
      return finalData['results'];
    }
    return [];
  }

  Future<Map<String,dynamic>?> createNewTodo(Map<String,dynamic> body) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"application/x-www-form-urlencoded","Accept": "application/json",};
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/resource/ToDo',
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

  Future<dynamic> getTodoDetails(String docName) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/ToDo/$docName');
    var finalData =  jsonDecode(response.toString());
    if(finalData['data'].isNotEmpty){
      return finalData['data'];
    }
    return [];
  }


  Future<Map<String,dynamic>?> editTodo(Map<String,dynamic> body,var docName) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"application/x-www-form-urlencoded","Accept": "application/json",};
    var response = await ApiMethodHandler().makePUTRequest(
        headers:headers,
        url: 'api/resource/ToDo/$docName',
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
    if(finalData['results'].isNotEmpty){
      return finalData['results'];
    }
    return [];
  }
}