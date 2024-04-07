import 'package:flutter/material.dart';
import 'package:learn_flutter/view/login_page/login.dart';
import 'package:learn_flutter/view/profile_page/profile.dart';
import 'package:learn_flutter/view/register_page/register.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Assignment 1',
    theme: ThemeData(
      primaryColor: Colors.blue,
      brightness: Brightness.light,
    ),
    home: const ProfilePage(),
  ));
}
