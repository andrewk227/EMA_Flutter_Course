import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores/controller/store_controller.dart';
import 'package:stores/model/shops.dart';
import 'package:stores/routes/routes.dart';
import 'package:stores/view/add_store.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  StoreController _storeController = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "All Stores",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddStore()),
                );
              },
              icon: const Icon(Icons.add),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.profileScreen);
              },
              icon: const Icon(Icons.person),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.searchScreen);
              },
              icon: const Icon(Icons.search),
              color: Colors.white,
            ),
          ],
          backgroundColor: Colors.purple,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<String>(
                stream: _storeController.name$,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String name = snapshot.data!;
                    return Text(
                      "Store Name: $name",
                      style: const TextStyle(fontSize: 20),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              StreamBuilder<double>(
                stream: _storeController.longitude$,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    double longitude = snapshot.data!;
                    return Text(
                      "Store Address: $longitude",
                      style: const TextStyle(fontSize: 20),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              StreamBuilder<double>(
                stream: _storeController.latitude$,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    double latitude = snapshot.data!;
                    return Text(
                      "Store Address: $latitude",
                      style: const TextStyle(fontSize: 20),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  List<ShopModel> stores = await _storeController.getStores();
                  // Display fetched stores or perform any other action
                },
                child: const Text("Fetch Stores"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {},
                child: const Text("Toggle Favorite"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
