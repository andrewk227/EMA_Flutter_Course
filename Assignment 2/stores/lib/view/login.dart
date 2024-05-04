import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores/controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.purple, title: const Text("Login Page")),
      body: Form(
          child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const Text(
            "Login",
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: controller.id,
            decoration: InputDecoration(
                hintText: "ID",
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: controller.password,
            decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: const IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: null,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () {}, child: const Text("Enter"))
        ]),
      )),
    ));
  }
}
