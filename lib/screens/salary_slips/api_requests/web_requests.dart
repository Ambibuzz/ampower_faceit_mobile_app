import 'dart:convert';
import '../../../utils/apiMethodHandlers.dart';

class WebRequests {
  Future<dynamic> getSalarySlipList(String filter) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Salary Slip?fields=["*"]&filters=[$filter]&order_by=%60tabSalary+Slip%60.%60modified%60+desc&limit_page_length=*');
    var finalData =  jsonDecode(response.toString());
    return finalData;
  }

  Future<dynamic> getSalarySlipDetails(String name) async{
    var response = await ApiMethodHandler().makeGETRequest(url: 'api/resource/Salary Slip/$name');
    var finalData =  jsonDecode(response.toString());
    return finalData;
  }
}