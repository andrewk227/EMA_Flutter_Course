import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:stores/global.dart';
import 'package:stores/model/store.dart';

class StoreController extends GetxController {
  static StoreController get instance => Get.find();

  final name = BehaviorSubject<String>();
  final longitude = BehaviorSubject<double>();
  final latitude = BehaviorSubject<double>();
  final storage = FlutterSecureStorage();

// getters to get the value of the variables
  Stream<String> get name$ => name.stream;
  Stream<double> get longitude$ => longitude.stream;
  Stream<double> get latitude$ => latitude.stream;

// Setter to update the value of the variables
  Function(String) get setName => name.sink.add;
  Function(double) get setLongitude => longitude.sink.add;
  Function(double) get setLatitude => latitude.sink.add;

  Future<List<StoreModel>> getStores() async {
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

    List<StoreModel> stores = [];

    for (int i = 0; i < data.length; i++) {
      StoreModel storeInstance = StoreModel(
          id: data[i]["id"],
          name: data[i]["name"],
          longitude: data[i]["longitude"],
          latitude: data[i]["latitude"]);
      stores.add(storeInstance);
    }
    print(stores);
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
    super.dispose();
  }
}
