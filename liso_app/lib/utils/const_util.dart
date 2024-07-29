import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppConst {
  final storage = const FlutterSecureStorage();

  Future<String?> readData(String key) async {
    var getReadData = await storage.read(key: key);
    print('readData => getReadData : key - $getReadData');
    return getReadData;
  }
}
