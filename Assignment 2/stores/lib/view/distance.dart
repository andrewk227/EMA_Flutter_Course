import 'package:flutter/material.dart';

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
        backgroundColor: Colors.purple,
      ),
    ));
  }
}
