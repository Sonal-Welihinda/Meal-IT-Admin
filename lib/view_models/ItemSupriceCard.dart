import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/SurprisePack.dart';

class ItemSurpriseCard extends StatefulWidget {
  SurprisePack surprisePack;

  ItemSurpriseCard({Key? key, required this.surprisePack}) : super(key: key);

  @override
  State<ItemSurpriseCard> createState() => _ItemSurpriseCardState();
}

class _ItemSurpriseCardState extends State<ItemSurpriseCard> {
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
            child: Image.network(widget.surprisePack.imageUrl),
          ),
          SizedBox(width: 10),
          // Text fields
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.surprisePack.packName),
                SizedBox(height: 5),
                Text('Number of items : ${widget.surprisePack.numberOfItems}'),
                SizedBox(height: 5),
                // Text('Recipe :Mexican caprese salad'),
                // SizedBox(height: 5),
                Text('Quantity : ${widget.surprisePack.quantity}'),
                Spacer(),
                // Align right text
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('Price : ${widget.surprisePack.price}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );;
  }
}
