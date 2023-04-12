import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_it_admin/Classes/FoodCategory.dart';
import 'package:meal_it_admin/Classes/IngredientItem.dart';

class Recipe{
  late String? docID;
  late String recipeName;
  late String recipeImage;
  late String recipeDescription;
  late FoodCategory type;
  late String time;
  late List<IngredientItem> ingredientList;
  late List<String> steps;
  late int servings = 4;

  Recipe.create(
      {
      this.docID,
      required this.recipeName,
      required this.recipeDescription,
      required this.recipeImage,
      required this.type,
      required this.time,
      required this.ingredientList,
        required this.steps,
        required this.servings
      }
  );

  Recipe.empty();

  Map<String, dynamic> toJson() {
    return {
      'RecipeName': recipeName,
      'RecipeDescription':recipeDescription,
      'RecipeImage':recipeImage,
      'Type':type.toJson2(),
      'Time':time,
      'IngredientList':ingredientList.map((e) => e.toJson()).toList(),
      'Steps':steps,
      'Servings':servings
    };

  }

  factory Recipe.fromSnapshot(DocumentSnapshot snapshot){
    return Recipe.create(
      recipeName: snapshot.get("RecipeName"),
      recipeDescription: snapshot.get("RecipeDescription"),
      type: FoodCategory.fromSnapshot2(snapshot),
      time: snapshot.get("Time"),
      ingredientList: IngredientItem.toIngredientList(snapshot),
      steps: List<String>.from(snapshot.get("Steps")),
      docID: snapshot.id,
      recipeImage: snapshot.get("RecipeImage"),
      servings:  snapshot.get("Servings")
    );
  }

}