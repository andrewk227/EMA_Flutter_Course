import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  // final storage = FlutterSecureStorage();
  // sqliteDB db = sqliteDB();
}
