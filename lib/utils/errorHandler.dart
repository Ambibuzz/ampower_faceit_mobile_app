import 'package:get/get.dart';
import '../helpers/shared_preferences.dart';
import '../locator/locator.dart';
import '../router/routing_constants.dart';
import '../service/navigation_service.dart';

void handleError(){
  locator.get<NavigationService>().navigateTo(homeScreenViewRoute);
}

void handleTokenError2(){
  removeId();
  removeLoggedIn();
  removeEmail();
  locator.get<NavigationService>().navigateTo(authScreen);
}