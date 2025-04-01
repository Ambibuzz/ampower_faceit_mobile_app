import 'package:hive_flutter/hive_flutter.dart';

class StorageService{
  Future<Box> initHiveBox(String name) {
    return Hive.openBox(name);
  }

  Box getHiveBox(String name) {
    return Hive.box(name);
  }

  Future initHiveStorage() {
    return Hive.initFlutter();
  }
}