import 'package:meal_it_admin/Classes/FoodCategory.dart';
import 'package:meal_it_admin/Classes/FoodProduct.dart';
import 'package:meal_it_admin/Classes/Recipe.dart';

abstract class FoodInterface{
  Future<String> createFoodCategory(FoodCategory category);
  Future<List<FoodCategory>> getAllFoodCategories();
  Future<List<Recipe>> getAllRecipe();
  Future<String> createRecipe(Recipe recipe);
  Future<String> updateRecipe(Recipe recipe);
  Future<String> addProduct(FoodProduct foodProduct);
}