import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_it_admin/Classes/User.dart';
import 'dart:io' as i;

class Company extends User{
  late String companyName,address,phoneNumber,companyImgUrl="";
  late i.File? companyImage;
  final String accType = "CollabCompany";

  Company(super.email);

  Company.create({this.companyImage,this.companyImgUrl="",password,uID,required email,required this.companyName,required this.address,required this.phoneNumber} )
      : super.emailAndPass(email: email,password: password,uID: uID??"");

  Company.view({this.companyImage,this.companyImgUrl="",uID,required email,required this.companyName,required this.address,required this.phoneNumber} )
      : super.emailAndPass(email: email,uID: uID);


  Map<String, dynamic> toJson() {
    return {
      'CompanyName': companyName,
      'Email': email,
      'Address': address,
      'PhoneNumber': phoneNumber,
      'AccountType': accType,
      'CompanyImageUrl':companyImgUrl

    };
  }

  factory Company.fromSnapshot(DocumentSnapshot snapshot){
    return Company.view(
      uID: snapshot.id,
      email: snapshot.get("Email"),
      companyName: snapshot.get("CompanyName"),
      address: snapshot.get("Address"),
      phoneNumber: snapshot.get("PhoneNumber"),
      companyImgUrl: snapshot.get("CompanyImageUrl"),


    );
  }



}