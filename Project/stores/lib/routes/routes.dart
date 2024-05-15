import 'package:flutter/material.dart';
import 'package:stores/model/store.dart';
import 'package:stores/view/add_store.dart';
import 'package:stores/view/distance.dart';
import 'package:stores/view/login.dart';
import 'package:stores/view/profile.dart';
import 'package:stores/view/search_result.dart';
import 'package:stores/view/search_screen.dart';
import 'package:stores/view/stores.dart';
import 'package:stores/view/signup.dart';

class AppRoutes {
  static const String addStoreScreen = '/add_store';
  static const String storesScreen = '/stores';
  static const String favouritesScreen = '/favourites';
  static const String loginScreen = '/login';
  static const String distanceScreen = '/distance';
  static const String signUpScreen = '/signup';
  static const String profileScreen = '/profile';
  static const String searchScreen = '/search_screen';
  static const String searchResultScreen = '/search_result';

  static Map<String, WidgetBuilder> routes = {
    addStoreScreen: (context) => const AddStore(),
    storesScreen: (context) => const StoresPage(),
    loginScreen: (context) => const LoginPage(),
    distanceScreen: (context) => const Distance(),
    signUpScreen: (context) => const SignUpPage(),
    profileScreen: (context) => const ProfilePage(),
    searchScreen: (context) => const SearchPage(),
    searchResultScreen: (context) => const SeacrhResultPage(),
  };
  // Helper method to navigate to the Distance screen with parameters
  static void navigateToDistanceScreen(
      BuildContext context, StoreModel storeModel) {
    Navigator.pushNamed(context, distanceScreen, arguments: storeModel);
  }
}
