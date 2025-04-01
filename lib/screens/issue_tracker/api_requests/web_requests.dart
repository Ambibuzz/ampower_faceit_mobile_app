import 'dart:convert';
import '../../../helpers/shared_preferences.dart';
import '../../../utils/apiMethodHandlers.dart';

class WebRequests{
  Future<List<dynamic>?> getIssueList() async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Issue?fields=["*"]&order_by=%60tabIssue%60.%60modified%60+desc&limit_page_length=*');
    var finalData =  jsonDecode(response.toString());
    if(finalData['data'].isNotEmpty){
      return finalData['data'];
    }
    return [];
  }


  Future<Map<String,dynamic>?> createNewIssue(Map<String,dynamic> body) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"application/x-www-form-urlencoded","Accept": "application/json",};
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/resource/Issue',
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

  Future<dynamic> getIssueDetails(String docName) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Issue/$docName');
    var finalData =  jsonDecode(response.toString());
    if(finalData['data'].isNotEmpty){
      return finalData['data'];
    }
    return [];
  }


  Future<Map<String,dynamic>?> editIssue(Map<String,dynamic> body,var docName) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"application/x-www-form-urlencoded","Accept": "application/json",};
    var response = await ApiMethodHandler().makePUTRequest(
        headers:headers,
        url: 'api/resource/Issue/$docName',
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