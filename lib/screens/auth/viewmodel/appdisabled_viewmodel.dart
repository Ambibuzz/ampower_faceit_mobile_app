import 'package:community/base_viewmodel.dart';
import 'package:community/screens/home/view/home.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../apis/common_api_request/common_api.dart';

class AppDisabledViewModel extends BaseViewModel {
  bool isCheckingApp = false;

  void checkConfig() async {
    isCheckingApp = true;
    notifyListeners();
    bool result = await CommonApiRequest().isFaceITEnabled();
    if(result) {
      Get.offAll(Home());
    }
    isCheckingApp = false;
    notifyListeners();
  }
}