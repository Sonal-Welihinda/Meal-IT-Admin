import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/Admin..dart';
import 'package:meal_it_admin/Classes/Rider.dart';
import 'package:meal_it_admin/view_models/UserAdminCard.dart';


class UserRiderCard extends StatefulWidget {
  UserRiderCard({Key? key}) : super(key: key);


  late Rider rider;

   UserRiderCard setRider(Rider value) {
    this.rider = value;
    return this;
  }

  Rider getRider(){
    return rider;
  }

  @override
  State<UserRiderCard> createState() => _UserRiderCardState();
}

class _UserRiderCardState extends State<UserRiderCard> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
              children: [

                FadeInImage(
                  placeholder: AssetImage('assets/Images/dog.jpg'),
                  image: NetworkImage(widget.getRider().img),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error);
                  },
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                )


              ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0,left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Text(
                      widget.getRider().name,
                      style: TextStyle(
                        fontSize: 24,

                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Row(
                    children: [
                      Text(widget.getRider().email),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),

    );
  }
}
