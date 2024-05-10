import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stores_local/sqlite.dart';

enum Gender { Male, Female }

enum Level { First, Second, Third, Fourth }

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
  final _formKey = GlobalKey<FormState>();
  Level? _level;
  Gender? _gender;

  final storage = FlutterSecureStorage();
  SqliteDB db = SqliteDB();
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _imageFile = imageFile;
        // print(_imageFile?.path);
      });
    }
  }

  Future<Map<String, dynamic>> fetchData() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      print('Access token is null or not found');
      return {};
    }

    String selectQuery = "SELECT * FROM Students WHERE id = $token";
    var response = await db.selectData(selectQuery);

    response = response[0];
    return response;
  }

  Future<bool> updateData() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      print('Access token is null or not found');
      return false;
    }

    Map<String, dynamic> data = {
      'name': _name.text,
      'email': _email.text,
      'gender': _gender?.index,
      'level': _level?.index,
      'password': _password.text,
      'confirmation_password': _confirmationPassword.text,
      'imageURL': _imageFile?.path
    };

    String selectQuery =
    "SELECT * FROM Students WHERE email = '${data['email']}' AND id NOT IN ($token);";

    var emails = await db.selectData(selectQuery);
    if (emails.length > 0) {
      print("Update Failed");
      return false;
    } 
    _formKey.currentState!.save();
    String updateQuery = 
    '''
    UPDATE Students SET
    name = '${data['name']}',
    email = '${data['email']}',
    gender = ${data['gender']},
    level = ${data['level']},
    password = '${data['password']}',
    imageURL = '${data['imageURL']}'
    WHERE id = $token 
    ''';
    var res = await db.updateData(updateQuery);

    print("Update Result: $res");
    return true;
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
          backgroundColor: Colors.purple,
        ),
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
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

                _imageFile ??= snapshot.data?['imageURL'] != null
                    ? File(snapshot.data?['imageURL'])
                    : null;

                return SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                    radius: 60,
                                    backgroundImage: _imageFile != null
                                        ? FileImage(_imageFile!)
                                        : const AssetImage(
                                            'assets/default.png',
                                          ) as ImageProvider<Object>?),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          _pickImage(ImageSource.camera);
                                        },
                                        child: const Text("Camera")),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          _pickImage(ImageSource.gallery);
                                        },
                                        child: const Text("Gallery")),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This Field is mandatory";
                                    }
                                    return null;
                                  },
                                  controller: _name,
                                  decoration: InputDecoration(
                                      prefixIcon:
                                          const Icon(Icons.person_2_outlined),
                                      labelText: "Name",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                const SizedBox(height: 10),
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This Field is mandatory";
                                    }
                                    RegExp exp =
                                        RegExp(r'(\d{8}@stud.fci-cu.edu.eg)');
                                    if (exp.hasMatch(value)) {
                                      return null;
                                    }
                                    return "Invalid Email";
                                  },
                                  controller: _email,
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.email),
                                      labelText: "email",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.length < 8) {
                                      return "Require atleast 8 Characters";
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  controller: _password,
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.lock),
                                      labelText: "Password",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.length < 8) {
                                      return "Require atleast 8 Characters";
                                    }
                                    if (value != _password.text) {
                                      return "Confirmation password doesn't match the password";
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  controller: _confirmationPassword,
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.lock),
                                      labelText: "Confirm Password",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                const SizedBox(height: 10),
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
                                const SizedBox(height: 10),
                                ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        updateData();
                                        setState(() {});
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text("Updated Successfully"),
                                        ));
                                      }
                                    },
                                    child: const Text("update")),
                              ]),
                        )));
              }
            }));
  }
}
