import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stores/global.dart';
import 'package:http/http.dart' as http;
import 'package:stores/model/shops.dart';

class ShopProductsController extends GetxController {
  static ShopProductsController get instance => Get.find();

  final storage = const FlutterSecureStorage();
  BehaviorSubject<List<ShopModel>> _shops = BehaviorSubject<List<ShopModel>>();
  Stream<List<ShopModel>> get shops$ => _shops.stream;

  List<ShopModel> get shopsValues => _shops.value;

  BehaviorSubject<int> productId = BehaviorSubject<int>();
  Stream<int> get productId$ => productId.stream;
  Function(int) get setProductId => productId.sink.add;

  Future<void> fetchShops() async {
    List<dynamic> data = [];
    String? token = await storage.read(key: "access_token");
    if (token == null) {
      return;
    }

    try {
      final response = await http.get(
          Uri.parse("$HOST/product/shops/${productId.value}"),
          headers: <String, String>{
            "access-token": token,
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }

    List<ShopModel> shops = [];

    for (int i = 0; i < data.length; i++) {
      ShopModel storeInstance = ShopModel(
          id: data[i]["id"],
          name: data[i]["name"],
          latitude: data[i]["latitude"],
          longitude: data[i]["longitude"]);
      shops.add(storeInstance);
    }
    print(shops);
    _shops.value = shops;
  }

  void setShops(BehaviorSubject<List<ShopModel>> behaviorSubject) {
    _shops = behaviorSubject;
  }
}
