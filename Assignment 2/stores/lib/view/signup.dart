import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stores/controller/signup_controller.dart';
import 'package:stores/view/stores.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign Up Page",
        ),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                    child: Text(
                  "Become a Member",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_2_outlined),
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This Field is mandatory";
                    }
                    return null;
                  },
                ),
                const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Gender:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                RadioListTile(
                    title: const Text("Male"),
                    value: Gender.Male,
                    groupValue: controller.gender,
                    onChanged: (value) {
                      setState(() {
                        controller.gender = value;
                      });
                    }),
                RadioListTile(
                    title: const Text("Female"),
                    value: Gender.Female,
                    groupValue: controller.gender,
                    onChanged: (value) {
                      setState(() {
                        controller.gender = value;
                      });
                    }),
                TextFormField(
                  controller: controller.emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This Field is mandatory";
                    }
                    RegExp exp = RegExp(r'(\d{8}@stud.fci-cu.edu.eg)');
                    if (exp.hasMatch(value)) {
                      return null;
                    }
                    return "Invalid Email";
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Email",
                  ),
                ),
                TextFormField(
                  controller: controller.idController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This Field is Mandatory";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.card_membership),
                    contentPadding: EdgeInsets.all(10),
                    hintText: "ID",
                  ),
                  keyboardType: TextInputType.number,
                ),
                const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Level:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                RadioListTile(
                    title: const Text("First Level"),
                    value: Level.First,
                    groupValue: controller.level,
                    onChanged: (value) {
                      setState(() {
                        controller.level = value;
                      });
                    }),
                RadioListTile(
                    title: const Text("Second Level"),
                    value: Level.Second,
                    groupValue: controller.level,
                    onChanged: (value) {
                      setState(() {
                        controller.level = value;
                      });
                    }),
                RadioListTile(
                    title: const Text("Third Level"),
                    value: Level.Third,
                    groupValue: controller.level,
                    onChanged: (value) {
                      setState(() {
                        controller.level = value;
                      });
                    }),
                RadioListTile(
                    title: const Text("Fourth Level"),
                    value: Level.Fourth,
                    groupValue: controller.level,
                    onChanged: (value) {
                      setState(() {
                        controller.level = value;
                      });
                    }),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return "Require atleast 8 Characters";
                    }
                    return null;
                  },
                  controller: controller.passwordController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Password",
                  ),
                ),
                TextFormField(
                  controller: controller.confirmationPasswordController,
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return "Require atleast 8 Characters";
                    }
                    if (value != controller.passwordController.text) {
                      return "Confirmation password doesn't match the password";
                    }
                    return null;
                  },
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_clock_outlined),
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Confirm Password",
                  ),
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String id = controller.idController.text;
                          String email = controller.emailController.text;
                          String selectID =
                              "SELECT * FROM Students WHERE id = '$id';";
                          String selectEmail =
                              "SELECT * FROM Students WHERE email = '$email';";

                          var ids = await db.selectData(selectID);
                          var emails = await db.selectData(selectEmail);

                          if (ids.length > 0 || emails.length > 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const StoresPage()),
                            );
                          } else {
                            String name = controller.nameController.text;
                            String password =
                                controller.passwordController.text;
                            int? gender = controller.gender?.index;
                            int? level = controller.level?.index;

                            String insertQuery =
                                "INSERT INTO Students VALUES ('$id' , '$name' , '$email' ,'$password', '$gender' , '$level' , 'null');";
                            print(
                                "=================================================");
                            print(insertQuery);
                            print(
                                "=================================================");
                            var res = await db.insertData(insertQuery);
                            print("INSERTED DATA");
                            print(
                                "=================================================");
                            print(res);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("please try again")));
                          }
                        }
                      },
                      child: const Text("Register")),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
