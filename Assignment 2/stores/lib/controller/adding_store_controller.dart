import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddStoreController extends GetxController {
  static AddStoreController get instance => Get.find();

  final name = TextEditingController();
  final address = TextEditingController();

  void addStore() async {
    String HOST = "http://192.168.1.13:8000";
    String name = this.name.text;
    String address = this.address.text;
    Map<String, String> data = {
      "name": name,
      "location": address, 
    };

    try {
      final response = await http.post(
        Uri.parse("$HOST/store"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        "access-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjIwMjAwNTY4IiwiZXhwIjoxNzE2OTgyNjI3fQ.iiJNoKY8cMKB0ZofdTlKFUeHUXXy_cddSWSsWrEAZS4",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print(response.body);
      }
    }
    catch (e) {
      print(e);
    }
  }
}
