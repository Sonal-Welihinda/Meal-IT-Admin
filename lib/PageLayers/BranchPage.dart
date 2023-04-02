import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/Branch.dart';
import 'package:meal_it_admin/PageLayers/BranchAdd.dart';
import 'package:meal_it_admin/Services/FirebaseDBService.dart';

class BranchPage extends StatefulWidget {
  GlobalKey<ScaffoldState> sacfFoldStatekey;

  BranchPage({required this.sacfFoldStatekey, Key? key}) : super(key: key);

  @override
  _BranchPageState createState() => _BranchPageState();
}

class _BranchPageState extends State<BranchPage> {
  final FirebaseDBServices _dbServices = FirebaseDBServices();
  List<Branch> Brancheslist = [];

  Future<void> getBranches() async {
    await _dbServices.getAllBranches().then((value) => {
      Brancheslist = value
    });

    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getBranches();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [

            Container(
              width: double.infinity,
              child: IconButton(

                alignment: Alignment.centerLeft,
                  onPressed: (){
                    widget.sacfFoldStatekey.currentState?.openDrawer();
                  },
                  icon: Icon(Icons.menu)
              ),
            ),

            const TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await getBranches();
                },
                child: ListView.builder(
                  itemCount: Brancheslist.length, // Replace with your data source length
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(Brancheslist[index].name),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BranchAdd()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
