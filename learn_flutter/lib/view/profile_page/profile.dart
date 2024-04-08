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

    Map<String , dynamic>sentToken = {'access_token':token};

    final response = await http.post(Uri.parse(apiUrl) , headers: {'Content-Type': 'application/json'}, body: jsonEncode(sentToken));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
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
        body: FutureBuilder(
          future: fetchData(),
          builder: (context ,snapshot) {
            print(snapshot.data);
            _name.text = snapshot.data?['name'];

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
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "email",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "Password",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
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
                  ElevatedButton(onPressed: () {}, child: Text("update")),
                ])));
          }
        ));
  }
}
