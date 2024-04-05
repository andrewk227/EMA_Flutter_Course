import "package:flutter/material.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learn_flutter/view/profile_page/profile.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _password = TextEditingController() ;

  Future<void> postData() async {
  Map<String, dynamic> data = {
    'id': _id.text,
    'password': _password.text,
  };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.13:8000/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Posted successfully');
      } else {
        print('Failed to post data: ${response.statusCode}');
        print('${response.body}');
      }
    } catch (e) {
      print('Error posting data: $e');
    }
}

  
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
                key: _formKey,
                child: Column(children: [
          const Text(
            "Login",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _id,
            decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person_2_outlined),
            labelText: "Student ID",
          )),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _password,
              decoration: const InputDecoration(
            prefixIcon: Icon(Icons.password_outlined),
            labelText: "Password",
          )),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed:postData,
              child: const Text("Login")),
        ]))));
  }
}
