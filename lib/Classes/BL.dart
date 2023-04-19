import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_it_admin/Classes/Admin..dart';
import 'package:meal_it_admin/Classes/Branch.dart';
import 'package:meal_it_admin/Classes/Company.dart';
import 'package:meal_it_admin/Classes/FoodCategory.dart';
import 'package:meal_it_admin/Classes/FoodProduct.dart';
import 'package:meal_it_admin/Classes/IngredientItem.dart';
import 'package:meal_it_admin/Classes/Recipe.dart';
import 'package:meal_it_admin/Classes/Rider.dart';
import 'package:meal_it_admin/Classes/SurprisePack.dart';
import 'package:meal_it_admin/Services/FirebaseDBService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessLayer{


  FirebaseDBServices _dbServices = FirebaseDBServices();
  static late SharedPreferences? prefs=null;

  Future<String> updateImage(String url, File img) async {
    String? result = await _dbServices.UpdateImage(url,img);
    if(result == null){
      return "failed";
    }else{
      return "Success";
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      // Delete the image file
      await _dbServices.deleteImage(imageUrl);
    } on FirebaseException catch (e) {
      print('Error deleting image: $e');
      // Handle the error as needed
    }
  }

  Future<String> loadSavedValue(field) async {
    prefs ??= await SharedPreferences.getInstance();
    String  userType = prefs!.getString(field) ?? '';

    return userType;
  }

  Future<void> _saveValue(String field,String value) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs!.setString(field, value);
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
      if(accountType=="Branch-Admin"){admin.branchID = branch.uid;}

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
    // String currentUserID = await loadSavedValue("UserID")
    String currentUserType = await loadSavedValue("AccountType");
    if(currentUserType== "AdminHQ"){
      return _dbServices.getAllAdmins();
    }else if(currentUserType== "Branch-Admin"){
      String branchID = await loadSavedValue("BranchID");
      return _dbServices.getAllBranchAdmins(branchID);
    }


    return [];
  }


  Future<String> LoginAdmin(String email, String password) async {
    return _dbServices.LoginAdmin(email,password);
  }

  Future<String> getUserType(String? uid) async {
    DocumentSnapshot<Object?>? snapshot = await _dbServices.getUser(uid);

    Map<String,dynamic> data = snapshot?.data() as Map<String,dynamic>;

    if(!data.containsKey("AccountType")){
      return "failed";
    }

    if(data["AccountType"] == "AdminHQ"){
      await _saveValue("AccountType",data["AccountType"].toString());
      await _saveValue("UserID",snapshot!.id);
      return "AdminHQ";
    }

    if(data["AccountType"] == "Branch-Admin"){
      await _saveValue("AccountType",data["AccountType"].toString());
      await _saveValue("UserID",snapshot!.id);
      await _saveValue("BranchID",data["BranchID"].toString());
      return "Branch-Admin";
    }

    return "";
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
    //TODO check overrides
    String currentUserType = await loadSavedValue("AccountType");
    if(currentUserType== "AdminHQ"){
      return _dbServices.getAllRiders();
    }else if(currentUserType== "Branch-Admin"){
      String branchID = await loadSavedValue("BranchID");
      return _dbServices.getAllBranchRiders(branchID);
    }

    return [];
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

  Future<String> updateCompanyField(String uid,String fieldName,String value) async {

    return _dbServices.UpdateCompanyField(uid, fieldName, value);
  }

  Future<String> UpdateCompanyImage(String uid,String oldUrl,File img) async {
    String? imgUrl =await _dbServices.UploadImage('images/${DateTime.now()}.png',img);
    if(imgUrl == null || imgUrl.trim().isEmpty){
      return "failed";
    }
    deleteImage(oldUrl);

    String result = await updateCompanyField(uid,"CompanyImageUrl",imgUrl);

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


//  Food recipe implementation
  Future<String> createRecipe( String recipeName,String recipeDescription, FoodCategory category,String time,List<IngredientItem> ingredientList,List<String> steps,int servings,File? img) async {
    if(img == null){

      return "failed";
    }
    String? imgUrl =await _dbServices.UploadImage('recipes/${DateTime.now()}.png',img);

    if(imgUrl == null || imgUrl.trim().isEmpty ){
      return "failed";
    }




    Recipe recipe = Recipe.create(
        recipeName: recipeName,
        recipeDescription: recipeDescription,
        recipeImage: imgUrl,
        type: category,
        time: time,
        ingredientList: ingredientList,
        steps: steps,
        servings: servings
    );

    String result = await _dbServices.createRecipe(recipe);

    return result;
  }

  Future<List<Recipe>> getAllRecipe() async {
    return _dbServices.getAllRecipe();
  }


  Future<String> updateRecipe( Recipe recipe,File? img) async {
    if(img != null){
      String? imgUrl =await _dbServices.UploadImage('recipes/${DateTime.now()}.png',img);
      if(imgUrl== null){
        return "failed";
      }
      deleteImage(recipe.recipeImage);
      recipe.recipeImage = imgUrl;
    }

    String result = await _dbServices.updateRecipe(recipe);

    return result;
  }

  //Product
  //
  Future<String> addProduct(String foodName,String foodDescription,Recipe recipe,FoodCategory foodType,String price,String quantity,File? img) async {
    if(img == null){

      return "failed";
    }
    String? imgUrl = await _dbServices.UploadImage('Products/${DateTime.now()}.png',img);

    if(imgUrl == null || imgUrl.trim().isEmpty ){
      return "failed";
    }

    String branchID = await loadSavedValue("BranchID");

    if(branchID==null  || branchID.trim().isEmpty){
      return "failed";
    }

    FoodProduct foodProduct = FoodProduct.create(
        foodName: foodName,
        foodDescription: foodDescription,
        foodRecipe: recipe,
        foodTypes: foodType,
        price: BigInt.parse(price),
        quantity: BigInt.parse(quantity),
        imgUrl: imgUrl,
        branchID: branchID

    );

    String result = await _dbServices.addProduct(foodProduct);


    return result;
  }

  Future<String> updateFoodProductFields(String uid,String fieldName, value) async {

    return _dbServices.updateFoodProductField(uid, fieldName, value);
  }

  Future<List<FoodProduct>> getAllFoodProduct() async {
    String branchID = await loadSavedValue("BranchID");
    if(branchID==null || branchID.trim().isEmpty){
      return Future.value(null);
    }

    return _dbServices.getAllFoodProduct(branchID);
  }


  //Surprise pack
  Future<String> addSurprisePack(String foodPackName,String foodPackDescription,String price,String quantity,String numberOfItems,File? img) async {
    if(img == null){

      return "failed";
    }
    String? imgUrl = await _dbServices.UploadImage('Products/${DateTime.now()}.png',img);

    if(imgUrl == null || imgUrl.trim().isEmpty ){
      return "failed";
    }

    String branchID = await loadSavedValue("BranchID");

    if(branchID==null  || branchID.trim().isEmpty){
      return "failed";
    }

    SurprisePack surprisePack = SurprisePack.name(
        packName: foodPackName,
        packDescription: foodPackDescription,
        quantity: BigInt.parse(quantity),
        price: BigInt.parse(price),
        numberOfItems: BigInt.parse(numberOfItems),
        branchID: branchID,
        imageUrl: imgUrl
    );

    String result = await _dbServices.addSurprisePack(surprisePack);


    return result;
  }

  Future<List<SurprisePack>> getAllFoodPacks() async {
    String branchID = await loadSavedValue("BranchID");
    if(branchID==null || branchID.trim().isEmpty){
      return Future.value(null);
    }

    return _dbServices.getAllFoodPacks(branchID);
  }

  Future<String> updateFoodPackField(String uid,String fieldName, value) async {

    return _dbServices.updateFoodPackField(uid, fieldName, value);
  }


}