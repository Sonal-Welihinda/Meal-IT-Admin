import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/Admin..dart';
import 'package:meal_it_admin/view_models/UserAdminCard.dart';


class UserAdminCard extends StatefulWidget {
   UserAdminCard({Key? key}) : super(key: key);


  late Admin admin;

   UserAdminCard setAdmin(Admin value) {
    this.admin = value;
    return this;
  }

  Admin getAdmin(){
    return admin;
  }

  @override
  State<UserAdminCard> createState() => _UserAdminCardState();
}

class _UserAdminCardState extends State<UserAdminCard> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
              children: [
                widget.getAdmin().img
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
                      widget.getAdmin().name,
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
                      Text(widget.getAdmin().email),
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
