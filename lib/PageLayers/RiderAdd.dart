import 'dart:io' as i;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_it_admin/Classes/Admin..dart';
import 'package:meal_it_admin/Classes/BL.dart';
import 'package:meal_it_admin/Classes/Branch.dart';
import 'package:meal_it_admin/Classes/Rider.dart';
import 'package:meal_it_admin/Services/FirebaseDBService.dart';
import 'package:meal_it_admin/view_models/custom_RadioButton1.dart';
import 'package:permission_handler/permission_handler.dart';

enum GenderSelector { male, female }
class RiderAdd extends StatefulWidget {
  const RiderAdd({Key? key}) : super(key: key);

  @override
  State<RiderAdd> createState() => _RiderAddState();
}

class _RiderAddState extends State<RiderAdd> {



  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  late Branch selectedBranch ;
  late String imageUrl ="";
  late i.File? profilePic=null;

  BusinessLayer _businessL = BusinessLayer();
  late List<Branch> branchesList = <Branch>[];

  Future<void> selectedImage() async {
    if(!kIsWeb){
      PermissionStatus permissionStatus ;

      if (i.Platform.isAndroid) {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          await Permission.storage.request();
          permissionStatus = await Permission.storage.status;
        }  else {
          await Permission.photos.request();
          permissionStatus = await Permission.photos.status;
        }

        if(permissionStatus.isDenied){
          return;
        }
      }


    }


    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Upload the image
      i.File file = i.File(pickedFile.path);


      // final storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
      // final uploadTask = storageRef.putFile(file,null);
      // final snapshot = await uploadTask.whenComplete(() => null);
      // imageUrl = await snapshot.ref.getDownloadURL();
      profilePic=file;
      setState(()  {});
    }

  }




  Future<void> createRider() async {

    if(profilePic == null){
      return;

    }

    if(_nameController.text.isEmpty || imageUrl == null || imageUrl.isEmpty || selectedBranch == null){
      return;
    }

    _businessL.createRiders(_nameController.text,_addressController.text,_phoneController.text,_gender.name,profilePic!,_emailController.text,"test1234",selectedBranch).then((value) => {
      Navigator.pop(context)
    });


  }

  Future<void> getBranches() async {

    branchesList = await _businessL.getAllBranches();
    setState(() {});

  }

  var AddRiderTFStyle = const TextStyle(
      color: Colors.white
  );

  var AddRiderFocusBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(5),
  );

  var AddRiderEnableBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
    borderRadius: BorderRadius.circular(5),
  );

  bool isBranchAssigned = false;

  GenderSelector _gender = GenderSelector.male;





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBranches();
  }

  @override
  Widget build(BuildContext context) {



    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(45, 45, 45, 1),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text("MealShip - Create Rider Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,

                ),

              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: (){
                  selectedImage();
                },
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: profilePic != null ? !kIsWeb? Image.file(profilePic!).image: Image.network(profilePic!.path).image : null,
                  child: profilePic == null ? Text('Tap to add photo') : null,

                ),
              ),

              SizedBox(height: 30),
              TextField(
                controller: _nameController,
                style: AddRiderTFStyle,
                decoration: InputDecoration(
                  fillColor: Color.fromRGBO(96, 96, 96, 1),
                  filled: true,
                  labelStyle: AddRiderTFStyle,
                  enabledBorder: AddRiderEnableBorder,
                  focusedBorder: AddRiderFocusBorder,
                  labelText: 'Name',
                  icon: Icon(Icons.person_2,color: Color.fromRGBO(224, 76, 43, 1)),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                style: AddRiderTFStyle,
                decoration: InputDecoration(
                  fillColor: Color.fromRGBO(96, 96, 96, 1),
                  filled: true,
                  enabledBorder: AddRiderEnableBorder,
                  labelStyle: AddRiderTFStyle,
                  focusedBorder: AddRiderFocusBorder,
                  labelText: 'Email',
                  icon: Icon(Icons.email,color: Color.fromRGBO(224, 76, 43, 1)),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                style: AddRiderTFStyle,
                decoration: InputDecoration(
                  fillColor: Color.fromRGBO(96, 96, 96, 1),
                  filled: true,
                  enabledBorder: AddRiderEnableBorder,
                  labelStyle: AddRiderTFStyle,
                  focusedBorder: AddRiderFocusBorder,
                  labelText: 'Phone',
                  icon: Icon(Icons.phone,color: Color.fromRGBO(224, 76, 43, 1)),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _addressController,
                style: AddRiderTFStyle,
                decoration: InputDecoration(
                  fillColor: Color.fromRGBO(96, 96, 96, 1),
                  filled: true,
                  enabledBorder: AddRiderEnableBorder,
                  labelStyle: AddRiderTFStyle,
                  focusedBorder: AddRiderFocusBorder,
                  labelText: 'Address',
                  icon: Icon(Icons.home,color: Color.fromRGBO(224, 76, 43, 1)),
                ),
              ),
              SizedBox(height: 20),

              Text("Account Type", style: AddRiderTFStyle,

              ),
              SizedBox(height: 10),

              //Assign branch drop down

              DropdownSearch<Branch>(
                  onChanged: (value) {
                    setState(() {
                      if(value!=null){
                        selectedBranch = value;
                        isBranchAssigned =true;
                      }else{
                        isBranchAssigned =false;
                      }

                    });
                  },

                  itemAsString: (item) {
                    return item.name;
                  },

                  //popup box design
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                        style: TextStyle(
                            color: Colors.black
                        )
                    ),

                    menuProps: MenuProps(
                        backgroundColor: Color.fromRGBO(173, 173, 173, 1)
                    ),
                    // showSelectedItems: true,
                    disabledItemFn: (Branch s) => s.name.trim().isEmpty,
                    // disabledItemFn: (String s) => s.startsWith('I')
                    // list item design
                    itemBuilder: (context, item, isSelected) => ListTile(
                      style: ListTileStyle.list,
                      selectedTileColor: Color.fromRGBO(96, 96, 96, 1),
                      tileColor: Color.fromRGBO(96, 96, 96, 1),
                      textColor: Colors.white,
                      selectedColor: Colors.red,
                      title: Text(item.name),
                      selected: isSelected,
                    ),
                  ),

                  //drop down arrow icon design
                  dropdownButtonProps: DropdownButtonProps(
                      icon: Icon(Icons.arrow_drop_down,size: 30,),
                      iconSize: 30,

                      color: Colors.red
                  ),
                  items: branchesList,

                  // drop down box field design
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    baseStyle: AddRiderTFStyle,
                    dropdownSearchDecoration: InputDecoration(
                      labelStyle: AddRiderTFStyle,

                      fillColor: Color.fromRGBO(96, 96, 96, 1),
                      filled: true,
                      labelText: isBranchAssigned? "Assigned Branch":"Assign Branch",

                    ),
                  ),

              ),
              SizedBox(height: 20),


              Text("Gender",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              SizedBox(height: 10),

              //Gender select radio buttons
              Row(

                children: [
                  SizedBox(width: 10),
                  CustomRadioButton1(
                    icon: Icons.man,
                    value: GenderSelector.male,
                    isSelected: true,
                    label: "Male",
                    onSelect: (value){
                      setState(() {
                        _gender = value;
                      });
                    },
                    groupValue: _gender,

                    backgroundColor: Color.fromRGBO(228, 228, 228, 1),
                    defaultBgColor: Color.fromRGBO(74, 74, 74, 1),
                    defaultIconColor: Color.fromRGBO(228, 228, 228, 1),
                    iconColor: Color.fromRGBO(224, 76, 43, 1),

                  ),

                  SizedBox(width: 20),
                  CustomRadioButton1(
                      icon: Icons.woman,
                      label: "Female",
                      onSelect: (value){
                        setState(() {
                          _gender = value;
                        });
                      },
                      groupValue: _gender,
                      value: GenderSelector.female,
                      backgroundColor: Color.fromRGBO(228, 228, 228, 1),
                      defaultBgColor: Color.fromRGBO(74, 74, 74, 1),
                      defaultIconColor: Color.fromRGBO(228, 228, 228, 1),
                      iconColor: Color.fromRGBO(224, 76, 43, 1)
                  ),
                ],
              ),



              SizedBox(height: 20),


              // Create Admin button
              ElevatedButton(

                style: ButtonStyle(

                ),
                onPressed: () {
                  createRider();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                  child: Text("Create Rider"),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),

      ),
    );
  }
}
