import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores/controller/favourite_controller.dart';
import 'package:stores/controller/store_controller.dart';
import 'package:stores/routes/routes.dart';
import 'package:stores/view/add_store.dart';
import 'package:stores/view/favourites.dart';

import '../model/store.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  StoreController _storeController = Get.put(StoreController());
  FavouriteController favouriteController = Get.put(FavouriteController());

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Favourites()));
              },
              icon: const Icon(Icons.favorite),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.profileScreen);
              },
              icon: const Icon(Icons.person),
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
                      style: TextStyle(fontSize: 20),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              StreamBuilder<String>(
                stream: _storeController.address$,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String address = snapshot.data!;
                    return Text(
                      "Store Address: $address",
                      style: TextStyle(fontSize: 20),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  List<StoreModel> stores = await _storeController.getStores();
                  // Display fetched stores or perform any other action
                },
                child: Text("Fetch Stores"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool toggled = await _storeController
                      .toggleFavorite(1); // Provide a valid store ID
                  if (toggled) {
                    // Handle success
                  } else {
                    // Handle failure
                  }
                },
                child: Text("Toggle Favorite"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
