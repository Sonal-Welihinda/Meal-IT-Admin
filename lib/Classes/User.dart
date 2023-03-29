import 'package:flutter/material.dart';

abstract class User{
  late String _uID;
  late String email;
  late String password;

  String get UID => _uID;

  set UID(String value) {
    _uID = value;
  }

  String get Email => email;


  set Email(String value) {
    email = value;
  }

  String get Password => password;

  set Password(String value) {
    password = value;
  }

  // User();

  User(email){
    this.email = email;
  }




}