import 'package:flutter/material.dart';

class ProductModel extends ChangeNotifier {
  int id = 0;
  String name = "Product X";
  String price = "None";

  ProductModel({
    this.id = 0,
    this.name = "Product X",
    this.price = "None",
  });

  // void toggleFavorite() {
  //   isFavorite = !isFavorite;
  //   notifyListeners();
  // }
}
