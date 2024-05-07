import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stores_local/sqlite.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final id = TextEditingController();
  final password = TextEditingController();
  final storage = FlutterSecureStorage();
  SqliteDB db = SqliteDB();

  Future<bool> login() async {
    String id = this.id.text;
    String password = this.password.text;
    
    try {
      String selectQuery = "SELECT * FROM Students WHERE id = '$id' AND password = '$password';";

      var response = await db.selectData(selectQuery);

      if (response.length >= 1) {
        await storage.write(key: 'access_token', value: id);

        print(response);
        return true;
      }
    } 
    catch (e) {
      print(e);
    }
    return false;
  }
}
