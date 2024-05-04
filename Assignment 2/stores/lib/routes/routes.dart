import 'package:flutter/material.dart';
import 'package:stores/view/add_store.dart';
import 'package:stores/view/distance.dart';
import 'package:stores/view/favourites.dart';
import 'package:stores/view/login.dart';
import 'package:stores/view/stores.dart';

class AppRoutes {
  static const String addStoreScreen = '/add_store';
  static const String storesScreen = '/stores';
  static const String favouritesScreen = '/favourites';
  static const String loginScreen = '/login';
  static const String distance = '/distance';

  static Map<String, WidgetBuilder> routes = {
    addStoreScreen: (context) => const AddStore(),
    storesScreen: (context) => const Stores(),
    favouritesScreen: (context) => const Favourites(),
    loginScreen: (context) => const LoginPage(),
    distance: (context) => const Distance(),
  };
}
