// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stores/global.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final id = BehaviorSubject<String>();
  final password = BehaviorSubject<String>();
  final storage = FlutterSecureStorage();

// getters to get the value of the variables
  Stream<String> get id$ => id.stream;
  Stream<String> get password$ => password.stream;

// Setter to update the value of the variables
  Function(String) get setId => id.sink.add;
  Function(String) get setPassword => password.sink.add;

  Future<bool> login() async {
    String ID = id.value ?? "";
    String Password = password.value ?? "";

    Map<String, dynamic> data = {
      "id": ID,
      "password": Password,
    };

    try {
      final response = await http.post(
        Uri.parse("$HOST/user/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        await storage.write(
            key: 'access_token', value: responseJson['access_token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  void dispose() {
    id.close();
    password.close();
    super.dispose();
  }
}
