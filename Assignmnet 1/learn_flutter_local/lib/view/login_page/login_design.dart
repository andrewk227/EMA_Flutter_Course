import "package:flutter/material.dart";
import 'package:learn_flutter/sqlite.dart';
import 'package:learn_flutter/view/login_page/login_failure.dart';
import 'package:learn_flutter/view/login_page/login_success.dart';
import 'package:learn_flutter/view/register_page/register.dart';

class LoginDesign extends StatelessWidget {
  const LoginDesign({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController idController,
    required TextEditingController passwordController,
    required this.db,
  })  : _formKey = formKey,
        _idController = idController,
        _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _idController;
  final TextEditingController _passwordController;
  final sqliteDB db;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.password_outlined),
                labelText: "Password",
              )),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String id = _idController.text;
                      String password = _passwordController.text;
                      String query =
                          "SELECT * FROM Students WHERE id = '$id' AND password = '$password';";
                      var response = await db.selectData(query);
                      print("Select excuted================================");
                      print(response);
                      print("Select excuted================================");
                      _formKey.currentState!.save();
                      if (response.length >= 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginSuccessPage(
                                    userID: id,
                                  )),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginFailurePage()),
                        );
                      }
                    }
                  },
                  child: const Text("Login")),
              SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: const Text("Register"))
            ],
          ),
        ]));
  }
}
