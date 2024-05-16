import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores/controller/shop_menu_controller.dart';
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
  ShopMenuController shopMenuController = Get.put(ShopMenuController());

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
        body: FutureBuilder(
            future: _storeController.getStores(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData) {
                List<ShopModel> shops = snapshot.data as List<ShopModel>;
                return ListView.builder(
                  itemCount: shops.length,
                  itemBuilder: (context, index) {
                    return Container(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            shopMenuController.setShopId(shops[index].id);
                            Navigator.pushNamed(
                                context, AppRoutes.storeMenuScreen);
                          },
                          child: Card(
                              child: ListTile(
                            title: Text(shops[index].name),
                            subtitle: Text(
                                'longitude: ${shops[index].longitude.toString()}, latitude: ${shops[index].latitude.toString()}'),
                          )),
                        ));
                  },
                );
              }
              return const Center(
                child: Text('No data'),
              );
            }),
      ),
    );
  }
}
