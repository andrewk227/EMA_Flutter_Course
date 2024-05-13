import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:stores/controller/favourite_controller.dart';
import 'package:stores/global.dart';
import 'package:stores/model/store.dart';

class StoreController extends GetxController {
  static StoreController get instance => Get.find();

  final name = BehaviorSubject<String>();
  final address = BehaviorSubject<String>();
  final storage = FlutterSecureStorage();

// getters to get the value of the variables
  Stream<String> get name$ => name.stream;
  Stream<String> get address$ => address.stream;

// Setter to update the value of the variables
  Function(String) get setName => name.sink.add;
  Function(String) get setAddress => address.sink.add;

  Future<List<StoreModel>> getStores() async {
    await FavouriteController.instance.fetchFavourites();

    List<dynamic> data = [];
    String? token = await storage.read(key: "access_token");
    if (token == null) {
      return [];
    }

    try {
      final response =
          await http.get(Uri.parse("$HOST/store"), headers: <String, String>{
        "access-token": token,
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }

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
  }

  Future<bool> toggleFavorite(int id) async {
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
        body: jsonEncode(<String, int>{'id': id}),
      );
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  void dispose() {
    name.close();
    address.close();
    super.dispose();
  }
}
