import 'package:meal_it_admin/Classes/FoodCategory.dart';
import 'package:meal_it_admin/Classes/IngredientItem.dart';

class Recipe{
  late String recipeName;
  late String recipeDescription;
  late FoodCategory type;
  late String time;
  late List<IngredientItem> ingredientList;
  late List<String> steps;

  Recipe.create(
      {required this.recipeName,
      required this.recipeDescription,
      required this.type,
      required this.time,
      required this.ingredientList,
      });

  Recipe.empty();
}