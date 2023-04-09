import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_it_admin/Classes/Admin..dart';
import 'package:meal_it_admin/Classes/Branch.dart';
import 'package:meal_it_admin/Classes/Company.dart';
import 'package:meal_it_admin/Classes/FoodCategory.dart';
import 'package:meal_it_admin/Classes/Rider.dart';
import 'package:meal_it_admin/Services/FirebaseDBService.dart';

class BusinessLayer{


  FirebaseDBServices _dbServices = FirebaseDBServices();


  Future<void> deleteImage(String imageUrl) async {
    try {
      // Delete the image file
      await _dbServices.deleteImage(imageUrl);
    } on FirebaseException catch (e) {
      print('Error deleting image: $e');
      // Handle the error as needed
    }
  }

  // Future<bool> emailAvailability(){
  //
  //
  //   return false;
  // }


  Future<String> createBranch(String name,String phoneNumber,String address,String longitude ,String latitude) async {
    Branch branch =Branch.createOne(name,phoneNumber,address,double.parse(longitude),double.parse(latitude));

    try {
      String result = await _dbServices.createBranch(branch);
      return result;
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }

  }

  Future<List<Branch>> getAllBranches() async {
    return _dbServices.getAllBranches();
  }

//
//  ADMIN logics
//

  Future<String> createAdmin(String name, String address,String phoneNumber,String gender,File img,String accountType,String email,String password,Branch branch) async {
    try {


      String? imageUrl = await _dbServices.UploadImage('images/${DateTime.now()}.png', img);

      if(imageUrl == null){
        return "Failed";
      }

      UserCredential user =  await _dbServices.createUserWithEmailAndPassword(email, password);
      final uid = user.user?.uid;

      Admin admin = Admin.createOne("", "", "");
      admin.name = name;
      admin.address = address;
      admin.phoneNumber = phoneNumber;
      admin.gender = gender;
      admin.img = imageUrl;
      admin.accountType = accountType;
      admin.email = email;
      admin.password = "test1234";
      if(accountType=="Branch-Admin"){admin.branchID = branch.uid;};

      await _dbServices.createAdmin(admin,uid!);
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  Future<String> UpdateAdmin(Admin admin, File? img) async {
    String? imgUrl;
    if(img!=null){
      imgUrl =await _dbServices.UploadImage('images/${DateTime.now()}.png',img);
      deleteImage(admin.img);

      admin.img = imgUrl!;
    }

    return _dbServices.UpdateAdmin(admin);
  }


  Future<String> UpdateAdminField(String uid,String fieldName,String value){

    return _dbServices.UpdateAdminField(uid, fieldName, value);
  }


  Future<List<Admin>> getAllAdmins() async {
    return _dbServices.getAllAdmins();
  }


  Future<String> LoginAdmin(String email, String password) async {
    return _dbServices.LoginAdmin(email,password);
  }

  Future<String> getUserType(String? uid) async {
    return _dbServices.getUserType(uid);
  }




//  Riders

  Future<String> createRiders(String name,String address,String phoneNumbers,String genders,File img, String email,String password,Branch branch) async {

    String? imageUrl = await _dbServices.UploadImage('images/${DateTime.now()}.png', img);

    if(imageUrl == null){
      return "failed";

    }

    Rider rider = Rider.createOne("");
    rider.name = name;
    rider.address = address;
    rider.phoneNumber = phoneNumbers;
    rider.gender = genders;
    rider.img = imageUrl;
    rider.accountType = "Rider";
    rider.email = email;
    rider.password = "test1234";
    rider.branchID = branch.uid;

    try {
      UserCredential user = await _dbServices.createUserWithEmailAndPassword(
         rider.email,
        rider.password,
      );

      // final user = FirebaseAuth.instance.currentUser;
      final uid = user.user?.uid;

      rider.uID = uid!;

      await _dbServices.createRiders(rider);
      return "Success";
    } on FirebaseException catch (e) {
      return "Failed";
    }


  }

  Future<String> UpdateRiders(Rider rider, File? img) async {
    String? imgUrl;
    if(img!=null){
      imgUrl =await _dbServices.UploadImage('images/${DateTime.now()}.png',img);
      deleteImage(rider.img);

      rider.img = imgUrl!;
    }

    return _dbServices.UpdateRider(rider);
  }

  Future<String> UpdateRiderField(String uid,String fieldName,String value){

    return _dbServices.UpdateRiderField(uid, fieldName, value);
  }

  Future<List<Rider>> getAllRiders() async {
    return _dbServices.getAllRiders();
  }


  Future<String> createCompany(String email,String password,String companyName,String address,String phoneNumber,File img) async {
    try {

      String? companyImgUrl = await _dbServices.UploadImage('images/${DateTime.now()}.png', img);

      if(companyImgUrl == null){
        return "failed";
      }



      Company company =Company.create(
          email: email,
          password: "test1234",
          companyName: companyName,
          address: address,
          phoneNumber: phoneNumber,
          companyImage: img,

      );

      company.companyImgUrl = companyImgUrl;

      UserCredential userCredential=await _dbServices.createUserWithEmailAndPassword(
        company.email,
        company.password,
      );

      // final user = auth.currentUser;
      final uid = userCredential.user?.uid;
      company.uID = uid!;

      await _dbServices.createCompany(company);
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  Future<List<Company>> getAllCompany() async {
    return _dbServices.getAllCompanies();
  }

  Future<String> UpdateCompanyField(String uid,String fieldName,String value) async {

    return _dbServices.UpdateCompanyField(uid, fieldName, value);
  }

  Future<String> UpdateCompanyImage(String uid,String oldUrl,File img) async {
    String? imgUrl =await _dbServices.UploadImage('images/${DateTime.now()}.png',img);
    if(imgUrl == null || imgUrl.trim().isEmpty){
      return "failed";
    }
    deleteImage(oldUrl);

    String result = await UpdateCompanyField(uid,"CompanyImageUrl",imgUrl);

    if(result == "Success"){
      return "Success";
    }else{
      return "failed";
    }
  }


//  Food category

  Future<String> createFoodCategory(String categoryName) async {
    FoodCategory category = FoodCategory.name(categoryName: categoryName);

    String result = await _dbServices.createFoodCategory(category);

    return result;
  }

  Future<List<FoodCategory>> getAllFoodCategories() async {
    return _dbServices.getAllFoodCategories();
  }

}