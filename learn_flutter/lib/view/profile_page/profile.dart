import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:learn_flutter/view/register_page/register.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmationPassword = TextEditingController();
  late Future _future;

  Level? _level;
  Gender? _gender;
  final String HOST = 'http://192.168.1.13:8000';
  final storage = FlutterSecureStorage();

  Future<Map<String,dynamic>> fetchData() async {
    // API endpoint to fetch data
    final String apiUrl = '$HOST/user';
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      throw Exception('Access token is null or not found');
    }

    final response = await http.get(Uri.parse(apiUrl) , headers: {'Content-Type': 'application/json' , 'access-token':token});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future<Map<String,dynamic>> updateData() async {
    // API endpoint to fetch data
    final String apiUrl = '$HOST/user/update';
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      throw Exception('Access token is null or not found');
    }
    
    Map<String, dynamic> data = {
      'name': _name.text,
      'email': _email.text,
      'gender': _gender?.index,
      'level': _level?.index,
      'password': _password.text,
      'confirmation_password': _confirmationPassword.text
    };

    final response = await http.put(Uri.parse(apiUrl) , headers: {'Content-Type': 'application/json' , 'access-token':token} , body: jsonEncode(data));

    if (response.statusCode == 200) {
      print("SUCCESS");
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

 @override
  void initState() {
    // assign this variable your Future
    _future = fetchData();
    super.initState();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profile Page",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body:FutureBuilder(
          future: _future,
          builder: (context ,snapshot) {

            print(snapshot.data);
             if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {

              if (_name.text.isEmpty) {
                _name.text = snapshot.data?['name'];
              }
              if (_email.text.isEmpty) {
                _email.text = snapshot.data?['email'];
              }
              if (_password.text.isEmpty) {
                _password.text = snapshot.data?['password'];
              }
              if (_confirmationPassword.text.isEmpty) {
                _confirmationPassword.text = _password.text;
              }
              if (_level == null) {
                if (snapshot.data?['level'] != null) {
                  _level = Level.values[snapshot.data?['level']];
                }
              }
              if (_gender == null) {
                if (snapshot.data?['gender'] != null) {
                  _gender = Gender.values[snapshot.data?['gender']];
                }
              }

            return SingleChildScrollView(
                child: Form(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                  Stack(
                    children: [
                      SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            // child: const Image(
                            //     image: AssetImage('assets/images/profile.png'))),
                          )),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_2_outlined),
                      labelText: "Name",
                    ),
                  ),
                  SizedBox(height: 10),
                  RadioListTile(
                        title: const Text("Male"),
                        value: Gender.Male,
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        }),
                    RadioListTile(
                        title: const Text("Female"),
                        value: Gender.Female,
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        }),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "email",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _password,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "Password",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmationPassword,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "Confirm Password",
                    ),
                  ),
                  SizedBox(height: 10),
                  RadioListTile(
                          title: const Text("First Level"),
                          value: Level.First,
                          groupValue: _level,
                          onChanged: (value) {
                            setState(() {
                              _level = value;
                            });
                          }),
                      RadioListTile(
                          title: const Text("Second Level"),
                          value: Level.Second,
                          groupValue: _level,
                          onChanged: (value) {
                            setState(() {
                              _level = value;
                            });
                          }),
                      RadioListTile(
                          title: const Text("Third Level"),
                          value: Level.Third,
                          groupValue: _level,
                          onChanged: (value) {
                            setState(() {
                              _level = value;
                            });
                          }),
                      RadioListTile(
                          title: const Text("Fourth Level"),
                          value: Level.Fourth,
                          groupValue: _level,
                          onChanged: (value) {
                            setState(() {
                              _level = value;
                            });
                          }),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: () {
                    updateData();
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => ProfilePage(),
            ));
                  }, child: Text("update")),
                ])));
          }
  }));
  }
}
