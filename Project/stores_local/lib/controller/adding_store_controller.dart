import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:stores_local/sqlite.dart';

class AddStoreController extends GetxController {
  static AddStoreController get instance => Get.find();

  final name = TextEditingController();
  final address = TextEditingController();
  final storage = FlutterSecureStorage();
  SnackBar snackBar = const SnackBar(content: Text(""));

  Future<bool> addStore() async {
    try{
      String name = this.name.text;
      String address = this.address.text;
      SqliteDB db = SqliteDB();
      String? token = await storage.read(key: "access_token");

      if (token == null) {
        return false;
      }

      String insertQuery = "INSERT INTO Stores (name , location) VALUES ('$name' , '$address');";
      var res = await db.insertData(insertQuery);
      
      print(res);
      return true;
    }
    catch(e){
      print(e);
    }
    return false;
  }
}
