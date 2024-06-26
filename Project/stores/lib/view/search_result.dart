import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stores/controller/search_result_controller.dart';
import 'package:stores/controller/shop_products_controller.dart';
import 'package:stores/model/product.dart';
import 'package:stores/routes/routes.dart';

class SeacrhResultPage extends StatefulWidget {
  const SeacrhResultPage({super.key});

  @override
  State<SeacrhResultPage> createState() => _SeacrhResultPageState();
}

class _SeacrhResultPageState extends State<SeacrhResultPage> {
  SearchResultController searchResultController =
      Get.put(SearchResultController());
  ShopProductsController shopProductsController =
      Get.put(ShopProductsController());

  @override
  void initState() {
    searchResultController.setSearchResult$ =
        BehaviorSubject<List<ProductModel>>();

    super.initState();
    searchResultController.fetchSearchOutput();
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
              title: const Text("Search Result",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.purple,
            ),
            body: FutureBuilder(
                future: searchResultController.searchResult$.first,
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
                    List<ProductModel> products =
                        snapshot.data as List<ProductModel>;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Container(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                print("hi hi {{${products[index].id}}}");
                                shopProductsController
                                    .setProductId(products[index].id);
                                Navigator.pushNamed(
                                    context, AppRoutes.shopProductScreen);
                              },
                              child: Card(
                                  child: ListTile(
                                title: Text(products[index].name),
                                subtitle:
                                    Text(products[index].price.toString()),
                              )),
                            ));
                      },
                    );
                  }
                  return const Center(
                    child: Text('No data'),
                  );
                })));
  }
}
