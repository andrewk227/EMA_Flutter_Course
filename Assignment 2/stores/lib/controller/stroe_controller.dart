import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  static StoreController get instance => Get.find();

  final name = TextEditingController();
  final address = TextEditingController();
}
