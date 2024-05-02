import "package:flutter/material.dart";
import 'package:learn_flutter/sqlite.dart';
import 'package:learn_flutter/view/login_page/login_design.dart';
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
            child: LoginDesign(
                formKey: _formKey,
                idController: _idController,
                passwordController: _passwordController,
                db: db)));
  }
}
