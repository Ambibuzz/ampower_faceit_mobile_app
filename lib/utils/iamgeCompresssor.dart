import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File> compressFile(File file) async {
  var compressedData = await FlutterImageCompress.compressWithFile(file.absolute.path,quality: 20,);
  File compressedFile = File(file.path);
  compressedFile.writeAsBytes(compressedData as List<int>);
  return compressedFile;
}