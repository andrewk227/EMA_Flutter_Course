import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stores/controller/shop_products_controller.dart';
import 'package:stores/model/product.dart';
import 'package:stores/model/shops.dart';
import 'package:stores/routes/routes.dart';

class ShopProductsPage extends StatefulWidget {
  const ShopProductsPage({
    super.key,
  });

  @override
  State<ShopProductsPage> createState() => _ShopProductsPageState();
}

class _ShopProductsPageState extends State<ShopProductsPage> {
  ShopProductsController shopProductsController =
      Get.put(ShopProductsController());

  @override
  void initState() {
    shopProductsController.setShops(BehaviorSubject<List<ShopModel>>());

    super.initState();
    shopProductsController.fetchShops();
  }

  // @override
  // void dispose() {
  //   searchOutputController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Shops Result",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.purple,
            ),
            body: FutureBuilder(
                future: shopProductsController.shops$.first,
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
                    List<ShopModel> products = snapshot.data as List<ShopModel>;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              child: ListTile(
                            title: Text(products[index].name),
                            subtitle: Text(
                                "${products[index].longitude},${products[index].latitude}"),
                          )),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text('No data'),
                  );
                })));
  }
}
