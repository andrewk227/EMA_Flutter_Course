import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DistanceController extends GetxController {
  static DistanceController get instance => Get.find();

  final name = TextEditingController();
  final address = TextEditingController();
}
