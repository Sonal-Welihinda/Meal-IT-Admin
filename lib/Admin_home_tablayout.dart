import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/BL.dart';
import 'package:meal_it_admin/PageLayers/AdminUsersPage.dart';
import 'package:meal_it_admin/PageLayers/BranchPage.dart';
import 'package:meal_it_admin/PageLayers/InventoryPage.dart';
import 'package:meal_it_admin/PageLayers/MealShipLogin.dart';
import 'package:meal_it_admin/PageLayers/RecipePage.dart';
import 'package:meal_it_admin/view_models/DrawerNav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Admin_home_tablayout extends StatefulWidget {
  @override
  _Admin_home_tablayout createState() => _Admin_home_tablayout();


  const Admin_home_tablayout({super.key});
}


class _Admin_home_tablayout extends State<Admin_home_tablayout> {
  GlobalKey<ScaffoldState> sacfFold = GlobalKey<ScaffoldState>();
  BusinessLayer businessL = BusinessLayer();

  late String userType="AdminHQ";

  int index = 2;


  Future<void> getUserType() async {
    userType = await businessL.loadSavedValue("AccountType");
    setState(() {

    });
  }


  late var pageLayouts = [
    InventoryPage(sacffoldKey: sacfFold),
    RecipePage(homeScaffoldState: sacfFold),
    AdminUsers(sacfFoldStatekey: sacfFold),
    BranchPage(sacfFoldStatekey: sacfFold),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserType();

  }

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      key: sacfFold,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            if(userType == "Branch-Admin")
              ListTile(
                leading: Icon(Icons.inventory_2),
                title: Text('Inventory'),
                onTap: () {
                  setState(() {
                    index = 0;
                  });
                },
              ),
            if(userType == "Branch-Admin")
              ListTile(
                leading: Icon(Icons.local_shipping),
                title: Text('Orders'),
                onTap: () {
                  // Navigate to settings screen.
                },
              ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Recipe'),
              onTap: () {
                setState(() {
                  index = 1;
                });
              },

            ),

            ListTile(
              leading: Icon(Icons.sd),
              title: Text('Advertisement'),
              onTap: () {
                // Navigate to help screen.
              },

            ),
            if(userType == "AdminHQ")
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Branches'),
              onTap: () {
                setState(() {
                  index = 3;
                });
              },

            ),

            ListTile(
              leading: Icon(Icons.group),
              title: Text('Users'),
              onTap: () {
                setState(() {
                  index = 2;
                });
              },

            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MealShipLogin()),
                );
              },

            ),


          ],
        ),
      ),
      body: pageLayouts[index],

    );


  }


