import 'dart:io';
import 'package:community/locator/locator.dart';
import 'package:community/router/routing_constants.dart';
import 'package:community/service/navigation_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart' as GetHandler;
import 'package:get/get_core/src/get_main.dart';

import '../helpers/shared_preferences.dart';
import 'dioSingleton.dart';

class ApiMethodHandler {

  void handleException(e,url){
    print('*****');
    print(e.toString());
    print(url);
    if(e.response != null){
      if(e is SocketException){
        getSnackBar(description: 'No Internet Connection. Please Connect to Wifi or Mobile Network.');
      } else if(
              e.response!.data['exc_type'] == 'PermissionError' ||
              e.response!.data['exc_type'] == 'ValidationError' ||
              e.response!.data['exc_type'] == 'TimestampMismatchError' ||
              e.response!.data['exc_type'] == 'MissingDocumentError' ||
              e.response!.data['exc_type'] == 'DoesNotExistError' ||
              e.response!.data['exc_type'] == 'AlreadyExistsError' ||
              e.response!.data['exc_type'] == 'UnpermittedError' ||
              e.response!.data['exc_type'] == 'InvalidStatusError' ||
              e.response!.data['exc_type'] == 'DataError' ||
              e.response!.data['exc_type'] == 'TransitionError' ||
              e.response!.data['exc_type'] == 'RateLimitExceededError' ||
              e.response!.data['exc_type'] == 'NamingError' ||
              e.response!.data['exc_type'] == 'ReadOnlyError' ||
              e.response!.data['exc_type'] == 'WorkflowPermissionError' ||
              e.response!.data['exc_type'] == 'DuplicateEntryError' ||
              e.response!.data['exc_type'] == 'InsufficientLeaveBalanceError' ||
              e.response!.data['exc_type'] == 'OverlappingAttendanceRequestError' ||
              e.response!.data['exc_type'] == 'OverlapError' ||
          e.response!.data['exception'].split(" ")[0] == 'frappe.exceptions.PermissionError:' ||
                  e.response!.data['exception'].split(" ")[0] == 'frappe.exceptions.PermissionError')
    {
          if(e.response!.data['exception'] != null){
            print('****');
            print(e.response!.data);
            getSnackBar(description: e.response!.data['_server_messages']);
          }
      } else if(e.response!.data['exception'].split(" ")[0] == 'ModuleNotFoundError:'){
        getSnackBar(description: e.response!.data['exception']);
      } else{
        switch (e.response!.statusCode) {
          case 400:
            getSnackBar(description: 'Either no Permission or Session Expired. Please re-login or contact erp.support@ambibuzz.com');
            locator.get<NavigationService>().navigateTo(authScreen);
            break;
          case 401:
            getSnackBar(description: 'Either no Permission or Session Expired. Please re-login or contact erp.support@ambibuzz.com');
            locator.get<NavigationService>().navigateTo(authScreen);
            break;
          case 403:
            getSnackBar(description: 'Either no Permission or Session Expired. Please re-login or contact erp.support@ambibuzz.com');
            locator.get<NavigationService>().navigateTo(authScreen);
            break;
          case 404:
            getSnackBar(description: 'Not found $contactSupport');
            break;
          case 408:
            getSnackBar(description: 'Request Timed Out $contactSupport');
            break;
          case 409:
            getSnackBar(description: 'Conflict $contactSupport');
            break;
          case 500:
            getSnackBar(description: 'Internal Server Error $contactSupport');
            break;
          case 503:
            getSnackBar(description: 'Service Unavailable $contactSupport');
            break;
          default:
            switch(e.type){
              case DioExceptionType.sendTimeout:
                getSnackBar(description: 'Send Timeout $contactSupport');
                break;
              case DioExceptionType.cancel:
                getSnackBar(description: "Request Cancelled $contactSupport");
                break;
              case DioExceptionType.connectionTimeout:
                getSnackBar(description: "Connection Timeout $contactSupport");
                break;
              case DioExceptionType.unknown:
                getSnackBar(description: "Unknown Error Occurred $contactSupport");
                break;
              case DioExceptionType.receiveTimeout:
                getSnackBar(description: 'Recieve Timeout $contactSupport');
                break;
              case DioExceptionType.badCertificate:
                getSnackBar(description: 'Bad Certificate $contactSupport');
                break;
              case DioExceptionType.badResponse:
                getSnackBar(description: 'Bad Response $contactSupport');
                break;
              case DioExceptionType.connectionError:
                getSnackBar(description: 'Connection Error');
                break;
              default:
                getSnackBar(description: 'Something went wrong! $contactSupport');
                break;
            }
            break;
        }
      }
    } else {
      getSnackBar(description: 'Something went wrong! $contactSupport');
    }
  }

  static String contactSupport = 'Please contact your HR for further assistance.';
  getSnackBar({
    required String description
}) {
    return Get.snackbar(
        "Error!","",
        messageText: HtmlWidget(description),
        icon: const Icon(Icons.cancel_outlined, color: Colors.white),
        snackPosition: GetHandler.SnackPosition.TOP,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.white//Color(0xFFE38080)
    );
  }

  Future<Response?> makeGETRequest({
    required String url
}) async{
    var id =  await getId();
    var headers = {'Cookie': 'sid=$id;'};
    try{
      DioInstance dioInstance = DioInstance();
      Dio dio = await dioInstance.getDioInstance();
      Response userData = await dio.get(
          url,
          options: Options(
              headers: headers
          )
      );
      return userData;
    } on DioException catch(e) {
      handleException(e,url);
    }
    return null;
  }

  Future<Response?> makePOSTRequest({
    required headers,
    required String url,
    required data,
  }) async{
    try{
      DioInstance dioInstance = DioInstance();
      Dio dio = await dioInstance.getDioInstance();
      Response userData = await dio.post(
          url,
          data: data,
          options: Options(
              headers: headers
          )
      );
      return userData;
    } on DioException catch(e) {
      handleException(e,url);
    }
    return null;
  }

  Future<Response?> makePOSTRequestWithDiffURL({
    required headers,
    required String url,
    required data,
  }) async{
    try{
      Dio dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));
      Response userData = await dio.post(
          url,
          data: data,
          options: Options(
              headers: headers
          )
      );
      return userData;
    } on DioException catch(e) {
      handleException(e,url);
    }
    return null;
  }

  Future<Response?> makePOSTRequestToAuthenticateURL({
    required headers,
    required String url,
    required data,
  }) async{
    Response? userData;
    try{
      Dio dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));
      userData = await dio.post(
          url,
          data: data,
          options: Options(
              headers: headers
          )
      );
      return userData;
    } on DioException {
      return userData;
    }
  }

  Future<Response?> makePUTRequest({
    required headers,
    required String url,
    required data,
  }) async{
    try{
      DioInstance dioInstance = DioInstance();
      Dio dio = await dioInstance.getDioInstance();
      Response userData = await dio.put(
          url,
          data: data,
          options: Options(
              headers: headers
          )
      );
      return userData;
    } on DioException catch(e) {
      handleException(e,url);
    }
    return null;
  }
}