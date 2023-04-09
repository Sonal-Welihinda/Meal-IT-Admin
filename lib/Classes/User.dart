import 'package:flutter/material.dart';

abstract class User{
 String uID="";
 String email="";
 String password="";

  User.emailAndPass({this.email="", this.password="", this.uID=""});

  String get UID => uID;

  set UID(String value) {
    uID = value;
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