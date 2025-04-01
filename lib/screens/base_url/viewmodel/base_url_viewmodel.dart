import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../base_viewmodel.dart';
import '../../../helpers/shared_preferences.dart';
import '../../../locator/locator.dart';
import '../../../router/routing_constants.dart';
import '../../../service/navigation_service.dart';

class BaseUrlViewModel extends BaseViewModel{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final baseUrlController = TextEditingController();
  bool settingBaseUrl = false;

  void setBaseURLAndNavigateToAuthScreen(String url) async {
    settingBaseUrl = true;
    notifyListeners();
    await setBaseURL("$url/");
    settingBaseUrl = false;
    notifyListeners();
    locator.get<NavigationService>().navigateTo(authScreen);
  }


  getBaseurlFromLocalStorage() async{
    baseUrlController.text = await getBaseUrl() ?? '';
  }

}