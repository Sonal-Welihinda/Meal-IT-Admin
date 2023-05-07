
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meal_it_admin/Classes/Admin..dart';
import 'package:meal_it_admin/Classes/Branch.dart';
import 'package:meal_it_admin/Classes/Company.dart';
import 'package:meal_it_admin/Classes/CustomerOrder.dart';
import 'package:meal_it_admin/Classes/DispatchTimes.dart';
import 'package:meal_it_admin/Classes/FoodCategory.dart';
import 'package:meal_it_admin/Classes/FoodProduct.dart';
import 'package:meal_it_admin/Classes/Recipe.dart';
import 'package:meal_it_admin/Classes/Rider.dart';
import 'package:meal_it_admin/Classes/SurprisePack.dart';
import 'package:meal_it_admin/Interfaces/AdminInterface.dart';
import 'package:meal_it_admin/Interfaces/BranchInterface.dart';
import 'package:meal_it_admin/Interfaces/CompanyInterface.dart';
import 'package:meal_it_admin/Interfaces/FoodInterface.dart';
import 'package:meal_it_admin/Interfaces/RiderInterface.dart';

class FirebaseDBServices implements BranchInterface,AdminInterface,RiderInterface,CompanyInterface,FoodInterface {

  final userDocRef = FirebaseFirestore.instance.collection('users');
  final foodCategoryDocRef = FirebaseFirestore.instance.collection('FoodCategory');
  // final userColabDocRef = FirebaseFirestore.instance.collection('users-colab');
  final recipeDocRef = FirebaseFirestore.instance.collection('Recipes');
  final branchDocRef = FirebaseFirestore.instance.collection('Meal Ship-Branches');
  final companyDocRef = FirebaseFirestore.instance.collection('Collab-Branches');
  final foodProductDocRef = FirebaseFirestore.instance.collection('Food-Product');
  final surprisePackDocRef = FirebaseFirestore.instance.collection('Surprise-Pack');
  final deliveryTimeDocRef = FirebaseFirestore.instance.collection('Delivery-Dispatch');
  final orderDocRef = FirebaseFirestore.instance.collection('Orders');

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

  Future<String?> UpdateImage(String url, File img) async {
    // final storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');

    try{
      final storageRef = FirebaseStorage.instance.refFromURL(url);
      final uploadTask = storageRef.putFile(img!,SettableMetadata(
        contentType: "image/jpeg",
      ));
      await uploadTask.whenComplete(() => null);


      return "Success";
    } on FirebaseException catch (e){
      return null;
    }
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
    List<Admin> admins = querySnapshot.docs.map((doc) => Admin.fromSnapshot(doc)).toList();

    return admins;
  }

  @override
  Future<List<Admin>> getAllBranchAdmins(String branchId) async {
    QuerySnapshot querySnapshot = await userDocRef.where('AccountType', whereIn: ['Branch-Admin'])
        .where('BranchID',isEqualTo: branchId).get();
    List<Admin> admins = querySnapshot.docs.map((doc) => Admin.fromSnapshot(doc)).toList();

    return admins;
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

  Future<DocumentSnapshot?> getUser(String? uid) async {

    if(uid == null){
      return null;
    }

    DocumentSnapshot documentSnapshot = await userDocRef.doc(uid).get();
    if (documentSnapshot.exists) {
      // Map<String,dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      // if (data.containsKey('AccountType')) {
      //   String AccType = data["AccountType"];
      //   return AccType;
      // }

      return documentSnapshot;
    }
    return null;
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
  Future<List<Rider>> getAllBranchRiders(String branchID) async {
    QuerySnapshot querySnapshot = await userDocRef.where('AccountType', whereIn: ['Rider'])
        .where('BranchID',isEqualTo: branchID).get();
    List<Rider> Riders = querySnapshot.docs.map((doc) => Rider.fromSnapshot(doc)).toList();

    return Riders;

  }

  @override
  Future<List<Rider>> getAllAvailableBranchRiders(String branchID) async {
    QuerySnapshot querySnapshot = await userDocRef.where('AccountType', whereIn: ['Rider'])
        .where('BranchID',isEqualTo: branchID).where('status',isEqualTo: "Available").get();
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

  @override
  Future<Rider> getRiderByID(String userID) async {
    DocumentSnapshot documentSnapshot = await userDocRef.doc(userID).get();
    Rider Riders = Rider.fromSnapshot(documentSnapshot);

    return Riders;
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
    QuerySnapshot querySnapshot = await userDocRef.where('AccountType', whereIn: ['ColabCompany']).get();
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

  // @override
  // Future<Recipe> getRecipe(String recipeID) async {
  //
  //   QuerySnapshot querySnapshot = await recipeDocRef.get();
  //   Recipe foodCategoryList = querySnapshot.docs.map((doc) => Recipe.fromSnapshot(doc)).toList();
  //
  //   return foodCategoryList;
  // }

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

  @override
  Future<String> updateFoodProductField(String uID,String fieldName, value) async {
    try {
      if(uID.trim().isEmpty){
        return "Failed";
      }

      await foodProductDocRef.doc(uID).update({fieldName:value});
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  @override
  Future<List<FoodProduct>> getAllFoodProduct(String branchID) async {

    QuerySnapshot querySnapshot = await foodProductDocRef.where("BranchID" , isEqualTo: branchID).get();
    List<FoodProduct> foodProductList = querySnapshot.docs.map((doc) => FoodProduct.fromSnapshot(doc)).toList();

    return foodProductList;
  }


//
// Surprise pack
//

  @override
  Future<String> addSurprisePack(SurprisePack surprisePack) async {
    try{
      await surprisePackDocRef.doc().set(surprisePack.toJson());
      return "Success";

    }on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  @override
  Future<List<SurprisePack>> getAllFoodPacks(String branchID) async {

    QuerySnapshot querySnapshot = await surprisePackDocRef.where("BranchID" , isEqualTo: branchID).get();
    List<SurprisePack> foodPackList = querySnapshot.docs.map((doc) => SurprisePack.fromSnapshot(doc)).toList();

    return foodPackList;
  }

  @override
  Future<String> updateFoodPackField(String uID,String fieldName, value) async {
    try {
      if(uID.trim().isEmpty){
        return "Failed";
      }

      await surprisePackDocRef.doc(uID).update({fieldName:value});
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }


  @override
  Future<String> addDeliveryDispatch(DispatchTimes dispatchTimes) async {
    try{
      await deliveryTimeDocRef.doc().set(dispatchTimes.toJson());
      return "Success";

    }on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }


  @override
  Future<String> updateDeliveryDispatch(DispatchTimes dispatchTimes) async {
    try{
      await deliveryTimeDocRef.doc(dispatchTimes.docID).update(dispatchTimes.toJson());
      return "Success";

    }on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  @override
  Future<List<DispatchTimes>> getAllDeliveryDispatch() async {
    try{
      QuerySnapshot querySnapshot = await deliveryTimeDocRef.get();
      List<DispatchTimes> times = querySnapshot.docs.map((doc) => DispatchTimes.fromSnapshot(doc)).toList();

      return times;

    }on FirebaseException catch (e){
      print(e);
      return Future.value(null);
    }
  }

  @override
  Future<List<DispatchTimes>> getAllActiveDeliveryDispatch() async {
    try{
      QuerySnapshot querySnapshot = await deliveryTimeDocRef.where("status",isEqualTo: "Active").get();
      List<DispatchTimes> times = querySnapshot.docs.map((doc) => DispatchTimes.fromSnapshot(doc)).toList();

      return times;

    }on FirebaseException catch (e){
      print(e);
      return Future.value(null);
    }
  }

  @override
  Future<String> updateOrder(CustomerOrder order) async {
    try {
      await orderDocRef.doc(order.orderID).update(order.toJson());

      return "Success";
    } on FirebaseException catch (e) {
      print(e);
      return "failed";
    }
  }

  Future<List<CustomerOrder>> getOrderByTimeID (String TimeID) async {
    try{
      QuerySnapshot querySnapshot = await orderDocRef.where("deliveryTimeID",isEqualTo: TimeID).get();
      List<CustomerOrder> times = querySnapshot.docs.map((doc) => CustomerOrder.fromSnapshot(doc)).toList();

      return times;

    }on FirebaseException catch (e){
      print(e);
      return Future.value(null);
    }
  }

  Future<List<CustomerOrder>> getOrderByStandard() async {
    try {
      QuerySnapshot querySnapshot = await orderDocRef.where("deliveryType",isEqualTo: "Standard delivery").get();
      List<CustomerOrder> times = querySnapshot.docs.map((doc) => CustomerOrder.fromSnapshot(doc)).toList();
      return times;
    } on FirebaseException catch (e){
      print(e);
      return Future.value(null);
    }
  }

  Future<List<CustomerOrder>> getOrderByDriverID(String riderID) async {
    try {
      QuerySnapshot querySnapshot = await orderDocRef.where("driverID",isEqualTo: riderID)
          .where("status",isEqualTo: "WaitingForDelivery").get();
      List<CustomerOrder> times = querySnapshot.docs.map((doc) => CustomerOrder.fromSnapshot(doc)).toList();
      return times;
    } on FirebaseException catch (e){
      print(e);
      return Future.value(null);
    }
  }



}