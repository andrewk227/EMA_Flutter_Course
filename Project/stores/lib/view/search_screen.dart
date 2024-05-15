import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores/controller/search_controller.dart';
import 'package:stores/routes/routes.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchPageController _searchController = Get.put(SearchPageController());
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
              Navigator.pushNamed(context, AppRoutes.addStoreScreen);
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
        ],
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Search Screen",
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            TextFormField(
              autofocus: true,
              autocorrect: true,
              decoration: const InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  )),
              onChanged: (value) => _searchController.setSearchResult(value),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.searchResultScreen);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: const StadiumBorder(),
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.purple),
              ),
              child: const Text(
                "Search",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: TextSelectionToolbar.kHandleSize),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
