import 'package:flutter/material.dart';

class HeartIconModel extends ChangeNotifier {
  IconData icon = Icons.favorite_border;

  IconData get currentIcon => icon;

  void changeIcon() {
    icon =
        icon == Icons.favorite_border ? Icons.favorite : Icons.favorite_border;
    notifyListeners();
  }
}
