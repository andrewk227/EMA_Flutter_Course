import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores/routes/routes.dart';

import '../controller/adding_shop_controller.dart';

class AddShop extends StatefulWidget {
  const AddShop({super.key});

  @override
  State<AddShop> createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  AddShopController controller = Get.put(AddShopController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          "Adding Store",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.shopsScreen);
            },
            icon: const Icon(Icons.home),
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
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profileScreen);
            },
            icon: const Icon(Icons.person),
            color: Colors.white,
          ),
        ],
        backgroundColor: Colors.purple,
      ),
      body: Form(
          child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const Text(
            "Add Store",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          TextFormField(
              controller: controller.name,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Store Name",
                prefixIcon: Icon(Icons.store),
              )),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
              controller: controller.address,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Store Address",
                prefixIcon: Icon(Icons.location_pin),
              )),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
              onPressed: () async {
                bool flag = await controller.addShop();
                if (flag) {
                  controller.snackBar = const SnackBar(
                    content: Text("Store Added Successfully"),
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(controller.snackBar);
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.shopsScreen);
                } else {
                  controller.snackBar = const SnackBar(
                    content: Text("Store Can't Added"),
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(controller.snackBar);
                }
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
              label: const Text(
                "ADD STORE",
                style: TextStyle(color: Colors.black),
              ))
        ]),
      )),
    ));
  }
}
