import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:stores/controller/map_screen_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapScreenController mapScreenController = Get.put(MapScreenController());

  @override
  void initState() {
    mapScreenController.generateMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(options: MapOptions(
      initialCenter: LatLng(mapScreenController.distanceController.currentPosition.latitude , mapScreenController.distanceController.currentPosition.longitude),
      initialZoom: 11,
    ), children: [
      openStreetMapTileLayer,
      MarkerLayer(markers: 
        mapScreenController.markers
      ),
    ]) ;
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);