import 'package:community/helpers/shared_preferences.dart';

class Urls {
 Future<String> root() async{
   String root = await getBaseUrl() ?? '';
   return root;
 }
}

class AppVersion {
  static const version = '20.0.0';
}