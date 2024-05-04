import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final id = TextEditingController();
  final password = TextEditingController();
  final storage = FlutterSecureStorage();

  Future<bool> login() async {
    String HOST = "http://192.168.1.13:8000";
    String id = this.id.text;
    String password = this.password.text;

    Map<String, dynamic> data = {
      "id": id,
      "password": password,
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
        await storage.write(key: 'access_token', value: responseJson['access_token']);
        return true;
      }
      else{
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
