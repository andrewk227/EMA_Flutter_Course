import "package:flutter/material.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Login Page",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
            child: Form(
                child: Column(children: [
          const Text(
            "Login",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
              decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person_2_outlined),
            labelText: "Student ID",
          )),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
              decoration: const InputDecoration(
            prefixIcon: Icon(Icons.password_outlined),
            labelText: "Password",
          )),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Login")),
        ]))));
  }
}
