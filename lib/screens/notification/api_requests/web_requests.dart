import 'dart:convert';

import '../../../utils/apiMethodHandlers.dart';

class WebRequests {
  Future<dynamic> getNoteList(String filter) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Note?fields=["*"]&filters=[$filter]&limit_page_length=*');
    var finalData =  jsonDecode(response.toString());
    return finalData["data"];
  }
}