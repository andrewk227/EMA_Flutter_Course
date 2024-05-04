import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteController extends GetxController {
  static FavouriteController get instance => Get.find();

  final name = TextEditingController();
  final address = TextEditingController();
}
