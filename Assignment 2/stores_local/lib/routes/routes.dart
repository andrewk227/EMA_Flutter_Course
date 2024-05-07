import 'package:flutter/material.dart';
import 'package:stores_local/model/store.dart';
import 'package:stores_local/view/add_store.dart';
import 'package:stores_local/view/distance.dart';
import 'package:stores_local/view/favourites.dart';
import 'package:stores_local/view/login.dart';
import 'package:stores_local/view/stores.dart';
import 'package:stores_local/view/signup.dart';

class AppRoutes {
  static const String addStoreScreen = '/add_store';
  static const String storesScreen = '/stores';
  static const String favouritesScreen = '/favourites';
  static const String loginScreen = '/login';
  static const String distanceScreen = '/distance';
  static const String signUpScreen = '/signup';

  static Map<String, WidgetBuilder> routes = {
    addStoreScreen: (context) => const AddStore(),
    storesScreen: (context) => const StoresPage(),
    favouritesScreen: (context) => const Favourites(),
    loginScreen: (context) => const LoginPage(),
    distanceScreen: (context) => const Distance(),
    signUpScreen: (context) => const SignUpPage(),
  };

  static void navigateToDistanceScreen(BuildContext context, StoreModel storeModel) {
    Navigator.pushNamed(context, distanceScreen, arguments: storeModel);
  }
}
