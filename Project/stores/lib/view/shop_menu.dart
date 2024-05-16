import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stores/controller/shop_menu_controller.dart';
import 'package:stores/model/product.dart';

class ShopMenuPage extends StatefulWidget {
  const ShopMenuPage({super.key});

  @override
  State<ShopMenuPage> createState() => _ShopProductsPageState();
}

class _ShopProductsPageState extends State<ShopMenuPage> {
  ShopMenuController MenuPageController = Get.put(ShopMenuController());

  @override
  void initState() {
    MenuPageController.setProducts(BehaviorSubject<List<ProductModel>>());
    super.initState();
    MenuPageController.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shop Products",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: FutureBuilder<List<ProductModel>>(
          future: MenuPageController.products$.first,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              List<ProductModel> products = snapshot.data!;
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  ProductModel product = products[index];
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        child: ListTile(
                      title: Text(product.name),
                      subtitle: Text("\$${product.price.toString()}"),
                      onTap: () {},
                    )),
                  );
                },
              );
            } else {
              return Center(
                child: Text("No products found"),
              );
            }
          },
        ),
      ),
    );
  }
}
