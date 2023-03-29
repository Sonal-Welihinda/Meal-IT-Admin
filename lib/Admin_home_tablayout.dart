import 'package:flutter/material.dart';
import 'package:meal_it_admin/PageLayers/AdminUsersPage.dart';

class Admin_home_tablayout extends StatefulWidget {
  @override
  _Admin_home_tablayout createState() => _Admin_home_tablayout();


  const Admin_home_tablayout({super.key});
}


class _Admin_home_tablayout extends State<Admin_home_tablayout> {
  int index = 0;
  final pageLayouts = [
    AdminUsers(),
    AdminUsers(),
  ];

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      body: pageLayouts[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(

          iconTheme: const MaterialStatePropertyAll(
            IconThemeData(
              color: Colors.white,

            ),
          ),
          indicatorColor: Colors.grey.shade900,
          labelTextStyle: const MaterialStatePropertyAll(
            TextStyle(fontSize: 14,color: Colors.white),

          ),
          


        ),
        child: NavigationBar(
          onDestinationSelected: (index) =>
            setState(()=> this.index = index),

          backgroundColor: Colors.black,
          selectedIndex: 1,

          destinations: const [
            NavigationDestination(
                selectedIcon: Icon(Icons.person,color: Color.fromRGBO(224, 76, 43, 1)),
                icon: Icon(Icons.person),

                label: "Users",
            ),

            NavigationDestination(
                selectedIcon: Icon(Icons.inventory_2,color: Color.fromRGBO(224, 76, 43, 1)),
                icon: Icon(Icons.inventory_2),
                label: "Inventory"
            )
          ],
        ),
      )
    );


  }


