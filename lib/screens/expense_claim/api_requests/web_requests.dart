import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as DIO;
import '../../../helpers/shared_preferences.dart';
import '../../../utils/apiMethodHandlers.dart';

class WebRequests {
  Future<dynamic> getExpenseClaimList(String filter) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Expense Claim?fields=["*"]&filters=[$filter]&order_by=%60tabExpense+Claim%60.%60modified%60+desc&limit_page_length=*');
    var finalData =  jsonDecode(response.toString());
    return finalData;
  }

  Future<dynamic> getExpenseClaimDetails(String name) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/method/frappe.desk.form.load.getdoc?doctype=Expense Claim&name=$name');
    var finalData =  jsonDecode(response.toString());
    return finalData;
  }

  Future<dynamic> getWorkflowTransition(body) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"multipart/form-data","Accept": "application/json",};
    final DIO.FormData formData = DIO.FormData.fromMap({
      'doc': jsonEncode(body["docs"].first),
    });
    //print(body["docs"]);
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

  Future<dynamic> applyWorkflowTransition(body,String action) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;',"Accept": "application/json",};
    final DIO.FormData formData = DIO.FormData.fromMap({
      'doc': jsonEncode(body['docs'].first),
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

  Future<List<dynamic>?> getExpenseApproverList(employee) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type': 'multipart/form-data'};
    final DIO.FormData formData = DIO.FormData.fromMap({
      'txt':'',
      'doctype': 'User',
      'ignore_user_permissions': '0',
      'reference_doctype': "Expense Claim",
      'query': 'hrms.hr.doctype.department_approver.department_approver.get_approvers',
      'filters': '{"employee":"$employee","doctype":"Expense Claim"}'
    });
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/method/frappe.desk.search.search_link',
        data: formData
    );

    var finalData = jsonDecode(response.toString());
    if(finalData != null && finalData['message'].isNotEmpty){
      return finalData['message'];
    }
    return [];
  }


  Future<Map<String,dynamic>?> applyForExpenseClaim(context,Map<String,dynamic> body) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"application/json","Accept": "application/json",};
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/resource/Expense Claim',
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


  Future<Map<String,dynamic>?> editExpenseClaimDetails(body) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type': 'multipart/form-data'};
    final DIO.FormData formData = DIO.FormData.fromMap({
      'doc':jsonEncode(body['docs'].first),
      'action': 'Save'
    });
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/method/frappe.desk.form.save.savedocs',
        data: formData
    );
    var finalData = jsonDecode(response.toString());
    if(finalData['docs'] != null && response!.statusCode == 200){
      return {
        'success' : true,
        'data' : finalData['docs']
      };
    } else {
      return {
        'success' : false,
        'data' : finalData['exception']
      };
    }
  }

  Future<List<dynamic>?> getExpenseClaimType() async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type': 'multipart/form-data'};
    final DIO.FormData formData = DIO.FormData.fromMap({
      'txt':'',
      'doctype': 'Expense Claim Type',
      'ignore_user_permissions': '0',
      'reference_doctype': 'Expense Claim Detail'
    });
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


  Future<String?> getPayableAccountName(companyName) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Account?fields=["name"]&filters=[["Account","report_type","=","Balance Sheet"],["Account","account_type","=","Payable"],["Account","company","=","$companyName"],["Account","is_group","=","No"]]&limit_page_length=*');
    var finalData =  jsonDecode(response.toString());
    print(finalData);
    return finalData['data'][0]['name'];
  }

  Future<int> uploadFiles({
        required List<File> files,
        required String docName,
        required String docType
      }) async {
    var id = await getId();
    int uploads = 0;

    for (var file in files) {
      try {
        var headers = {
          'Cookie': 'sid=$id;',
          'Content-Type': 'multipart/form-data'
        };
        final DIO.FormData formData = DIO.FormData.fromMap({
          "docname": docName,
          "doctype": docType,
          "is_private": "0",
          "folder": "Home/Attachments",
          'file': await DIO.MultipartFile.fromFile(file.path)
        });
        var response = await ApiMethodHandler().makePOSTRequest(
            headers: headers,
            url: 'api/method/upload_file',
            data: formData
        );

        if (response!.statusCode == 200) {
          uploads++;
        }
      } catch (exp) {}
    }
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
    var headers = {'Cookie': 'sid=$id;', 'Content-Type': 'multipart/form-data'};
    final DIO.FormData formData = DIO.FormData.fromMap({
      "fid": fid,
      "dt":docType,
      "dn":docName
    });
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/method/frappe.desk.form.utils.remove_attach',
        data: formData
    );
    if(response!.statusCode == 200){
      return true;
    } else {
      return false;
    }
  }
}