import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stores_local/controller/distance_controller.dart';
import 'package:stores_local/controller/favourite_controller.dart';
import 'package:stores_local/model/store.dart';
import 'package:stores_local/routes/routes.dart';

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
              Navigator.pushNamed(context, AppRoutes.profileScreen);
            },
            icon: const Icon(Icons.person),
            color: Colors.white,
          ),
        ],
        backgroundColor: Colors.purple,
      ),
      body: Consumer<StoreModel>(builder: (context, storeModel, child) {
        return FutureBuilder(
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.location_on),
                                  onPressed: () async {
                                    StoreModel store = StoreModel(
                                        name: snapshot.data![index]['name'],
                                        address: snapshot.data![index]
                                            ['location']);
                                    await distanceController
                                        .getCurrentPosition();
                                    AppRoutes.navigateToDistanceScreen(
                                        context, store);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    favouriteController.deleteFavourite(
                                        snapshot.data![index]['id']);
                                    storeModel.toggleFavorite();
                                  },
                                ),
                              ],
                            ),
                            title: Text(snapshot.data![index]['name']),
                            subtitle: Text(snapshot.data![index]['location']),
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
        );
      }),
    ));
  }
}
