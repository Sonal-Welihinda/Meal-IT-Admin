import 'package:flutter/material.dart';

class DrawerNav extends StatefulWidget {
  const DrawerNav({Key? key}) : super(key: key);

  @override
  State<DrawerNav> createState() => _DrawerNavState();
}

class _DrawerNavState extends State<DrawerNav> {
  @override
  Widget build(BuildContext context) {
    return
       Drawer(
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
            ListTile(
              leading: Icon(Icons.inventory_2),
              title: Text('Inventory'),
              onTap: () {
                // Navigate to home screen.
              },
            ),
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
                // Navigate to help screen.
              },

            ),

            ListTile(
              leading: Icon(Icons.sd),
              title: Text('Advertisement'),
              onTap: () {
                // Navigate to help screen.
              },

            ),

            ListTile(
              leading: Icon(Icons.store),
              title: Text('Branches'),
              onTap: () {
                // Navigate to help screen.
              },

            ),

            ListTile(
              leading: Icon(Icons.group),
              title: Text('Users'),
              onTap: () {
                // Navigate to help screen.
              },

            ),


          ],
        ),
      );


  }
}
