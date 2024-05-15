import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores/controller/distance_controller.dart';
import 'package:stores/model/store.dart';
import 'package:stores/routes/routes.dart';

class Distance extends StatefulWidget {
  const Distance({super.key});

  @override
  State<Distance> createState() => _DistanceState();
}

class _DistanceState extends State<Distance> {
  DistanceController distanceController = Get.put(DistanceController());

  @override
  Widget build(BuildContext context) {
    final StoreModel store =
        ModalRoute.of(context)!.settings.arguments as StoreModel;

    double long = store.longitude;
    double lat = store.latitude;
    double distance = distanceController.calculateDistance(
        distanceController.currentPosition.latitude,
        distanceController.currentPosition.longitude,
        lat,
        long);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Distance",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.profileScreen);
              },
              icon: const Icon(Icons.person),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.storesScreen);
              },
              icon: const Icon(Icons.home),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.favouritesScreen);
              },
              icon: const Icon(Icons.favorite),
              color: Colors.white,
            ),
          ],
          backgroundColor: Colors.purple,
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Store Name: ${store.name}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Store Address: ${store.longitude + store.latitude}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Store Distance: $distance Km Away \n",
              style: const TextStyle(fontSize: 20),
            ),
          ]),
        ),
      ),
    );
  }
}
