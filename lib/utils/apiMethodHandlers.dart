import 'dart:convert';
import 'dart:io';
import 'package:community/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart' as GetHandler;
import 'package:get/get_core/src/get_main.dart';
import '../helpers/shared_preferences.dart';
import '../locator/locator.dart';
import '../router/routing_constants.dart';
import '../service/navigation_service.dart';
import 'dioSingleton.dart';

class ApiMethodHandler {
  Future<void> handleException(e, String url) async {
    print('************');
    print(e.toString());
    print(url);

    // Check internet connectivity
    if (!(await hasInternet()) || e is SocketException) {
      locator.get<NavigationService>().navigateTo(noInternetScreen);
      return;
    }

    // Handle DioException (Frappe responses)
    if (e is DioException && e.response != null) {
      final resp = e.response!;
      final data = resp.data;

      try {
        // Handle Frappe known exceptions
        if (data != null && data['exc_type'] != null) {
          final excType = data['exc_type'];
          final exception = data['exception'] ?? '';

          if ([
            'PermissionError',
            'ValidationError',
            'TimestampMismatchError',
            'MissingDocumentError',
            'DoesNotExistError',
            'AlreadyExistsError',
            'UnpermittedError',
            'InvalidStatusError',
            'DataError',
            'TransitionError',
            'RateLimitExceededError',
            'NamingError',
            'ReadOnlyError',
            'WorkflowPermissionError',
            'DuplicateEntryError',
            'OverlappingAttendanceRequestError',
            'OverlapError'
          ].contains(excType) ||
              exception.startsWith('frappe.exceptions.PermissionError:')) {
            if (data['_server_messages'] != null) {
              final rawServerMessages = data['_server_messages'];
              final decodedList = json.decode(rawServerMessages);
              final messageMap = json.decode(decodedList[0]);
              final message = messageMap['message'];
              getSnackBar(description: message);
              return;
            }
          }

          if (exception.startsWith('ModuleNotFoundError:')) {
            getSnackBar(description: exception);
            return;
          }
        }

        // Handle HTTP status codes
        switch (resp.statusCode) {
          case 400:
          case 401:
          case 403:
            getSnackBar(
                description:
                'Either no Permission or Session Expired. Please re-login or contact erp.support@ambibuzz.com');
            locator.get<NavigationService>().navigateTo(authScreen);
            return;
          case 404:
            getSnackBar(description: 'Not found $contactSupport');
            return;
          case 408:
            getSnackBar(description: 'Request Timed Out $contactSupport');
            return;
          case 409:
            getSnackBar(description: 'Conflict $contactSupport');
            return;
          case 500:
            getSnackBar(description: 'Internal Server Error $contactSupport');
            return;
          case 503:
            getSnackBar(description: 'Service Unavailable $contactSupport');
            return;
        }

        // Handle DioException types
        switch (e.type) {
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
            getSnackBar(description: 'Receive Timeout $contactSupport');
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
      } catch (err) {
        print('Error parsing Frappe response: $err');
        getSnackBar(description: 'Something went wrong! $contactSupport');
      }
    } else {
      // Fallback for non-Dio exceptions
      getSnackBar(description: 'Something went wrong! $contactSupport');
    }
  }

  static String contactSupport =
      'Please contact your HR for further assistance.';
  getSnackBar({required String description}) {
    return Get.snackbar("Error!", "",
        messageText: HtmlWidget(description),
        icon: const Icon(Icons.cancel_outlined, color: Colors.white),
        snackPosition: GetHandler.SnackPosition.TOP,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.white //Color(0xFFE38080)
    );
  }

  Future<Response?> makeGETRequest({required String url}) async {
    var id = await getId();
    var headers = {'Cookie': id};
    try {
      // Check internet connectivity
      if (!(await hasInternet())) {
        locator.get<NavigationService>().navigateTo(noInternetScreen);
        return null;
      }

      DioInstance dioInstance = DioInstance();
      Dio dio = await dioInstance.getDioInstance();
      Response userData = await dio.get(url, options: Options(headers: headers));
      return userData;
    } on DioException catch (e) {
      print(e.toString());
      handleException(e, url);
    }
    return null;
  }


  Future<Response?> makePOSTRequest({
    required headers,
    required String url,
    required data,
  }) async {
    try {

      // Check internet connectivity
      if (!(await hasInternet())) {
        locator.get<NavigationService>().navigateTo(noInternetScreen);
        return null;
      }
      //change header cookies
      var id = await getId();
      headers['Cookie'] = id;

      DioInstance dioInstance = DioInstance();
      Dio dio = await dioInstance.getDioInstance();
      Response userData = await dio.post(url, data: data, options: Options(headers: headers));
      return userData;
    } on DioException catch (e) {
      handleException(e, url);
    } catch(e) {
      handleException(e, url);
    }
    return null;
  }

  Future<Response?> makePOSTRequestWithDiffURL({
    required headers,
    required String url,
    required data,
  }) async {
    try {
      // Check internet connectivity
      if (!(await hasInternet())) {
        locator.get<NavigationService>().navigateTo(noInternetScreen);
        return null;
      }
      //change header cookies
      var id = await getId();
      headers['Cookie'] = id;
      Dio dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));
      Response userData =
      await dio.post(url, data: data, options: Options(headers: headers));
      return userData;
    } on DioException catch (e) {
      handleException(e, url);
    }
    return null;
  }

  Future<Response?> makePOSTRequestToAuthenticateURL({
    required headers,
    required String url,
    required data,
  }) async {
    Response? userData;
    try {
      // Check internet connectivity
      if (!(await hasInternet())) {
        locator.get<NavigationService>().navigateTo(noInternetScreen);
        return null;
      }

      Dio dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));
      userData =
      await dio.post(url, data: data, options: Options(headers: headers));
      return userData;
    } on DioException {
      return userData;
    }
  }

  Future<Response?> makePUTRequest({
    required headers,
    required String url,
    required data,
  }) async {
    try {
      // Check internet connectivity
      if (!(await hasInternet())) {
        locator.get<NavigationService>().navigateTo(noInternetScreen);
        return null;
      }
      //change header cookies
      var id = await getId();
      headers['Cookie'] = id;
      DioInstance dioInstance = DioInstance();
      Dio dio = await dioInstance.getDioInstance();
      Response userData = await dio.put(url, data: data, options: Options(headers: headers));
      return userData;
    } on DioException catch (e) {
      handleException(e, url);
    }
    return null;
  }
}
