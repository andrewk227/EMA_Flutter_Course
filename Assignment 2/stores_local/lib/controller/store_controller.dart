import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stores_local/controller/favourite_controller.dart';
import 'package:stores_local/model/store.dart';
import 'package:stores_local/sqlite.dart';
class StoreController extends GetxController {
  static StoreController get instance => Get.find();

  final name = TextEditingController();
  final address = TextEditingController();
  final storage = FlutterSecureStorage();
  SqliteDB db = SqliteDB();


  Future<List<StoreModel>> getStores() async {
    await FavouriteController.instance.fetchFavourites();

    String query = "SELECT * FROM Stores;";
    List<dynamic> data = await db.selectData(query);
    List<StoreModel> storesList = [];

    for (int i = 0; i < data.length; i++) {
      StoreModel storeInstance =
          StoreModel(id: data[i]['id'], name: data[i]['name'], address: data[i]['location']);

      if (FavouriteController.instance.isFavorite(storeInstance.id)) {
        storeInstance.isFavorite = true;
      }
      storesList.add(storeInstance);
    }
    
    return storesList;
  }

  Future<bool> toggleFavorite(int id) async {
    try{
      
      String? token = await storage.read(key: "access_token");
    
      if (token == null) {
        return false;
      }

      for (var i = 0; i < FavouriteController.instance.favourites.length; i++) {
        if (FavouriteController.instance.favourites[i]['id'] == id) {
          String deleteQuery = "DELETE FROM Favorite_Stores WHERE student_id = '$token' AND store_id = '$id';";
          var response = await db.deleteData(deleteQuery);

          FavouriteController.instance.favourites.removeAt(i);

          print(response);
          return false;
        }
      }

      String insertQuery = "INSERT INTO Favorite_Stores (student_id , store_id) VALUES ('$token' , '$id');";
      var response = await db.insertData(insertQuery);

      FavouriteController.instance.favourites.add({'student_id': token, 'store_id' : id});
      
      print(response);
      return true;
    }
    catch(e){
      print(e);
    }
    return false;
    
  }
}
