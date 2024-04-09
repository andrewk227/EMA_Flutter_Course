import "package:flutter/material.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learn_flutter/view/login_page/login_failure.dart';
import 'package:learn_flutter/view/login_page/login_success.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  
  Future<void> postLoginData() async {
    Map<String, dynamic> data = {
      'id': _idController.text,
      'password': _passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('$HOST/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Logged in Successfully');
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        await storage.write(key: 'access_token', value: responseJson['access_token']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginSuccessPage()),
        );
      } else {
        print('Failed to post data: ${response.statusCode}');
        print('${response.body}');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginFailurePage()),
        );
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
                      onPressed: (){
                        if(_formKey.currentState!.validate())
                        {
                          _formKey.currentState!.save();
                          postLoginData();
                        }
                        }, child: const Text("Login")),
                ]))));
  }
}
