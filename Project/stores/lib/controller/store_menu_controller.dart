// import 'dart:convert';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:rxdart/rxdart.dart';
// import 'package:stores/global.dart';
// import 'package:stores/model/product.dart';

// class ShopMenuController extends GetxController {
//   static ShopMenuController get instance => Get.find();

//   final name = BehaviorSubject<String>();
//   final price = BehaviorSubject<String>();
//   final storage = FlutterSecureStorage();

// // getters to get the value of the variables
//   Stream<String> get name$ => name.stream;
//   Stream<String> get address$ => price.stream;

// // Setter to update the value of the variables
//   Function(String) get setName => name.sink.add;
//   Function(String) get setAddress => price.sink.add;

//   Future<List<ProductModel>> getProducts(String storeId) async {
//     // await FavouriteController.instance.fetchFavourites();

//     List<dynamic> data = [];
//     String? token = await storage.read(key: "access_token");
//     if (token == null) {
//       return [];
//     }

//     try {
//       final response = await http
//           .get(Uri.parse("$HOST/$storeId/product"), headers: <String, String>{
//         "access-token": token,
//         'Content-Type': 'application/json; charset=UTF-8',
//       });

//       if (response.statusCode == 200) {
//         data = jsonDecode(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }

//     List<ProductModel> products = [];

//     for (int i = 0; i < data.length; i++) {
//       ProductModel productInstance =
//           ProductModel(id: data[i][0], name: data[i][1], price: data[i][2]);
//       // if (FavouriteController.instance.isFavorite(productInstance.id)) {
//       //   productInstance.isFavorite = true;
//       // }
//       products.add(productInstance);
//     }

//     return products;
//   }

//   // Future<bool> toggleFavorite(int id) async {
//   //   String? token = await storage.read(key: "access_token");
//   //   if (token == null) {
//   //     return false;
//   //   }

//   //   try {
//   //     final response = await http.post(
//   //       Uri.parse("$HOST/store/favorite"),
//   //       headers: <String, String>{
//   //         "access-token": token,
//   //         'Content-Type': 'application/json; charset=UTF-8',
//   //       },
//   //       body: jsonEncode(<String, int>{'id': id}),
//   //     );
//   //     if (response.statusCode == 201) {
//   //       return true;
//   //     }
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   //   return false;
//   // }

//   @override
//   void dispose() {
//     name.close();
//     price.close();
//     super.dispose();
//   }
// }
