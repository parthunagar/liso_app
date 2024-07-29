import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/models.dart';

class UserRepository {
  User? _user;

  Future<User?> getUser() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (_user != null) return _user;

    final url = Uri.parse('http://liso.sweep6.nl/api/user/me');
    print('getUser => url : $url');
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final dynamic responseJson = json.decode(response.body);
      print('getUser => responseJson : ${responseJson.toString()}');

      final id = responseJson['data']['user']['id'].toString();
      final mainLibraryId =
          int.parse(responseJson['data']['user']['mainLibraryId'].toString());
      return _user = User(id, mainLibraryId);
    } else {
      //throw AuthenticationException(message: 'Wrong username or password');
    }
  }
}
