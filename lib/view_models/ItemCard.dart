import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/FoodProduct.dart';

class ItemCard extends StatefulWidget {
  FoodProduct foodProduct;
  ItemCard({Key? key, required this.foodProduct}) : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200.withOpacity(0.9),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(3, 4), // changes position of shadow
          ),
        ],
      ),
      // color: Colors.grey.shade100,
      padding: EdgeInsets.symmetric(vertical: 6,horizontal: 6),
      margin: EdgeInsets.symmetric(vertical:8,horizontal:10),
      height: 120,
      child: Row(
        children: [
          // Image holder
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            width: 120,
            height: 100,
            child: Image.network(widget.foodProduct.imgUrl),

          ),
          SizedBox(width: 10),
          // Text fields
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.foodProduct.foodName),
                SizedBox(height: 5),
                Text('Type : ${widget.foodProduct.foodTypes.categoryName}'),
                SizedBox(height: 5),
                Text('Recipe : ${widget.foodProduct.foodRecipe.recipeName}'),
                SizedBox(height: 5),
                Text('Quantity : ${widget.foodProduct.quantity}'),
                Spacer(),
                // Align right text
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('Price : Rs:'+widget.foodProduct.price.toString()),
                ),
              ],
            ),
          ),
        ],
      ),
    );;
  }
}
