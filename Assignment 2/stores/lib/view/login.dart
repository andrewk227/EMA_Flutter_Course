import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores/controller/login_controller.dart';
import 'package:stores/view/stores.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController controller = Get.put(LoginController());
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.purple, title: const Text("Login Page")),
      body: Form(
        key: _key,
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
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Enter ID";
                  } 
                  return null;
                },
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
                validator: (value){
                  if(value == null || value.length < 8){
                    return "Enter Password";
                  }
                  return null;
                },
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () async {
            if(_key.currentState!.validate()){
              bool result = await controller.login();
              print(result);
              if (result) {
                // navigate to home
                Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StoresPage()),
                        );

              }
              else {
                // show error
              }
            }
          }, child: const Text("Enter"))
        ]),
      )),
    ));
  }
}
