import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../Dataurl.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String password;



  User(
    this.id,
    this.name,
    this.email,
    this.phone,
      this.password,

  );

  factory User.fromJson(Map<String, dynamic> json)
    => User(
      int.parse(json['id'].toString()),
      json['name'],
      json['email'],
      json['phone'],
      json['password'],
    );


  Map<String, dynamic> toJson() =>{
      'id': id.toString(),
      'name': name,
      'email': email,
      'phone':phone,
      'password': password,

    };
  }




/*
   static Future<User> getUserData(String email) async {
    final url = Uri.parse('${AppData.url}Users/get_user.php');
    if (email != null) {
      final response = await http.post(url,body: {'email': email});
      if (response.statusCode == 200) {
        final userJson = jsonDecode(response.body);
        return User.fromJson(userJson);
      }
      throw Exception('Failed to load user data');

    } else {
      throw Exception('Email is null or empty');
    }
  }

 */
