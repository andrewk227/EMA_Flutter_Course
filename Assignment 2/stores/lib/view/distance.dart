import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stores/routes/routes.dart';

class Distance extends StatefulWidget {
  const Distance({super.key});

  @override
  State<Distance> createState() => _DistanceState();
}

class _DistanceState extends State<Distance> {
  @override
  Widget build(BuildContext context) {
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.person),
                  color: Colors.white,
                ),
              ],
              backgroundColor: Colors.purple,
            ),
            body: SingleChildScrollView(
                child: Column(children: [
              Text("Store Name: "),
            ]))));
  }
}
