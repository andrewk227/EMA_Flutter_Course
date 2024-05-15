import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stores/controller/search_controller.dart';
import 'package:stores/global.dart';
import 'package:stores/model/product.dart';
import 'package:http/http.dart' as http;

class SearchOutputController extends GetxController {
  static SearchOutputController get instance => Get.find();

  final storage = FlutterSecureStorage();

  SearchPageController searchController = Get.put(SearchPageController());

  BehaviorSubject<List<ProductModel>> _searchOutput =
      BehaviorSubject<List<ProductModel>>();

  Stream<List<ProductModel>> get searchOutput$ => _searchOutput.stream;

  Future<void> fetchSearchOutput() async {
    List<dynamic> data = [];
    String? token = await storage.read(key: "access_token");
    if (token == null) {
      return;
    }

    try {
      print("Value: ");
      print(searchController.searchResult.value);
      print("stream: ");
      print(searchController.searchResult.stream);
      print("stream.value: ");
      print(searchController.searchResult.stream.value);

      final response = await http.get(
          Uri.parse("$HOST/product/${searchController.searchResult.value}"),
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
      ProductModel storeInstance = ProductModel(
        id: data[i]["id"],
        name: data[i]["name"],
        price: data[i]["price"],
      );
      products.add(storeInstance);
    }
    print(products);
    _searchOutput.value = products;
  }
}
