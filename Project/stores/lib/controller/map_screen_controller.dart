import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stores/controller/distance_controller.dart';
import 'package:stores/controller/shop_products_controller.dart';
import 'package:stores/model/shops.dart';
import 'package:http/http.dart' as http;

class MapScreenController extends GetxController {
  ShopProductsController shopProductsController = Get.put(
      ShopProductsController()); // has the shops from the shops_products

  DistanceController distanceController =
      Get.put(DistanceController()); // has the current position of the phone

  final BehaviorSubject<List<Marker>> _markers =
      BehaviorSubject<List<Marker>>(); // the markers on the map
  List<Marker> get markers => _markers.value;

  final BehaviorSubject<List<LatLng>> _routePoints =
      BehaviorSubject<List<LatLng>>.seeded([]); // the route points
  List<LatLng> get routePoints => _routePoints.value;

  final BehaviorSubject<double> _distance = BehaviorSubject<double>();
  double get distance => _distance.value;
  setDistance(double distance) {
    _distance.sink.add(distance);
  }

  setRoutePoints(List<LatLng> routePoints) {
    _routePoints.sink.add(routePoints);
  }

  setMarkers(List<Marker> markers) {
    _markers.value = markers;
  }

  void calcDistanceFromCurrent(double lat2, double lon2) {
    setDistance(distanceController.caculateDistanceFromCurrent(lat2, lon2));
  }

  Future<void> getRoute(double latitude, double longitude) async {
    double latitudeDevice = distanceController.currentPosition.latitude;
    double longitudeDevice = distanceController.currentPosition.longitude;

    final String url =
        'http://router.project-osrm.org/route/v1/driving/$longitude,$latitude;$longitudeDevice,$latitudeDevice?overview=full&geometries=geojson';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coordinates =
          data['routes'][0]['geometry']['coordinates'];

      setRoutePoints(
          coordinates.map((coord) => LatLng(coord[1], coord[0])).toList());
    } else {
      throw Exception('Failed to load route');
    }
  }

  // final LatLng point1 = LatLng(52.5200, 13.4050); // Berlin
  // final LatLng point2 = LatLng(48.8566, 2.3522);  // Paris

  // @override
  // void initState() {
  //   super.initState();
  //   _getRoute();
  // }

  // Future<void> _getRoute() async {
  //   final String url = 'http://router.project-osrm.org/route/v1/driving/${point1.longitude},${point1.latitude};${point2.longitude},${point2.latitude}?overview=full&geometries=geojson';

  //   final response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];

  //     setState(() {
  //       routePoints = coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
  //     });
  //   } else {
  //     throw Exception('Failed to load route');
  //   }
  // }
}
