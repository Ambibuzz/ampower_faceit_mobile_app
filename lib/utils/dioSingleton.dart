import 'package:dio/dio.dart';

import 'Urls.dart';

class DioInstance{
  //private constructor
  //DioInstance._();

  //private instance
  Dio? _dioInstance;

  //method to access the instance
  Future<Dio> getDioInstance() async{
    String baseURL = await Urls().root();
    if(_dioInstance == null) {
      final options = BaseOptions(
        baseUrl: baseURL,
        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 25),
      );
      _dioInstance = Dio(options);
    }
    return _dioInstance ?? Dio();
  }

}