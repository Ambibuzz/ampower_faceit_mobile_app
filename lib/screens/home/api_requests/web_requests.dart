import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart' as DIO;

import '../../../helpers/shared_preferences.dart';
import '../../../utils/apiMethodHandlers.dart';

class WebRequests {
  Future<dynamic> getNoteList(String filter) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Note?fields=["*"]&filters=[$filter]&limit_page_length=*');
    var finalData =  jsonDecode(response.toString());
    return finalData["data"];
  }
  Future uploadImage(imgData, String docName,String eid) async {
    var id = await getId();
    var headers = {
      'Cookie': 'sid=$id;',
      'Content-Type': 'multipart/form-data'
    };
    final DIO.FormData formData = DIO.FormData.fromMap({
      "docname": docName,
      "doctype": "Employee Checkin",
      "is_private": '1',
      "folder": "Home/Attachments",
      'file': await DIO.MultipartFile.fromFile(imgData.path,filename: '$eid-${DateTime.now()}-${1000 + Random().nextInt(9000)}.${imgData.path.split('.').last}')
    });
    var response = await ApiMethodHandler().makePOSTRequest(
        headers: headers,
        url: 'api/method/upload_file',
        data: formData
    );

    var finalData = jsonDecode(response.toString());
    return finalData;
  }

  Future<dynamic> checkinUser(bodyData) async {
    var id = await getId();
    var headers = {
      'Cookie': 'sid=$id;',
      'Content-Type': 'application/json'
    };
    DIO.FormData formData = DIO.FormData.fromMap({
      'doc': jsonEncode(bodyData['data']),
      'action': 'Save',
    });
    var response = await ApiMethodHandler().makePOSTRequest(
        headers: headers,
        url: 'api/method/frappe.desk.form.save.savedocs',
        data: formData
    );
    var finalData = jsonDecode(response.toString());
    return finalData;
  }

  Future addCheckinComment(content,referenceName) async {
    var id = await getId();
    var name = await getFullName();
    var email = await getEmail();
    var headers = {
      'Cookie': 'sid=$id;',
      'Content-Type': 'application/json'
    };
    var bodyData = {
      'reference_doctype': 'Employee Checkin',
      'reference_name': referenceName,
      'comment_email': email,
      'comment_by': name,
      'content': content
    };
    var response = await ApiMethodHandler().makePOSTRequest(
        headers: headers,
        url: 'api/method/frappe.desk.form.utils.add_comment',
        data: bodyData
    );
    return json.decode(response.toString());
  }

  Future getCheckin(context, empId) async {
    //get checkin data
    var finalData = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Employee Checkin');
    return jsonDecode(finalData.toString());
  }
}