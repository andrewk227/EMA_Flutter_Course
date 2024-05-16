import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:latlong2/latlong.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stores/controller/distance_controller.dart';
import 'package:stores/controller/shop_products_controller.dart';
import 'package:stores/model/shops.dart';

class MapScreenController extends GetxController {

  ShopProductsController shopProductsController = Get.put(ShopProductsController()); // has the shops from the shops_products 
  DistanceController distanceController = Get.put(DistanceController()); // has the current position of the phone

  final BehaviorSubject<List<Marker>> _markers = BehaviorSubject<List<Marker>>(); // the markers on the map

  List<Marker> get markers => _markers.value;

  setMarkers(List<Marker> markers) {
    _markers.value = markers;
  }

  void generateMarkers() {
    List<Marker> markers = [];
    List<ShopModel> shops = shopProductsController.shopsValues;

    for (int i = 0; i < shops.length ; i++) {
      markers.add(Marker(
        point: LatLng(shops[i].latitude, shops[i].longitude), child: const Icon(
          Icons.location_pin,
          size: 50,
          color: Colors.red,
        ),
      ));
    }

    // adding user position
    markers.add(Marker(
      point: LatLng(distanceController.currentPosition.latitude, distanceController.currentPosition.longitude), child: const Icon(
        Icons.person_pin,
        size: 50,
        color: Colors.blue,
      ),
    ));

    setMarkers(markers);
  }
}
