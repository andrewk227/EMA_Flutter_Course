import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stores/model/store.dart';

class FavouriteController extends GetxController {
  static FavouriteController get instance => Get.find();

  final name = TextEditingController();
  final address = TextEditingController();
  final storage = FlutterSecureStorage();
  late List<dynamic> favourites;

  Future<List<StoreModel>> fetchFavourites() async {
    List<dynamic> data = [];
    String HOST = "http://192.168.1.13:8000";
    String? token = await storage.read(key: "access_token");

    if (token == null) {
      return [];
    }

    print(token);

    try {
      final response = await http
          .get(Uri.parse("$HOST/store/favorite"), headers: <String, String>{
        "access-token": token,
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        print(data);
      }
    } catch (e) {
      print(e);
    }
    favourites = data;

    List<StoreModel> stores = [];

    for (int i = 0; i < data.length; i++) {
      StoreModel storeInstance =
          StoreModel(id: data[i][0], name: data[i][1], address: data[i][2]);
      if (FavouriteController.instance.isFavorite(storeInstance.id)) {
        storeInstance.isFavorite = true;
      }
      stores.add(storeInstance);
    }

    return stores;
    // return data;
  }

  bool isFavorite(int id) {
    FavouriteController.instance.favourites;
    for (var i = 0; i < FavouriteController.instance.favourites.length; i++) {
      if (FavouriteController.instance.favourites[i][0] == id) {
        return true;
      }
    }
    return false;
  }
}
