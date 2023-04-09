import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/FoodCategory.dart';

class CategoryCard extends StatefulWidget {

  FoodCategory? category;
  CategoryCard({Key? key, this.category}) : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 6,horizontal: 10),
      child: Text(
        widget.category != null ? widget.category!.categoryName:"",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
