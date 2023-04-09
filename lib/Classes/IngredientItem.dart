import 'package:flutter/cupertino.dart';

class IngredientItem{
  late TextEditingController name;
  late TextEditingController amount;

  IngredientItem.name({required this.name, required this.amount});
}