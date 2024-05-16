import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:stores/global.dart';
import 'package:stores/model/product.dart';
import 'package:stores/model/shops.dart';

class StoreController extends GetxController {
  static StoreController get instance => Get.find();

  final name = BehaviorSubject<String>();
  final longitude = BehaviorSubject<double>();
  final latitude = BehaviorSubject<double>();
  final storage = FlutterSecureStorage();

  Future<List<ShopModel>> getStores() async {
    List<dynamic> data = [];
    String? token = await storage.read(key: "access_token");
    if (token == null) {
      return [];
    }

    try {
      final response =
          await http.get(Uri.parse("$HOST/shop"), headers: <String, String>{
        "access-token": token,
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }

    List<ShopModel> stores = [];

    for (int i = 0; i < data.length; i++) {
      ShopModel storeInstance = ShopModel(
          id: data[i]["id"],
          name: data[i]["name"],
          longitude: data[i]["longitude"],
          latitude: data[i]["latitude"]);
      stores.add(storeInstance);
    }
    print(stores);
    return stores;
  }

  void dispose() {
    name.close();
    super.dispose();
  }
}
