import 'package:community/apis/common_api_request/common_api.dart';
import 'package:community/base_viewmodel.dart';
import 'package:community/locator/locator.dart';
import 'package:community/router/routing_constants.dart';
import 'package:community/service/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helpers/shared_preferences.dart';
class ProfilePageViewModel extends BaseViewModel{
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController company = TextEditingController();
  final TextEditingController department = TextEditingController();
  final TextEditingController designation = TextEditingController();
  List<dynamic> empDetails = [];

  Future<void> getEmployeeDetails() async {
    empDetails = await CommonApiRequest().employeeDetails() ?? [];
    initDetails();
  }

  void initDetails() async {
    firstName.text = empDetails[0]['first_name'] ?? '';
    lastName.text = empDetails[0]['last_name'] ?? '';
    email.text = empDetails[0]['company_email'] ?? '';
    phoneNumber.text = empDetails[0]['cell_number'] ?? '';
    company.text = empDetails[0]['company'] ?? '';
    department.text = empDetails[0]['department'] ?? '';
    designation.text = empDetails[0]['designation'] ?? '';
  }

  void logoutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    await prefs.remove('token');
    var doctypeBox = await Hive.openBox('doctypes');
    doctypeBox.clear();
    removeLoggedIn();
    removeId();
    locator.get<NavigationService>().navigateTo(baseUrl);
  }

}