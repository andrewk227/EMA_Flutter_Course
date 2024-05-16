import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class DistanceController extends GetxController {
  static DistanceController get instance => Get.find();

  late Position currentPosition;

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('Location services are disabled. Please enable the services')));
      print('Location services are disabled. Please enable the services');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Location permissions are denied')));
        print('Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text(
      //         'Location permissions are permanently denied, we cannot request permissions.')));
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition = position;
      print(currentPosition);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  double roundTo(double number, int decimalPlaces) {
    double mod = double.parse(pow(10.0, decimalPlaces).toString());
    return ((number * mod).roundToDouble() / mod);
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return roundTo(
        Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000, 2);
  }

  double caculateDistanceFromCurrent(double lat2, double lon2) {
    return roundTo(
        Geolocator.distanceBetween(currentPosition.latitude,
                currentPosition.longitude, lat2, lon2) /
            1000,
        2);
  }
}
