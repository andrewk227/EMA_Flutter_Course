import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores/controller/distance_controller.dart';
import 'package:stores/controller/favourite_controller.dart';
import 'package:stores/model/store.dart';
import 'package:stores/routes/routes.dart';
import 'package:stores/view/add_store.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  FavouriteController favouriteController = Get.put(FavouriteController());
  DistanceController distanceController = Get.put(DistanceController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favourites",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, const AddStore() as String);
            },
            icon: const Icon(Icons.add),
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
      body: FutureBuilder(
        future: favouriteController.fetchFavourites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.purple.shade50,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.store),
                          trailing: IconButton(
                            icon: const Icon(Icons.location_on),
                            onPressed: () {
                              distanceController.getCurrentPosition();
                              Navigator.pushNamed(
                                  context, AppRoutes.distanceScreen);
                              StoreModel store = StoreModel(
                                  name: snapshot.data![index][1],
                                  address: snapshot.data![index][2]);
                            },
                          ),
                          // IconButton(
                          //   icon: const Icon(Icons.favorite_border),
                          //   onPressed: () {},
                          // ),

                          title: Text(snapshot.data![index][1]),
                          subtitle: Text(snapshot.data![index][2]),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                });
          } else {
            return const Center(
              child: Text("No Data Found"),
            );
          }
        },
      ),
    ));
  }
}
