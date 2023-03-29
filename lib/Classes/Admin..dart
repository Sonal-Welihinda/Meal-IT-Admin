
import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/User.dart';

class Admin extends User{
  late String phoneNumber,gender,name;
  late Image img;



  Admin(this.name,this.img,email) : super(email);

}