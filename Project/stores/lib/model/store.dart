import 'package:flutter/material.dart';

class StoreModel extends ChangeNotifier {
  int id = 0;
  String name = "Store X";
  double longitude = 0.0;
  double latitude = 0.0;
  bool isFavorite = false;

  StoreModel(
      {this.id = 0,
      this.name = "Store X",
      this.isFavorite = false,
      this.longitude = 0.0,
      this.latitude = 0.0});

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
