import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:stores_local/model/store.dart';
import 'package:stores_local/routes/routes.dart';

void main() {
  FlutterSecureStorage.setMockInitialValues({"access_token": ""});
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StoreModel(),
      child: MaterialApp(
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.loginScreen,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
