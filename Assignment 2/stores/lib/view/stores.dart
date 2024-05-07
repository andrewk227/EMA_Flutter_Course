import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stores/controller/favourite_controller.dart';
import 'package:stores/controller/store_controller.dart';
import 'package:stores/model/store.dart';
import 'package:stores/routes/routes.dart';
import 'package:stores/view/add_store.dart';
import 'package:stores/view/favourites.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  StoreController storeController = Get.put(StoreController());
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Favourites()));
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
      body: Consumer<StoreModel>(builder: (context, storeModel, child) {
        return FutureBuilder(
            future: storeController.getStores(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
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
                                icon: snapshot.data![index].isFavorite
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.purple,
                                      )
                                    : const Icon(Icons.favorite_border),
                                onPressed: () async {
                                  bool result = await storeController
                                      .toggleFavorite(snapshot.data![index].id);
                                  if (result) {
                                    snapshot.data![index].toggleFavorite();
                                    print("Added Successfully");
                                    storeModel.toggleFavorite();
                                  } else {
                                    print("Error while adding");
                                  }
                                },
                              ),
                              title: Text(snapshot.data![index].name),
                              subtitle: Text(snapshot.data![index].address),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    });
              } else {
                return const Center(child: Text("No Data"));
              }
            });
      }),
    ));
  }
}
