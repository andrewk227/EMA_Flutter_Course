import 'package:flutter/material.dart';

class StoreModel extends ChangeNotifier {
  int id = 0;
  String name = "Store X";
  String address = "None";
  bool isFavorite = false;

  StoreModel(
      {this.id = 0,
      this.name = "Store X",
      this.address = "None",
      this.isFavorite = false});

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
