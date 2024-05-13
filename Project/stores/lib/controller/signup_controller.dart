import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:stores/global.dart';

enum Gender { Male, Female }

enum Level { First, Second, Third, Fourth }

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  Gender? gender;
  Level? level;
  final ScrollController scrollController = ScrollController();
  final passwordController = BehaviorSubject<String>();
  final nameController = BehaviorSubject<String>();
  final emailController = BehaviorSubject<String>();
  final idController = BehaviorSubject<String>();
  final confirmationPasswordController = BehaviorSubject<String>();

// Getters
  Stream<String> get password$ => passwordController.stream;
  Stream<String> get name$ => nameController.stream;
  Stream<String> get email$ => emailController.stream;
  Stream<String> get id$ => idController.stream;
  Stream<String> get confirmationPassword$ =>
      confirmationPasswordController.stream;
  Stream<Gender?> get gender$ =>
      gender == null ? const Stream.empty() : Stream.value(gender);
  Stream<Level?> get level$ =>
      level == null ? const Stream.empty() : Stream.value(level);

// Setters
  Function(String) get setPassword => passwordController.sink.add;
  Function(String) get setName => nameController.sink.add;
  Function(String) get setEmail => emailController.sink.add;
  Function(String) get setId => idController.sink.add;
  Function(String) get setConfirmationPassword =>
      confirmationPasswordController.sink.add;
  Gender? get setGender => gender = gender;
  Level? get setLevel => level = level;

  Future<bool> register() async {
    String name = nameController.value;
    String email = emailController.value;
    String id = idController.value;
    String password = passwordController.value;
    String confirmationPassword = confirmationPasswordController.value;

    Map<String, dynamic> data = {
      "name": name,
      "email": email,
      "id": id,
      "password": password,
      "confirmation_password": confirmationPassword,
      "gender": gender?.index,
      "level": level?.index,
      "imageURL": null,
    };
    

    try {
      final response = await http.post(
        Uri.parse("$HOST/user/register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        print(response.body);
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }
}
