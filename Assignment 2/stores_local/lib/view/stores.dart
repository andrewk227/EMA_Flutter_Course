import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores_local/controller/favourite_controller.dart';
import 'package:stores_local/controller/store_controller.dart';
import 'package:stores_local/view/add_store.dart';
import 'package:stores_local/view/favourites.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  StoreController controller = Get.put(StoreController());
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
            onPressed: () {},
            icon: const Icon(Icons.person),
            color: Colors.white,
          ),
        ],
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder(
          future: controller.getStores(),
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
                              icon: favouriteController.isFavorite(snapshot.data![index]['id']) ? const Icon(Icons.favorite, color: Colors.purple,) : const Icon(Icons.favorite_border),
                              onPressed: () async {
                                bool result = await controller
                                    .toggleFavorite(snapshot.data![index]['id']);
                                if (result) {
                                  print("Added Successfully");
                                } else {
                                  print("Error while adding");
                                }
                                setState(() {});
                              },
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
              return const Center(child: Text("No Data"));
            }
          }),
    ));
  }
}
