import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stores_local/controller/favourite_controller.dart';
import 'package:stores_local/sqlite.dart';
class StoreController extends GetxController {
  static StoreController get instance => Get.find();

  final name = TextEditingController();
  final address = TextEditingController();
  final storage = FlutterSecureStorage();
  SqliteDB db = SqliteDB();


  Future<List<dynamic>> getStores() async {
    await FavouriteController.instance.fetchFavourites();
    try{
      String query = "SELECT * FROM Stores;";

      var data = await db.selectData(query);

      return data;
    }
    catch(e){
      print(e);
    }
    return [];
  }

  Future<bool> toggleFavorite(int id) async {
    try{
      String? token = await storage.read(key: "access_token");
      var storeIds = [];
    
      if (token == null) {
        return false;
      }
      String selectQuery = "SELECT * FROM Favorite_Stores WHERE student_id = '$token';";
      var favorits = await db.selectData(selectQuery);

      for (var i = 0; i < favorits.length; i++) {
        storeIds.add(favorits[i]['store_id']);
      }

      if (storeIds.contains(id)) {
        String deleteQuery = "DELETE FROM Favorite_Stores WHERE student_id = '$token' AND store_id = '$id';";
        var response = await db.deleteData(deleteQuery);
        
        print(response);
        return false;
      }

      String insertQuery = "INSERT INTO Favorite_Stores (student_id , store_id) VALUES ('$token' , '$id');";
      var response = await db.insertData(insertQuery);
      
      print(response);
      return true;
    }
    catch(e){
      print(e);
    }
    return false;
    
  }
}
