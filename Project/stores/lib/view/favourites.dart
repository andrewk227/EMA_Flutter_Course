import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores/controller/distance_controller.dart';
import 'package:stores/controller/favourite_controller.dart';
import 'package:stores/controller/store_controller.dart';
import 'package:stores/routes/routes.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  FavouriteController favouriteController = Get.put(FavouriteController());
  DistanceController distanceController = Get.put(DistanceController());
  StoreController storeController = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favourites",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.storesScreen);
            },
            icon: const Icon(Icons.home),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profileScreen);
            },
            icon: const Icon(Icons.person),
            color: Colors.white,
          ),
        ],
        backgroundColor: Colors.purple,
      ),
    ));
  }
}
