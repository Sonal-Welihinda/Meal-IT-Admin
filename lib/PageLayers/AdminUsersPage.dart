import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/Admin..dart';
import 'package:meal_it_admin/PageLayers/AdminAdd.dart';
import 'package:meal_it_admin/PageLayers/RiderAdd.dart';
import 'package:meal_it_admin/Services/FirebaseDBService.dart';
import 'package:meal_it_admin/view_models/UserAdminCard.dart';
import 'package:meal_it_admin/view_models/UserRiderCard.dart';

class AdminUsers extends StatefulWidget {
  // const AdminUsers({Key? key}) : super(key: key);
  GlobalKey<ScaffoldState> sacfFoldStatekey;


  AdminUsers( {required this.sacfFoldStatekey, Key? key}): super(key: key);

  @override
  _AdminUsers createState() => _AdminUsers();
}

class _AdminUsers extends State<AdminUsers> with SingleTickerProviderStateMixin{

  late GlobalKey<ScaffoldState> sacfFoldStatekey = widget.sacfFoldStatekey;
  FirebaseDBServices _dbServices = FirebaseDBServices();


  late List<UserAdminCard> AdminsList = [];
  late List<UserRiderCard> RidersList = [];

  void getAdmins() async {
    AdminsList.clear();
    await _dbServices.getAllAdmins().then(
            (value) => {
              for(int i=0; i<value.length;i++){
                AdminsList.add(UserAdminCard().setAdmin(value[i]))
              }
            });

    setState(() {

    });
  }

  void getRiders() async {
    RidersList.clear();
    await _dbServices.getAllRiders().then(
            (value) => {
          for(int i=0; i<value.length;i++){
            RidersList.add(UserRiderCard().setRider(value[i]))
          }
        });

    setState(() {

    });
  }

  int pageNum = 0;

  late TabController userTabController;

  @override
  void initState() {
    super.initState();
    userTabController = TabController(vsync: this, length: 3);
    getAdmins();
    getRiders();
  }

  @override
  void dispose() {
    userTabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    if(FirebaseAuth.instance.currentUser!=null){
      print("UserID${FirebaseAuth.instance.currentUser?.uid}");
    }


    return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(onPressed: (){
                      sacfFoldStatekey.currentState?.openDrawer();
                    }, icon: Icon(Icons.menu))
                  ],
                ),

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
                        body: RefreshIndicator(
                          onRefresh: () async  {
                            getAdmins();
                          },
                          child: ListView.builder(
                            itemCount: AdminsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AdminsList[index];
                            },
                          ),
                        ),
                        floatingActionButton: FloatingActionButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AdminAdd()),
                            );
                          },
                          backgroundColor: Colors.black,
                          child: Icon(Icons.add,color: Color.fromRGBO(224, 76, 43, 1),size: 40,),
                        ),
                      ),
                      Scaffold(
                        body: RefreshIndicator(
                          onRefresh: () async  {
                            getRiders();
                          },
                          child: ListView.builder(
                            itemCount: RidersList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return RidersList[index];
                            },
                          ),
                        ),
                        floatingActionButton: FloatingActionButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RiderAdd()),
                            );
                          },
                          backgroundColor: Colors.black,
                          child: Icon(Icons.add,color: Color.fromRGBO(224, 76, 43, 1),size: 40,),
                        ),
                      ),
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
