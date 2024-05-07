import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:stores_local/sqlite.dart';
class FavouriteController extends GetxController {
  static FavouriteController get instance => Get.find();

  final name = TextEditingController();
  final address = TextEditingController();
  final storage = FlutterSecureStorage();
  late List<Map<String, dynamic>> favourites; 
  SqliteDB db = SqliteDB();

  Future<List> fetchFavourites() async {
    String? token = await storage.read(key: "access_token");
    var storeIds = [];

    if (token == null) {
      return [];
    }

    try {
      String selectQuery = "SELECT * FROM Favorite_Stores WHERE student_id = '$token';";
      var response = await db.selectData(selectQuery);

      print(response);

      for (var i = 0; i < response.length; i++) {
        storeIds.add(response[i]['store_id']);
      }
      String storeIdsString = storeIds.map((id) => "'$id'").join(',');
      String selectStoresQuery = "SELECT * FROM Stores WHERE id IN ($storeIdsString);";
      response = await db.selectData(selectStoresQuery);
      
      favourites = response;
      return response;
    }
    catch (e) {
      print(e);
    }
    return [];
  }

  bool isFavorite(int id) {
    FavouriteController.instance.favourites;
    for (int i = 0; i < FavouriteController.instance.favourites.length; i++) {
      if (FavouriteController.instance.favourites[i]['id'] == id) {
        return true;
      }
    }
    return false;
  }

  deleteFavourite(int id) async{
    String? token = await storage.read(key: "access_token");
    String deleteQuery = "DELETE FROM Favorite_Stores WHERE student_id = '$token' AND store_id = '$id';";
    var response = await db.deleteData(deleteQuery);
    print(response);
  }


}
