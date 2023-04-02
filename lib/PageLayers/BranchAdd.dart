import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/Branch.dart';
import 'package:meal_it_admin/Services/FirebaseDBService.dart';

class BranchAdd extends StatefulWidget {
  const BranchAdd({Key? key}) : super(key: key);

  @override
  State<BranchAdd> createState() => _BranchAddState();
}

class _BranchAddState extends State<BranchAdd> {

  final TextEditingController _name = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _longitude = TextEditingController();
  final TextEditingController _latitude = TextEditingController();
  
  final FirebaseDBServices _dbServices = FirebaseDBServices();

  //reg text field styles
  //  changes font color
  var branchTFStyle = const TextStyle(
      color: Color.fromRGBO(0, 0, 139, 1)
  );

  //Focus border the will have the color
  var branchFocusBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Color.fromRGBO(0, 0, 139, 1)),
    borderRadius: BorderRadius.circular(5),
  );

  var branchEnableBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
    borderRadius: BorderRadius.circular(5),
  );

  void snackBarMessage(String msg){
    if(msg == null){
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  Future<void> createBranch() async {
    if(_name.text.trim().isEmpty||_address.text.trim().isEmpty||_phoneNumber.text.trim().isEmpty||_latitude.text.trim().isEmpty||_longitude.text.trim().isEmpty){
      snackBarMessage("Please fill the Field ");
      return;
    }



    String respond =await _dbServices.createBranch(
        Branch.createOne(_name.text,_phoneNumber.text,_address.text,double.parse(_longitude.text),double.parse(_latitude.text)));

    if(respond == "Success"){
      snackBarMessage("Branch successfully created");
    }else{
      snackBarMessage("something went wrong while creating the Branch \n please try again");
    }

  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(227, 236, 255, 1),
        body: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: Text("MealShip - Admin",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30
                ),
              ),
            ),

            // CircleAvatar(
            //   radius: 50, // size of the avatar
            //   backgroundColor: Colors.grey[300], // background color of the avatar
            //   child: Icon(Icons.person, size: 50, color: Colors.blue),
            // ),


            //Label for the text field
            // Text("Name"),
            // Text field for the name
            // it's wrap around with padding
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
              child: TextField(
                controller: _name,
                style: TextStyle(
                    color: Colors.black
                ),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,

                  prefixIcon: Icon(Icons.store,color: Color.fromRGBO(224, 76, 43, 1)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: 'Name',

                  labelStyle: branchTFStyle,
                  enabledBorder: branchEnableBorder,
                  focusedBorder: branchFocusBorder,
                ),

              ),
            ),

            //Label for phone number
            // Text("Phone number"),

            //Text field for the phone number
            Padding(
              padding: const EdgeInsets.only(top: 6,left: 20,right: 20),
              child: TextField(
                controller: _phoneNumber,
                style: TextStyle(
                    color: Colors.black
                ),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,

                  prefixIcon: Icon(Icons.store,color: Color.fromRGBO(224, 76, 43, 1)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: 'Phone number',

                  labelStyle: branchTFStyle,
                  enabledBorder: branchEnableBorder,
                  focusedBorder: branchFocusBorder,
                ),
              ),
            ),

            //Label for Address
            // Text("Address"),

            //Text field for the address
            Padding(
              padding: const EdgeInsets.only(top: 6,left: 20,right: 20),
              child: TextField(
                controller: _address,
                maxLines: 3,

                style: TextStyle(
                    color: Colors.black,

                ),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,

                  prefixIcon: Icon(
                    Icons.home,
                    color: Color.fromRGBO(224, 76, 43, 1),
                    weight: 800,

                  ),


                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: 'Address',
                  alignLabelWithHint: true,

                  labelStyle: branchTFStyle,
                  enabledBorder: branchEnableBorder,
                  focusedBorder: branchFocusBorder,
                ),

              ),
            ),


            //Label for longitude
            // Text("longitude"),

            //Text field for the longitude
            Padding(
              padding: const EdgeInsets.only(top: 6,left: 20,right: 20),
              child: TextField(
                controller: _longitude,
                style: TextStyle(
                    color: Colors.black
                ),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,

                  prefixIcon: Icon(Icons.my_location,color: Color.fromRGBO(224, 76, 43, 1)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: 'longitude',

                  labelStyle: branchTFStyle,
                  enabledBorder: branchEnableBorder,
                  focusedBorder: branchFocusBorder,
                ),

              ),
            ),

            //Label for latitude
            // Text("latitude"),

            //Text field for the latitude
            Padding(
              padding: const EdgeInsets.only(top: 6,left: 20,right: 20),
              child: TextField(
                controller: _latitude,
                style: TextStyle(
                    color: Colors.black
                ),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,

                  prefixIcon: Icon(Icons.my_location,color: Color.fromRGBO(224, 76, 43, 1)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: 'latitude',

                  labelStyle: branchTFStyle,
                  enabledBorder: branchEnableBorder,
                  focusedBorder: branchFocusBorder,
                ),
              ),
            ),

            Expanded(

              child: Container(

                padding: EdgeInsets.only(bottom: 20,left: 20,right: 20),
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                child: TextButton(

                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(double.infinity, 0)),
                      backgroundColor: MaterialStatePropertyAll(
                       Color.fromRGBO(40, 109, 224, 1)
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                    child: Text("Create Branch",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color.fromRGBO(227, 236, 255, 1)
                    )),
                  ),
                  onPressed: createBranch,
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
