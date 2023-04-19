import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class User{
 String uID="";
 String email="";
 String password="";

  User.emailAndPass({this.email="", this.password="", this.uID=""});

 // factory User(Map<String, dynamic> map) {
 //   switch (map['userType']) {
 //     case 'admin':
 //       return Admin.empty();
 //     case 'rider':
 //       return Rider(
 //         name: map['name'],
 //         email: map['email'],
 //         userType: map['userType'],
 //         riderId: map['riderId'],
 //         bikeType: map['bikeType'],
 //       );
 //     default:
 //       throw ArgumentError('Invalid userType');
 //   }
 // }


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