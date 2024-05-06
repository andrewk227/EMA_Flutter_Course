import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores/controller/distance_controller.dart';
import 'package:stores/model/store.dart';

class Distance extends StatefulWidget {
  final StoreModel store;
  const Distance({super.key, required this.store});

  @override
  State<Distance> createState() => _DistanceState();
}

class _DistanceState extends State<Distance> {
  DistanceController distanceController = Get.put(DistanceController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          "Distance",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Column(children: [
        Text("Store Name: \n${widget.store.name}"),
        const SizedBox(
          height: 10,
        ),
        Text("Store Address: \n${widget.store.address}"),
        const SizedBox(
          height: 10,
        ),
        Text("Store Distnace: \n"),
      ]),
    ));
  }
}
