import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_it_admin/Classes/SurprisePack.dart';

import 'ColabFoodProduct.dart';
import 'FoodProduct.dart';

class CartModel{
  List<SurprisePack> surpriseList=[];
  List<FoodProduct> foodProduct=[];
  List<ColabFoodProduct> colabFoodProduct=[];

  CartModel();

  BigInt getTotal(){
    BigInt total = BigInt.zero;

    surpriseList.forEach((element) {
      total += element.price*element.quantity;
    });

    foodProduct.forEach((element) {
      total += element.price*element.quantity;
    });

    colabFoodProduct.forEach((element) {
      total += element.price*BigInt.from(element.quantity);
    });

    return total;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    final List<Map<String, dynamic>> surpriseListJson =
    surpriseList.map((e) => e.toJson()).toList();
    final List<Map<String, dynamic>> foodProductJson =
    foodProduct.map((e) => e.toJson()).toList();
    final List<Map<String, dynamic>> colabFoodProductJson =
    colabFoodProduct.map((e) => e.toJson()).toList();
    data['surpriseList'] = surpriseListJson;
    data['foodProduct'] = foodProductJson;
    data['colabFoodProduct'] = colabFoodProductJson;
    return data;
  }


  factory CartModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final surpriseListJson = data['surpriseList'] as List<dynamic>;
    final foodProductJson = data['foodProduct'] as List<dynamic>;
    final colabFoodProductJson = data['colabFoodProduct'] as List<dynamic>;
    final surpriseList =
    surpriseListJson.map((e) => SurprisePack.fromSnapshot(e)).toList();
    final foodProduct =
    foodProductJson.map((e) => FoodProduct.fromSnapshot(e)).toList();
    final colabFoodProduct =
    colabFoodProductJson.map((e) => ColabFoodProduct.fromSnapshot(e)).toList();
    return CartModel()
      ..surpriseList = surpriseList
      ..foodProduct = foodProduct
      ..colabFoodProduct = colabFoodProduct;
  }

  factory CartModel.fromSnapshot3(Map<String, dynamic> data) {
    // print(snapshot.data()['surpriseL1ist']);
  // final data = snapshot.data() as Map<String, dynamic>;
    print("test1"+data.toString());
    print("");
    // List<SurprisePack> listSPack=[];
    // for(var i=0; i<data['surpriseList'].length;i++){
    //   listSPack.add(data['surpriseList'][i]);
    // }
    // print(listSPack.length);
    final surpriseListJson = data['surpriseList'] as List<dynamic>;
    final foodProductJson = data['foodProduct'] as List<dynamic>;
    final colabFoodProductJson = data['colabFoodProduct'] as List<dynamic>;
    final surpriseList =
    surpriseListJson.map((e) {
      print(e);
      return SurprisePack.fromSnapshot(e);
    }).toList();




    final foodProduct =
    foodProductJson.map((e) => FoodProduct.fromSnapshot(e)).toList();
    List<FoodProduct> listFP=[];
    final colabFoodProduct =
    colabFoodProductJson.map((e) => ColabFoodProduct.fromSnapshot(e)).toList();
    List<ColabFoodProduct> colabListFP=[];
    return CartModel()
      ..surpriseList = surpriseList
      ..foodProduct = foodProduct
      ..colabFoodProduct = colabFoodProduct;
  }



}