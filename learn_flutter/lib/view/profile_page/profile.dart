import 'package:flutter/material.dart';
import 'package:learn_flutter/view/register_page/register.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Level? _level;
  Gender? _gender;

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
        body: SingleChildScrollView(
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
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_2_outlined),
                  labelText: "Name",
                ),
              ),
              SizedBox(height: 10),
              Row(children: [
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
              ]),
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
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
                ]),
              ),
              SizedBox(height: 10),
              ElevatedButton(onPressed: () {}, child: Text("update")),
            ]))));
  }
}
