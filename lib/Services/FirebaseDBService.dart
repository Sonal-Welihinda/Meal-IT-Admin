
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meal_it_admin/Classes/Admin..dart';
import 'package:meal_it_admin/Classes/Branch.dart';
import 'package:meal_it_admin/Classes/Company.dart';
import 'package:meal_it_admin/Classes/FoodCategory.dart';
import 'package:meal_it_admin/Classes/FoodProduct.dart';
import 'package:meal_it_admin/Classes/Recipe.dart';
import 'package:meal_it_admin/Classes/Rider.dart';
import 'package:meal_it_admin/Interfaces/AdminInterface.dart';
import 'package:meal_it_admin/Interfaces/BranchInterface.dart';
import 'package:meal_it_admin/Interfaces/CompanyInterface.dart';
import 'package:meal_it_admin/Interfaces/FoodInterface.dart';
import 'package:meal_it_admin/Interfaces/RiderInterface.dart';

class FirebaseDBServices implements BranchInterface,AdminInterface,RiderInterface,CompanyInterface,FoodInterface {

  final userDocRef = FirebaseFirestore.instance.collection('users');
  final foodCategoryDocRef = FirebaseFirestore.instance.collection('FoodCategory');
  final recipeDocRef = FirebaseFirestore.instance.collection('Recipes');
  final branchDocRef = FirebaseFirestore.instance.collection('Meal Ship-Branches');
  final companyDocRef = FirebaseFirestore.instance.collection('Collab-Branches');
  final foodProductDocRef = FirebaseFirestore.instance.collection('Food-Product');


  //common methods
  Future<UserCredential> createUserWithEmailAndPassword(String email,String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential user =  await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return user;
  }

  Future<bool> emailsAvailability (String email) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    List<String> methods = await auth.fetchSignInMethodsForEmail(email);
    if (methods.isNotEmpty) {
      // Email is already in use
      return false;
    }


    return true;
  }

  Future<void> deleteImage(String imageUrl) async {
    // Get the Firebase Storage instance
    final storage = FirebaseStorage.instance;

    // Get a reference to the image file in Firebase Storage
    final imageRef = storage.refFromURL(imageUrl);

    try {
      // Delete the image file
      await imageRef.delete();
    } on FirebaseException catch (e) {
      print('Error deleting image: $e');
      // Handle the error as needed
    }
  }

  Future<String?> UploadImage(String path, File img) async {
    // final storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');

    try{
      final storageRef = FirebaseStorage.instance.ref().child(path);
      final uploadTask = storageRef.putFile(img!,SettableMetadata(
        contentType: "image/jpeg",
      ));
      final snapshot = await uploadTask.whenComplete(() => null);
      String imgUrl = await snapshot.ref.getDownloadURL();

      return imgUrl;
    } on FirebaseException catch (e){
      return null;
    }
  }




  @override
  Future<String> createBranch(Branch branch) async {
    try {
      await branchDocRef.add(branch.toJson());
      return "Success";
      print('Data added successfully.');
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }

  }

  @override
  Future<List<Branch>> getAllBranches() async {
    QuerySnapshot querySnapshot = await branchDocRef.get();
    List<Branch> Branches = querySnapshot.docs.map((doc) => Branch.fromSnapshot(doc)).toList();

    return Branches;
  }

  // ADMIN IMPLEMENTS
  @override
  Future<String> createAdmin(Admin admin,String uid) async {
    try {
      if(uid== null){
        return "Failed";
      }

      await userDocRef.doc(uid).set(admin.toJson());
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  @override
  Future<String> UpdateAdmin(Admin admin) async {
    try {
      if(admin.uID.trim().isEmpty){
        return "Failed";
      }

      await userDocRef.doc(admin.uID).update(admin.toJson());
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  @override
  Future<String> UpdateAdminField(String uID,String fieldName,String value) async {
    try {
      if(uID.trim().isEmpty){
        return "Failed";
      }

      await userDocRef.doc(uID).update({fieldName:value});
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }


  @override
  Future<List<Admin>> getAllAdmins() async {
    QuerySnapshot querySnapshot = await userDocRef.where('AccountType', whereIn: ['AdminHQ', 'Branch-Admin']).get();
    List<Admin> Branches = querySnapshot.docs.map((doc) => Admin.fromSnapshot(doc)).toList();

    return Branches;
  }

  @override
  Future<String> LoginAdmin(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential != null) {
       return 'Success';
    } else {
      return 'failed';
    }

  }

  Future<String> getUserType(String? uid) async {

    if(uid == null){
      return "";
    }

    DocumentSnapshot documentSnapshot = await userDocRef.doc(uid).get();
    if (documentSnapshot.exists) {
      Map<String,dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      if (data.containsKey('AccountType')) {
        String AccType = data["AccountType"];
        return AccType;
      }
    }
    return "";
  }

  //Riders

  @override
  Future<String> LoginRider(String email, String password) {
    // TODO: implement LoginRider
    throw UnimplementedError();
  }

  @override
  Future<String> createRiders(Rider rider) async {
    try {

      await userDocRef.doc(rider.uID).set(rider.toJson());
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  @override
  Future<List<Rider>> getAllRiders() async {
    QuerySnapshot querySnapshot = await userDocRef.where('AccountType', whereIn: ['Rider']).get();
    List<Rider> Riders = querySnapshot.docs.map((doc) => Rider.fromSnapshot(doc)).toList();

    return Riders;

  }

  @override
  Future<String> UpdateRider(Rider rider) async {
    try {
      if(rider.uID.trim().isEmpty){
        return "Failed";
      }

      await userDocRef.doc(rider.uID).update(rider.toJson());
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  @override
  Future<String> UpdateRiderField(String uID,String fieldName,String value) async {
    try {
      if(uID.trim().isEmpty){
        return "Failed";
      }

      await userDocRef.doc(uID).update({fieldName:value});
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }


  //Comapny
  //
  //

  @override
  Future<String> createCompany(Company company) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
      final uploadTask = storageRef.putFile(company.companyImage!,SettableMetadata(
        contentType: "image/jpeg",
      ));
      final snapshot = await uploadTask.whenComplete(() => null);
      company.companyImgUrl = await snapshot.ref.getDownloadURL();


      FirebaseAuth  auth = FirebaseAuth.instance;

      await auth.createUserWithEmailAndPassword(
        email: company.email,
        password: company.password,
      );

      final user = auth.currentUser;
      final uid = user?.uid;

      await userDocRef.doc(uid).set(company.toJson());
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  @override
  Future<List<Company>> getAllCompanies() async {
    QuerySnapshot querySnapshot = await userDocRef.where('AccountType', whereIn: ['CollabCompany']).get();
    List<Company> companies = querySnapshot.docs.map((doc) => Company.fromSnapshot(doc)).toList();

    return companies;
  }

  @override
  Future<String> UpdateCompanyField(String uID,String fieldName,String value) async {
    try {
      if(uID.trim().isEmpty){
        return "Failed";
      }

      await userDocRef.doc(uID).update({fieldName:value});
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  @override
  Future<String> createFoodCategory(FoodCategory category) async {
    try {
      await foodCategoryDocRef.doc().set(category.toJson());
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  @override
  Future<List<FoodCategory>> getAllFoodCategories() async {

    QuerySnapshot querySnapshot = await foodCategoryDocRef.get();
    List<FoodCategory> foodCategoryList = querySnapshot.docs.map((doc) => FoodCategory.fromSnapshot(doc)).toList();

    return foodCategoryList;
  }

  @override
  Future<String> createRecipe(Recipe recipe) async {
    try {
      await recipeDocRef.doc().set(recipe.toJson());
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  @override
  Future<String> updateRecipe(Recipe recipe) async {
    try {
      print(recipe.docID);
      await recipeDocRef.doc(recipe.docID).update(recipe.toJson());
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  @override
  Future<List<Recipe>> getAllRecipe() async {

    QuerySnapshot querySnapshot = await recipeDocRef.get();
    List<Recipe> foodCategoryList = querySnapshot.docs.map((doc) => Recipe.fromSnapshot(doc)).toList();

    return foodCategoryList;
  }

  //
  // Food product
  //

  @override
  Future<String> addProduct(FoodProduct foodProduct) async {
    try{
      await foodProductDocRef.doc().set(foodProduct.toJson());
      return "Success";

    }on FirebaseException catch (e){
      return "failed";
    }
  }

}