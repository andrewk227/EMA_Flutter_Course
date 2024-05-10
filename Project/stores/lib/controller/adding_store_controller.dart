import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddStoreController extends GetxController {
  static AddStoreController get instance => Get.find();

  final name = TextEditingController();
  final address = TextEditingController();
  final storage = FlutterSecureStorage();
  SnackBar snackBar = const SnackBar(content: Text(""));

  Future<bool> addStore() async {
    String HOST = "http://192.168.1.13:8000";
    String name = this.name.text;
    String address = this.address.text;
    String? token = await storage.read(key: "access_token");

    if (token == null) {
      return false;
    }

    Map<String, String> data = {
      "name": name,
      "location": address,
    };

    try {
      final response = await http.post(
        Uri.parse("$HOST/store"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "access-token": token
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print(response.body);
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
