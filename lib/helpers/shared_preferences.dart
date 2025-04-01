///Import Dart Modules
import 'package:shared_preferences/shared_preferences.dart';

setLoggedIn(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('loggedIn', value);
}

setId(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('id', id);
}

setEmail(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('email', email);
}

setFullName(String fullName) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('full_name', fullName);
}

setProfilePic(String url) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('profile_pic_url', url);
}

setLicenseExpiry(String expiryDate) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('license_expiry_date', expiryDate);
}

setGracePeriod(int gracePeriod) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('grace_period', gracePeriod);
}

setCheckPeriod(int checkPeriod) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('check_period', checkPeriod);
}

setLastExpiryCheck(String lastCheck) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('last_expiry_check', lastCheck);
}
setCheckInString(String checkinString) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('checkin_string', checkinString);
}
setBaseURL(String baseUrl) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('base_url', baseUrl);
}
Future<bool?> getLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('loggedIn');
}

Future<String?> getId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('id');
}

Future<String?> getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

Future<String?> getFullName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('full_name');
}

Future<String?> getProfilePic() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('profile_pic_url');
}

Future<String?> getLicenseExpiry() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('license_expiry_date');
}

Future<int?> getGracePeriod() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('grace_period');
}

Future<int?> getCheckPeriod() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('check_period');
}
Future<String?> getLastExpiryCheck() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('last_expiry_check');
}

Future<String?> getCheckinString() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('checkin_string');
}
Future<String?> getBaseUrl() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('base_url');
}

removeId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('id');
}

removeLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('loggedIn');
}

removeEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('email');
}

removeFullName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('full_name');
}

removeProfilePic() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('profile_pic_url');
}

removeExpiryDate() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('license_expiry_date');
}

removeGracePeriod() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('grace_period');
}

removeCheckPeriod() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('check_period');
}

removeLastExpiryCheck() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('last_expiry_check');
}

removeCheckinString() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('checkin_string');
}

removeBaseURL() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('base_url');
}