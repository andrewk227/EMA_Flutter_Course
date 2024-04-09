import "package:flutter/material.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learn_flutter/sqlite.dart';
import 'package:learn_flutter/view/login_page/login_failure.dart';
import 'package:learn_flutter/view/login_page/login_success.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final String HOST = 'http://192.168.1.13:8000';
  final storage = FlutterSecureStorage();
  sqliteDB db = sqliteDB();
  
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This Field is Mandatory";
                        }
                        return null;
                      },
                      controller: _idController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_2_outlined),
                        labelText: "Student ID",
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      validator: (value) {
                        if (value == null || value.length < 8) {
                          return "Require atleast 8 Characters";
                        }
                        return null;
                      },
                      controller: _passwordController,
                      obscureText:true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password_outlined),
                        labelText: "Password",
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if(_formKey.currentState!.validate())
                        {
                          String id = _idController.text;
                          String password = _passwordController.text;
                          String query = "SELECT * FROM Students WHERE id = '$id' AND password = '$password';";
                          var response = await db.selectData(query);
                          print("Select excuted================================");
                          print(response);
                          print("Select excuted================================");
                          _formKey.currentState!.save();
                          if (response.length >= 1)
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginSuccessPage(userID: id,)),
                            );
                          }
                          else
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginFailurePage()),
                            );
                          }
                        }
                        }, child: const Text("Login")),
                ]))));
  }
}
