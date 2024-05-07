import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stores/controller/favourite_controller.dart';
class StoreController extends GetxController {
  static StoreController get instance => Get.find();

  final name = TextEditingController();
  final address = TextEditingController();
  final storage = FlutterSecureStorage();

  Future<List<dynamic>> getStores() async {
    await FavouriteController.instance.fetchFavourites();

    String HOST = "http://192.168.1.13:8000";
    List<dynamic> data = [];
    String? token = await storage.read(key: "access_token");
    if (token == null) {
      return [];
    }

    try {
      final response = await http.get(Uri.parse("$HOST/store") , headers: <String, String>{
        "access-token": token,
         'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
      }
    }
    catch (e) {
      print(e);
    }

    return data;
  }

  Future<bool> addFavorite(int id) async {
    String HOST = "http://192.168.1.13:8000";  
    String? token = await storage.read(key: "access_token");
    if (token == null) {
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse("$HOST/store/favorite"),
        headers: <String, String>{
          "access-token": token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String , int>{'id': id }),
      );
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
