import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({Key? key}) : super(key: key);

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

          ),
          SizedBox(width: 10),
          // Text fields
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cake nine of peanuts '),
                SizedBox(height: 5),
                Text('Type : indian cuisine'),
                SizedBox(height: 5),
                Text('Recipe :Mexican caprese salad'),
                SizedBox(height: 5),
                Text('Quantity'),
                Spacer(),
                // Align right text
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('Price : Rs 200.00'),
                ),
              ],
            ),
          ),
        ],
      ),
    );;
  }
}
