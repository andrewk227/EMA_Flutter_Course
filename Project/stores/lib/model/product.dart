import 'package:flutter/material.dart';

class ProductModel extends ChangeNotifier {
  int id = 0;
  String name = "Product X";
  double price = 0.0;

  ProductModel({
    this.id = 0,
    this.name = "Product X",
    this.price = 0.0,
  });
}
