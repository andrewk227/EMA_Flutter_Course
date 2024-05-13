// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stores/controller/favourite_controller.dart';
// import 'package:stores/controller/store_controller.dart';
// import 'package:stores/routes/routes.dart';
// import 'package:stores/view/add_store.dart';
// import 'package:stores/view/favourites.dart';

// import '../controller/store_menu_controller.dart';

// class StoresMenuPage extends StatefulWidget {
//   const StoresMenuPage({Key? key}) : super(key: key);

//   @override
//   _StoresMenuPageState createState() => _StoresMenuPageState();
// }

// class _StoresMenuPageState extends State<StoresMenuPage> {
//   final StoreMenuController _storeMenuController = Get.put(StoreMenuController());
//   // FavouriteController favouriteController = Get.put(FavouriteController());

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "All Products",
//           style: TextStyle(color: Colors.white),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const AddStore()),
//               );
//             },
//             icon: const Icon(Icons.add),
//             color: Colors.white,
//           ),
//           IconButton(
//             onPressed: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => const Favourites()));
//             },
//             icon: const Icon(Icons.favorite),
//             color: Colors.white,
//           ),
//           IconButton(
//             onPressed: () {
//               Navigator.pushNamed(context, AppRoutes.profileScreen);
//             },
//             icon: const Icon(Icons.person),
//             color: Colors.white,
//           ),
//         ],
//         backgroundColor: Colors.purple,
//       ),
//     ));
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores/controller/store_menu_controller.dart';
import 'package:stores/model/product.dart';

class StoreMenuPage extends StatelessWidget {
  final String storeId;

  StoreMenuPage({required this.storeId});

  @override
  Widget build(BuildContext context) {
    final StoreMenuController storeMenuController =
        Get.put(StoreMenuController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Store Products",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: FutureBuilder<List<ProductModel>>(
          future: storeMenuController.getProducts(storeId),
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
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text("\$${product.price.toString()}"),
                    // leading: CircleAvatar(
                    //   backgroundImage: NetworkImage(product.imageUrl),
                    // ),
                    // Add onTap functionality here (navigate to product details, etc.)
                    onTap: () {
                      // Example: Navigate to product details screen
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ProductDetailsPage(productId: product.id),
                      //   ),
                      // );
                    },
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
