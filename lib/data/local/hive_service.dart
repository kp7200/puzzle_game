import 'package:hive_flutter/hive_flutter.dart';

class HiveService {

  Future<void> init() async {
    await Hive.initFlutter();
    // Register adapters here later
    // await Hive.openBox(_progressBox);
  }

  // Future<Box> get progressBox async {
  //   return await Hive.openBox(_progressBox);
  // }
}
