import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class FavouriteController extends GetxController {
  static FavouriteController get instance => Get.find();

  final name = TextEditingController();
  final address = TextEditingController();
  final storage = FlutterSecureStorage();

  Future<List> fetchFavourites() async {
    List<dynamic> data = [];
    String HOST = "http://192.168.1.13:8000";
    String? token = await storage.read(key: "access_token");

    if (token == null) {
      return [];
    }

    print(token);

    try {
      final response = await http.get(Uri.parse("$HOST/store/favorite") , headers: <String, String>{
        "access-token": token,
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
