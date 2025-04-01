import 'dart:convert';
import '../../../helpers/shared_preferences.dart';
import '../../../utils/apiMethodHandlers.dart';

class WebRequests {
  Future<List<dynamic>?> getPastAttendanceRequestList(String filter) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Attendance Request?fields=["*"]&filters=[$filter]&order_by=%60tabAttendance+Request%60.%60modified%60+desc&limit_page_length=*');
    var finalData =  jsonDecode(response.toString());
    if(finalData['data'].isNotEmpty){
      return finalData['data'];
    }
    return [];
  }

  Future<Map<String,dynamic>?> createNewAttendanceRequest(Map<String,dynamic> body) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"application/json","Accept": "application/json",};
    var response = await ApiMethodHandler().makePOSTRequest(
        headers:headers,
        url: 'api/resource/Attendance Request',
        data: jsonEncode(body)
    );
    var finalData =  json.decode(response.toString());
    print(finalData);
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

  Future<Map<String,dynamic>?> updateAttendanceRequest(Map<String,dynamic> body) async{
    var id = await getId();
    var headers = {'Cookie': 'sid=$id;','Content-Type':"application/json","Accept": "application/json",};
    var response = await ApiMethodHandler().makePUTRequest(
        headers:headers,
        url: 'api/resource/Attendance Request/${body['name']}',
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

}