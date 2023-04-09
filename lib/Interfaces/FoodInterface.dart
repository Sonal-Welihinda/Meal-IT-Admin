import 'package:meal_it_admin/Classes/FoodCategory.dart';

abstract class FoodInterface{
  Future<String> createFoodCategory(FoodCategory category);
  Future<List<FoodCategory>> getAllFoodCategories();
}