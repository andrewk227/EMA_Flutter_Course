import 'package:flutter/material.dart';
import 'package:stores/model/shops.dart';
import 'package:stores/view/add_shop.dart';
import 'package:stores/view/login.dart';
import 'package:stores/view/profile.dart';
import 'package:stores/view/search_result.dart';
import 'package:stores/view/search_screen.dart';
import 'package:stores/view/shops_products.dart';
import 'package:stores/view/shop_menu.dart';
import 'package:stores/view/shops.dart';
import 'package:stores/view/signup.dart';

class AppRoutes {
  static const String addShopScreen = '/add_shop';
  static const String shopsScreen = '/shops';
  static const String favouritesScreen = '/favourites';
  static const String loginScreen = '/login';
  static const String distanceScreen = '/distance';
  static const String signUpScreen = '/signup';
  static const String profileScreen = '/profile';
  static const String searchScreen = '/search_screen';
  static const String searchResultScreen = '/search_result';
  static const String shopProductScreen = '/shops_products';
  static const String shopMenuScreen = '/shop_menu';

  static Map<String, WidgetBuilder> routes = {
    addShopScreen: (context) => const AddShop(),
    shopsScreen: (context) => const ShopsPage(),
    loginScreen: (context) => const LoginPage(),
    signUpScreen: (context) => const SignUpPage(),
    profileScreen: (context) => const ProfilePage(),
    searchScreen: (context) => const SearchPage(),
    searchResultScreen: (context) => const SeacrhResultPage(),
    shopProductScreen: (context) => const ShopProductsPage(),
    shopMenuScreen: (context) => const ShopMenuPage(),
  };
}
