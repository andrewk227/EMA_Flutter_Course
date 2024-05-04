import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores/controller/store_controller.dart';
import 'package:stores/routes/routes.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  StoreController controller = Get.put(StoreController());

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
              Navigator.pushNamed(context, AppRoutes.addStoreScreen);
            },
            icon: const Icon(Icons.add),
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
      body: FutureBuilder(
          future: controller.getStores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              // print(snapshot.data);
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
                              icon: const Icon(Icons.favorite_border),
                              onPressed: () async {
                                bool result = await controller
                                    .addFavorite(snapshot.data![index][0]);
                                if (result) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Added to Favourites"),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Error while adding"),
                                  ));
                                }
                              },
                            ),
                            title: Text(snapshot.data![index][1]),
                            subtitle: Text(snapshot.data![index][2]),
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
