
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/User.dart';

class Admin extends User{
  late String phoneNumber,gender,name,accountType,branchID,address;
  late String img;



  Admin({required this.name,required this.gender,required this.phoneNumber,required this.address,
    required this.accountType,required this.branchID,required this.img, required email}) :super(email);

  Admin.createOne(this.name,this.img,email) : super(email);

  Map<String , dynamic> toJson(){
    return {
      'Name': name,
      'Email': email,
      'Address': address,
      'PhoneNumber': phoneNumber,
      'Gender': gender,
      'AccountType': accountType,
      if(accountType == "Branch-Admin")'BranchID': branchID,
      'ImageUrl': img,


    };
  }

  factory Admin.fromSnapshot(DocumentSnapshot snapshot){
    return Admin(
      email: snapshot.get("Email"),
      name: snapshot.get("Name"),
      address: snapshot.get("Address"),
      phoneNumber: snapshot.get("PhoneNumber"),
      accountType: snapshot.get("AccountType"),
      gender : snapshot.get("Gender") ,
      branchID: snapshot.data().toString().contains('BranchID') ? snapshot.get("BranchID") : "",
      img: snapshot.get("ImageUrl")
    );
  }

}