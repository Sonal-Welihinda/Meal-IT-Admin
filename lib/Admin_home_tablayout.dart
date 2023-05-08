import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/BL.dart';
import 'package:meal_it_admin/PageLayers/AdminUsersPage.dart';
import 'package:meal_it_admin/PageLayers/BranchPage.dart';
import 'package:meal_it_admin/PageLayers/DeliveryDispatch.dart';
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
    DeliveryDispatchPage(sacfFoldStatekey: sacfFold)
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
        backgroundColor: Color.fromRGBO(225, 77, 42, 1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(225, 77, 42, 1),
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
                textColor: Colors.white,
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
                textColor: Colors.white,
                leading: Icon(Icons.local_shipping,color: Colors.white),
                title: Text('Orders'),
                onTap: () {
                  // Navigate to settings screen.
                },
              ),
            ListTile(
              textColor: Colors.white,
              leading: Icon(Icons.receipt,color: Colors.white,),
              title: Text('Recipe'),
              onTap: () {
                setState(() {
                  index = 1;
                });
              },

            ),

            ListTile(
              textColor: Colors.white,
              leading: Icon(Icons.sd,color: Colors.white),
              title: Text('Advertisement'),
              onTap: () {
                // Navigate to help screen.
              },

            ),
            if(userType == "AdminHQ")
            ListTile(
              textColor: Colors.white,
              leading: Icon(Icons.store,color: Colors.white),
              title: Text('Branches'),
              onTap: () {
                setState(() {
                  index = 3;
                });
              },

            ),

            ListTile(
              textColor: Colors.white,
              leading: Icon(Icons.local_shipping,color: Colors.white),
              title: Text('Dispatch'),
              onTap: () {
                setState(() {
                  index = 4;
                });
              },

            ),

            ListTile(
              textColor: Colors.white,
              leading: Icon(Icons.group,color: Colors.white),
              title: Text('Users'),
              onTap: () {
                setState(() {
                  index = 2;
                });
              },

            ),
            ListTile(
              textColor: Colors.white,
              leading: Icon(Icons.logout,color: Colors.white),
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


