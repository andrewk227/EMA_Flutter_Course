import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:stores/controller/map_screen_controller.dart';
import 'package:stores/model/shops.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapScreenController mapScreenController = Get.put(MapScreenController());

  @override
  void initState() {
    generateMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(
              mapScreenController.distanceController.currentPosition.latitude,
              mapScreenController.distanceController.currentPosition.longitude),
          initialZoom: 12,
        ),
        children: [
          openStreetMapTileLayer,
          MarkerLayer(markers: mapScreenController.markers),
          PolylineLayer(
            polylines: [
              Polyline(
                points: mapScreenController.routePoints,
                color: Colors.green,
                strokeWidth: 4.0,
              )
            ],
          )
        ]);
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
        urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
      );

  void generateMarkers() {
    List<Marker> markers = [];
    List<ShopModel> shops =
        mapScreenController.shopProductsController.shopsValues;

    for (int i = 0; i < shops.length; i++) {
      markers.add(Marker(
        point: LatLng(shops[i].latitude, shops[i].longitude),
        child: GestureDetector(
          onTap: () async {
            mapScreenController.setRoutePoints([]);
            await mapScreenController.getRoute(
                shops[i].latitude, shops[i].longitude);

            mapScreenController.calcDistanceFromCurrent(
                shops[i].latitude, shops[i].longitude);

            // ignore: use_build_context_synchronously
            _showModalSheet(context);

            setState(() {});
          },
          child: const Icon(
            Icons.location_pin,
            size: 50,
            color: Colors.red,
          ),
        ),
      ));
    }

    // adding user position
    markers.add(Marker(
      point: LatLng(
          mapScreenController.distanceController.currentPosition.latitude,
          mapScreenController.distanceController.currentPosition.longitude),
      child: const Icon(
        Icons.person_pin,
        size: 50,
        color: Colors.blue,
      ),
    ));

    mapScreenController.setMarkers(markers);
  }

  void _showModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.follow_the_signs),
                  title: Text("Distance : ${mapScreenController.distance} KM")),
            ],
          ),
        );
      },
    );
  }
}
