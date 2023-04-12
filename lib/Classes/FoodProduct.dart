import 'package:meal_it_admin/Classes/FoodCategory.dart';
import 'package:meal_it_admin/Classes/Recipe.dart';

class FoodProduct{
  late String docID;
  late String foodName;
  late String foodDescription;
  late String foodRecipe;
  late String foodTypes;
  late BigInt price;
  late BigInt quantity;
  late String imgUrl;

  FoodProduct.create(
      {
        required this.foodName,
        required this.foodDescription,
        required this.foodRecipe,
        required this.foodTypes,
        required this.price,
        required this.quantity,
        this.imgUrl ="",
        this.docID = ""

      }
      );

  Map<String, dynamic> toJson() {
    return{
      'FoodName': foodName,
      'FoodDescription': foodDescription,
      'FoodRecipe': foodRecipe,
      'FoodTypes': foodTypes,
      'Price': price.toString(),
      'Quantity': quantity.toString(),
      'ImgUrl': imgUrl,
    };
  }
}