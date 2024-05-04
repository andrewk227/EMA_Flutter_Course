import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStoreController extends GetxController {
  static AddStoreController get instance => Get.find();

  final name = TextEditingController();
  final address = TextEditingController();
}
