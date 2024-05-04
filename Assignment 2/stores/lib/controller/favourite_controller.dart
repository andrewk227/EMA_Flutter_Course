import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class FavouriteController extends GetxController {
  static FavouriteController get instance => Get.find();

  final name = TextEditingController();
  final address = TextEditingController();

  Future<List> fetchFavourites() async {
    List<dynamic> data = [];
    String HOST = "http://192.168.1.13:8000";
    try {
      final response = await http.get(Uri.parse("$HOST/store/favorite") , headers: <String, String>{
        "access-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjIwMjAwNTY4IiwiZXhwIjoxNzE2OTgyNjI3fQ.iiJNoKY8cMKB0ZofdTlKFUeHUXXy_cddSWSsWrEAZS4",
         'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        print(data);
      }
    }
    catch (e) {
      print(e);
    }
    return data;
  }
}
