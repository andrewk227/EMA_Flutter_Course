import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores_local/sqlite.dart';

enum Gender { Male, Female }

enum Level { First, Second, Third, Fourth }

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  Gender? gender;
  Level? level;
  final ScrollController scrollController = ScrollController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final idController = TextEditingController();
  final confirmationPasswordController = TextEditingController();
  SqliteDB db = SqliteDB();

  Future<bool> register() async {
    String name = nameController.text;
    String email = emailController.text;
    String id = idController.text;
    String password = passwordController.text;

    try {
      String selectID = "SELECT * FROM Students WHERE id = '$id';";
      String selectEmail = "SELECT * FROM Students WHERE email = '$email';";

      var ids = await db.selectData(selectID);
      var emails = await db.selectData(selectEmail);

      if (ids.length == 0 && emails.length == 0) {
        String insertQuery = "INSERT INTO Students VALUES ('$id' , '$name' , '$email' ,'$password', '$gender' , '$level' , 'null');";
        var res = await db.insertData(insertQuery);
        print(res);
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
