import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/Admin..dart';
import 'package:meal_it_admin/view_models/UserAdminCard.dart';

class AdminUsers extends StatefulWidget {
  const AdminUsers({Key? key}) : super(key: key);



  @override
  _AdminUsers createState() => _AdminUsers();
}

class _AdminUsers extends State<AdminUsers> with SingleTickerProviderStateMixin{


  final List<UserAdminCard> AdminsList = [
    UserAdminCard().setAdmin(Admin("Sonal",Image.asset('Images/dog.jpg',height: 80,),"Sonal@gmail.com")),
    UserAdminCard().setAdmin(Admin("Sonal2",Image.asset('Images/dog.jpg',height: 80,),"Sonal@gmail.com")),
    UserAdminCard().setAdmin(Admin("Sonal3",Image.asset('Images/dog.jpg',height: 80,),"Sonal@gmail.com")),
  ];
  int pageNum = 0;

  late TabController userTabController;

  @override
  void initState() {
    super.initState();
    userTabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    userTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                TabBar(
                  labelColor: Colors.black,
                  controller: userTabController,
                    tabs: [Tab(text: "Admins",),Tab(text: "Riders",),Tab(text: "Customers",)]
                ),

                Expanded(
                  child: TabBarView(
                    controller: userTabController,
                    children: [
                      Scaffold(
                        body: ListView.builder(
                          itemCount: AdminsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AdminsList[index];
                          },
                        ),
                        floatingActionButton: FloatingActionButton(
                          onPressed: (){},
                          backgroundColor: Colors.black,
                          child: Icon(Icons.add,color: Color.fromRGBO(224, 76, 43, 1),size: 40,),
                        ),
                      ),
                      Center(child: Text("hi 2"),),
                      Center(child: Text("hi 3"),)
                    ],
                      ),
                )

              ],



            ),


          ),


        ),
    );
  }
}
