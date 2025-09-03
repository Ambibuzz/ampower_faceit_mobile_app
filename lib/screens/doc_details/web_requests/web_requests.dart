import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../../../helpers/shared_preferences.dart';
import '../../../utils/apiMethodHandlers.dart';

class WebRequests {
  Future<Response?> getDoctypeMeta(doctype) async {
    try {
      var response = await ApiMethodHandler().makeGETRequest(
        url: 'api/method/frappe.desk.form.load.getdoctype?doctype=$doctype',
      );
      return response;
    } catch (ex) {
      print(ex);
    }
    return null;
  }

  Future<Response?> getDoctypeDataWithReferenceName(
      doctype, referenceName) async {
    try {
      var response = await ApiMethodHandler().makeGETRequest(
        url:
        'api/method/frappe.desk.form.load.getdoc?doctype=$doctype&name=$referenceName',
      );
      return response;
    } catch (ex) {
      print(ex);
    }
    return null;
  }
  Future<Response?> saveDoc(doc) async {
    //Clipboard.setData(ClipboardData(text: jsonEncode(doc)));
    FormData formData = FormData.fromMap({'doc': jsonEncode(doc), 'action': 'Save'});
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"multipart/form-data","Accept": "application/json",};

    try {
      var response = await ApiMethodHandler().makePOSTRequest(url: 'api/method/frappe.desk.form.save.savedocs', data: formData, headers: headers);

      if (response != null && response.statusCode == 200) {
        print('Document saved successfully!');
      } else {
        print('Save failed. Response!');
      }

      return response;
    } catch (ex) {
      print('Exception in saveDoc: $ex');
    }

    return null;
  }

  Future<Response?> getLinkData(payload) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"multipart/form-data","Accept": "application/json",};
    FormData formData = FormData.fromMap(payload);
    try {
      var response = await ApiMethodHandler().makePOSTRequest(
          url: 'api/method/frappe.desk.search.search_link',
          data: formData,
        headers: headers
      );
      return response;
    } catch(ex) {
      print(ex);
    }
    return null;
  }

  Future<int> uploadFiles({
    required File file,
    required String docName,
    required String docType
  }) async {
    int uploads = 0;
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"multipart/form-data","Accept": "application/json",};
    //for (var file in files) {
    try {
      final FormData formData = FormData.fromMap({
        "docname": docName,
        "doctype": docType,
        "is_private": "0",
        "folder": "Home/Attachments",
        'file': await MultipartFile.fromFile(file.path)
      });
      var response = await ApiMethodHandler().makePOSTRequest(
          url: 'api/method/upload_file',
          data: formData,
          headers: headers
      );

      if (response!.statusCode == 200) {
        uploads++;
      }
    } catch (exp) {}
    //}
    return uploads;

  }

  Future<List<dynamic>?> getAttachedFiles(context,docName,docType) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/File?fields=["*"]&filters=[["attached_to_doctype","=","$docType"],["attached_to_name","=","$docName"]]');
    var finalData =  jsonDecode(response.toString());
    return finalData['data'];
  }

  Future<bool> deleteAttachements(
      {
        required String fid,
        required String docName,
        required String docType
      }) async {
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"multipart/form-data","Accept": "application/json",};
    final FormData formData = FormData.fromMap({
      "fid": fid,
      "dt":docType,
      "dn":docName
    });
    var response = await ApiMethodHandler().makePOSTRequest(
        url: 'api/method/frappe.desk.form.utils.remove_attach',
        data: formData,
        headers: headers
    );
    if(response!.statusCode == 200){
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> getWorkflowTransition(body) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"multipart/form-data","Accept": "application/json",};
    final FormData formData = FormData.fromMap({
      'doc': jsonEncode(body),
    });
    var response = await ApiMethodHandler().makePOSTRequest(
        url: 'api/method/frappe.model.workflow.get_transitions',
        data: formData,
        headers: headers
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

  Future<dynamic> applyWorkflowTransition(body,String action) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"multipart/form-data","Accept": "application/json",};
    final FormData formData = FormData.fromMap({
      'doc': jsonEncode(body),
      'action': action
    });
    var response = await ApiMethodHandler().makePOSTRequest(
        url: 'api/method/frappe.model.workflow.apply_workflow',
        data: formData,
        headers: headers
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
}