import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import '../global.dart';
import '../model/product.dart';

class ShopMenuController extends GetxController {
  static ShopMenuController get instance => Get.find();

  final storage = const FlutterSecureStorage();
  BehaviorSubject<int> shopId = BehaviorSubject<int>();
  BehaviorSubject<List<ProductModel>> _products =
      BehaviorSubject<List<ProductModel>>();

  Stream<List<ProductModel>> get products$ => _products.stream;
  Stream<int> get shopId$ => shopId.stream;

  Function(int) get setShopId => shopId.sink.add;

  Future<void> fetchProducts() async {
    List<dynamic> data = [];
    String? token = await storage.read(key: "access_token");
    if (token == null) {
      return;
    }

    try {
      final response = await http.get(
          Uri.parse("$HOST/shop/products/${shopId.value}"),
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

    try {
      final response = await http.get(
          Uri.parse("$HOST/shop/products/${shopId.value}"),
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

    List<ProductModel> products = [];
    for (int i = 0; i < data.length; i++) {
      ProductModel productInstance = ProductModel(
          id: data[i]["id"], name: data[i]["name"], price: data[i]["price"]);
      products.add(productInstance);
    }
    print(products);
    _products.value = products;
  }

  void setProducts(BehaviorSubject<List<ProductModel>> behaviorSubject) {
    _products = behaviorSubject;
  }
}
