import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<bool> register() async {
    String HOST = "http://192.168.1.13:8000";
    String name = nameController.text;
    String email = emailController.text;
    String id = idController.text;
    String password = passwordController.text;
    String confirmationPassword = confirmationPasswordController.text;

    Map<String, dynamic> data = {
      "name": name,
      "email": email,
      "id": id,
      "password": password,
      "confirmation_password": confirmationPassword,
      "gender": gender?.index,
      "level": level?.index,
      "imageURL": null,
    };

    try {
      final response = await http.post(
        Uri.parse("$HOST/user/register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        // print(response.body);
        return true;
      }
    } catch (e) {
      // print(e);
      return false;
    }
    return false;
  }
}
