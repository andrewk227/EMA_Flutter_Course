import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores_local/controller/distance_controller.dart';
import 'package:stores_local/model/store.dart';

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
    double long = distanceController.getlongitude(store.address);
    double lat = distanceController.getLatitude(store.address);
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
          backgroundColor: Colors.purple,
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Store Name: ${store.name}"),
            const SizedBox(
              height: 10,
            ),
            Text("Store Address: ${store.address}"),
            const SizedBox(
              height: 10,
            ),
            Text("Store Distance: $distance Km Away \n"),
          ]),
        ),
      ),
    );
  }
}
