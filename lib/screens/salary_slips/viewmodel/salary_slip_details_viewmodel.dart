import 'dart:convert';
import 'dart:io';

import 'package:community/base_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../helpers/shared_preferences.dart';
import '../../../helpers/toast.dart';
import '../../../utils/Urls.dart';
import '../api_requests/web_requests.dart';
import '../cache/salary_slip_cache.dart';

class SalarySlipDetailsViewModel extends BaseViewModel{
  dynamic salarySlipDetails;
  final formKey = GlobalKey<FormState>();
  bool showDownloadProgress = false;
  double downloadPercent = 0.0;

  getSalarySlipDetails(bool force,String docName) async{
    var tempDetails = await SalarySlipCache().getSalarySlipDetailsFromCache(docName);
    if(tempDetails == false || force){
      salarySlipDetails = await WebRequests().getSalarySlipDetails(docName);
      await SalarySlipCache().putSalarySlipDetailsInCache(docName, jsonEncode(salarySlipDetails));
    } else {
      salarySlipDetails = jsonDecode(tempDetails);
    }
    notifyListeners();
  }

  Future<void> downloadSalarySlip(context,docName) async {
    showDownloadProgress = true;
    notifyListeners();

    try {
      var id = await getId();
      var headers = {'Cookie': 'sid=$id;','Content-Type':"application/json","Accept": "application/json",};
      String baseURL = await Urls().root();
      String fileurl = baseURL+"api/method/frappe.utils.print_format.download_pdf?doctype=Salary Slip&name=${docName}&letterhead=Ambibuzz Letter Head&settings={}&_lang=en";

      if(Platform.isAndroid){
        // Download the PDF
        final dio = Dio();
        final response = await dio.get(
          fileurl,
          options: Options(
              responseType: ResponseType.bytes,
              headers: headers
          ),
        );

        // Save the PDF to the downloads folder
        var dir = await getApplicationSupportDirectory();
        String savename = "${docName}.pdf";
        String pdfPath = "${dir.path}/${savename.split("/").last}";
        final file = File(pdfPath);
        await file.writeAsBytes(response.data);

        // Use MediaStore to make the file visible in the gallery (Android only)
        final result = await MediaStore().saveFile(
            tempFilePath: file.path,
            dirType: DirType.download,
            dirName: DirType.download.defaults,
            relativePath: "Salary Slip"
        );

        if (result!.isSuccessful) {
          fluttertoast(context,"File is saved to download folder.");
          showDownloadProgress = false;
          notifyListeners();
        } else {
          fluttertoast(context,"No permission to read and write.");
          showDownloadProgress = false;
        }
      } else if(Platform.isIOS){
        showDownloadProgress = true;
        notifyListeners();

        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
          Permission.manageExternalStorage
          //add more permission to request here.
        ].request();

        if(statuses[Permission.storage]!.isGranted || statuses[Permission.manageExternalStorage]!.isGranted){
          var dir = await getApplicationDocumentsDirectory();
          if(dir != null){
            String savename = "${docName!.split('/')[1]}.pdf";
            String savePath = dir.path + "/$savename";
            try {
              await Dio().download(
                  fileurl,
                  savePath,
                  onReceiveProgress: (received, total) {
                    if (total != -1) {
                      downloadPercent = (received / total * 100);
                      notifyListeners();
                    }
                  },
                  options: Options(headers: headers)
              );
              //fluttertoast(context,"File is saved to download folder.");
              OpenFilex.open(savePath);
              showDownloadProgress = false;
              notifyListeners();
            } on DioError catch (e) {
              print(e.message);
            }
          }
        }else{
          fluttertoast(context,"No permission to read and write.");
        }
      }


    } on DioException catch (e) {
      print(e.message);
    }
  }
}