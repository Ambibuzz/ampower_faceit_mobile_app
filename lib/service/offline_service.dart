import 'dart:convert';
import 'package:community/service/storage_service.dart';
import 'package:crypto/crypto.dart';

import '../locator/locator.dart';

class OfflineStorage {
  static var storage = locator.get<StorageService>().getHiveBox('offline');

  String generateKeyHash(String key) {
    return sha1.convert(utf8.encode(key)).toString();
  }

  Future putItem(String key, dynamic data) async {
    var v = {
      'timestamp': DateTime.now(),
      'data': data,
    };

    await storage.put(key, v);
  }

  getItem(String key) {
    if (storage.get(key) == null) {
      return {'data': null};
    }
    return storage.get(key);
  }
}
