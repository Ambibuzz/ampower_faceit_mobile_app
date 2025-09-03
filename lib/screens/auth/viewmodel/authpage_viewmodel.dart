
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../base_viewmodel.dart';
import '../../auth/api_requests/web_requests.dart';
import '../../home/view/home.dart';

class AuthPageViewModel extends BaseViewModel{
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;
  String? email;
  String? password;
  bool isLoggingIn = false;

  void changePasswordVisibility() {
    obscureText = !obscureText;
    notifyListeners();
  }

  void authenticateEmployee(String email,String password,context) async{
    isLoggingIn = true;
    notifyListeners();
    bool isAuthenticated = await WebRequests().emailAuth(email, password,context);
    isLoggingIn = false;
    notifyListeners();
    if(isAuthenticated){
      Get.offAll(Home());
    }
  }
}