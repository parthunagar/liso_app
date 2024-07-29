import 'dart:async';
import 'dart:convert';
import 'package:authentication_repository/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as path;

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  final storage = FlutterSecureStorage();
  BuildContext? context; // = BuildContext();

  String? token = '';
  Future<String?> getToken() async {
    token = await storage.read(key: 'token');
    print('AuthenticationRepository ====> getToken - token : $token');
    return token;
  }

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield token != null ? AuthenticationStatus.authenticated : AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    print('calling token API');
    var url = Uri.parse('http://liso.sweep6.nl/api/auth/token');
    print('logIn => url : ${url.toString()}');
    var response = await http.post(url, headers: {
      'Accept': 'application/json'
    }, body: {
      'email': username.toLowerCase(),
      'password': password,
      'deviceName': 'Flutter'
    });
    print('logIn => response : ${response.toString()}');

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      print('logIn => responseJson : ${responseJson.toString()}');

      // Store token
      final token = responseJson['data']['token'] as String;
      print('logIn => token : ${token.toString()}');

      await storage.write(key: 'token', value: token);

      //return User.fromJson(user);
      print('Got a success response');
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      final responseJson = json.decode(response.body);
      print('to bad not working');
      // print('responseJson : $responseJson');
      // print('responseJson : ${responseJson['errors']['email'][0].toString()}');
      // AppToast().showToast("${responseJson['message'].toString()} \n ${responseJson['errors']['email'][0].toString()}");
      AppToast().showToast("${responseJson['message'].toString()}");

      // ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(content: Text('The loan was submitted successfully')));
      //throw AuthenticationException(message: 'Wrong username or password');
    }
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
