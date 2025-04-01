import 'dart:convert';
import 'package:get/get.dart' as Getx;
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../helpers/shared_preferences.dart';
import '../../../helpers/toast.dart';
import '../../../locator/locator.dart';
import '../../../utils/Urls.dart';
import '../../home/view/home.dart';
import '../viewmodel/authpage_viewmodel.dart';

class WebRequests {
  Future emailAuth( String email, String password,context) async {
    String baseURL = await Urls().root();
    var uri = '${baseURL}api/method/login';
    Map<String, String> requestBody = <String, String>{
      'usr': email,
      'pwd': password
    };
    try{
      final http.Response response = await http.post(
        Uri.parse(uri),
        body: requestBody,
      );
      if (response.statusCode == 200) {
        var finalData = await jsonDecode(response.body);
        var headersString = response.headers;
        var headersList = headersString['set-cookie']!.split(';');
        //var a = headersList[8].split(',');
        var id = headersList[0].substring(4);
        var fullName = finalData['full_name'];
        setLoggedIn(true);
        setId(id);
        setEmail(email);
        setFullName(fullName);
        Get.snackbar(
            "Logged in Successfully!",
            "Please continue.",
            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
            snackPosition: Getx.SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8)
        );
        Get.offAll(Home());
      } else if (response.statusCode == 401) {
        Get.snackbar(
            "Wrong Credentials",
            "You've entered wrong credentials.",
            icon: const Icon(Icons.cancel_outlined, color: Colors.white),
            snackPosition: Getx.SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFE38080)
        );
      } else {
        print('******');
        //print(ex);
        fluttertoast(context, 'Something went wrong');
      }
    }catch(ex){
      print('**');
      print(ex);
      fluttertoast(context, 'Something went wrong');
    }finally{
      locator.get<AuthPageViewModel>().isLoggingIn = false;
    }

  }
}