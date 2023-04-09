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
class RiderUpdate extends StatefulWidget {

  late Rider rider;
  RiderUpdate({Key? key, required this.rider}) : super(key: key);

  @override
  State<RiderUpdate> createState() => _RiderUpdateState();
}

class _RiderUpdateState extends State<RiderUpdate> {



  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  bool nameIsEnable = false;
  bool emailIsEnable = false;
  bool phoneIsEnable = false;
  bool addressIsEnable = false;

  bool isDataChanged =false;

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




  Future<void> updateRider() async {

    Rider rider =widget.rider;
    if(_gender.name != rider.gender){
      rider.gender = _gender.name;
    }

    if(selectedBranch.uid != rider.branchID){
      rider.gender = _gender.name;
    }

    _businessL.UpdateRiders(rider,profilePic).then((value) => {
      if(isDataChanged){
        showSnackBar("Updated rider")
      },

      Navigator.pop(context)
    });


  }

  Future<void> getBranches() async {

    branchesList = await _businessL.getAllBranches();
    setState(() {});

  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void dataChanged(){
    isDataChanged = false;

    if(selectedBranch?.uid != widget.rider.branchID){
      isDataChanged = true;
    }


    if(_gender.name != widget.rider.gender){
      isDataChanged = true;
    }
    setState(() {
    });
  }

  var AddRiderTFStyle = const TextStyle(
      color: Colors.black
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
    super.initState();

    _nameController.text = widget.rider.name;
    _emailController.text = widget.rider.email;
    _phoneController.text = widget.rider.phoneNumber;
    _addressController.text = widget.rider.address;

    imageUrl = widget.rider.img;

    setState(() {
      if(widget.rider.gender == GenderSelector.male.name){
        _gender = GenderSelector.male;
      }else{
        _gender = GenderSelector.female;
      }

    });

    getBranches().then((value) {
      if(!widget.rider.branchID.isEmpty){
        selectedBranch =branchesList.where((element) => element.uid == widget.rider.branchID).single;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {



    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text("MealShip - Update Rider Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
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
                  backgroundImage: profilePic != null ? !kIsWeb? Image.file(profilePic!).image: Image.network(profilePic!.path).image :  NetworkImage(widget.rider.img),
                  child: (profilePic == null && widget.rider.img == null)? Text('Tap to add photo') : null,

                ),
              ),

              SizedBox(height: 30),

              //Email Text Field Row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: emailIsEnable,
                      controller: _emailController,
                      style: AddRiderTFStyle,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: AddRiderEnableBorder,
                        labelStyle: AddRiderTFStyle,
                        focusedBorder: AddRiderFocusBorder,
                        labelText: 'Email',
                        icon: Icon(Icons.email,color: Color.fromRGBO(224, 76, 43, 1)),
                      ),
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.zero,
                  //   margin: EdgeInsets.only(left: 10),
                  //   decoration: BoxDecoration(
                  //
                  //       color: Colors.white
                  //   ),
                  //   child: IconButton(
                  //     padding: EdgeInsets.zero,
                  //     onPressed: () async {
                  //       if(emailIsEnable){
                  //         if(_emailController.text != widget.rider.email ){
                  //           if(_emailController.text.trim().isNotEmpty){
                  //             widget.rider.email = _emailController.text;
                  //             String result = await _businessL.UpdateRiderField(widget.rider.uID, "Email", _emailController.text);
                  //
                  //             if(result=="Success"){
                  //               showSnackBar("Rider email has successfully updated");
                  //             }else{
                  //               showSnackBar("Something went wrong while Updating rider email");
                  //             }
                  //           }
                  //         }
                  //         setState(()  {
                  //           nameIsEnable = false;
                  //           //  update function should be here
                  //
                  //
                  //
                  //         });
                  //       } else {
                  //         setState(() {
                  //           nameIsEnable = true;
                  //         });
                  //       }
                  //     },
                  //     icon: nameIsEnable ? Icon(Icons.check) : Icon(Icons.edit) ,
                  //     color: Color.fromRGBO(250, 94, 38, 1),
                  //   ),
                  // )
                ],
              ),
              SizedBox(height: 20),


              //Name
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: nameIsEnable,
                      controller: _nameController,
                      style: AddRiderTFStyle,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelStyle: AddRiderTFStyle,
                        enabledBorder: AddRiderEnableBorder,
                        focusedBorder: AddRiderFocusBorder,
                        labelText: 'Name',
                        icon: Icon(Icons.person_2,color: Color.fromRGBO(224, 76, 43, 1)),
                      ),
                    ),
                  ),
                  Container(

                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(

                        color: Colors.white
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        if(nameIsEnable){
                          if(_nameController.text != widget.rider.name ){
                            if(_nameController.text.trim().isNotEmpty){
                              widget.rider.name = _nameController.text;
                              String result = await _businessL.UpdateRiderField(widget.rider.uID, "Name", _nameController.text);

                              if(result=="Success"){
                                showSnackBar("Admin name has successfully updated");
                              }else{
                                showSnackBar("Something went wrong while Updating admin name");
                              }
                            }
                          }
                          setState(()  {
                            nameIsEnable = false;
                            //  update function should be here



                          });
                        } else {
                          setState(() {
                            nameIsEnable = true;
                          });
                        }
                      },
                      icon: nameIsEnable ? Icon(Icons.check) : Icon(Icons.edit) ,
                      color: Color.fromRGBO(250, 94, 38, 1),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              

              
              //Phone Number Text field
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: phoneIsEnable,
                      controller: _phoneController,
                      style: AddRiderTFStyle,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: AddRiderEnableBorder,
                        labelStyle: AddRiderTFStyle,
                        focusedBorder: AddRiderFocusBorder,
                        labelText: 'Phone',
                        icon: Icon(Icons.phone,color: Color.fromRGBO(224, 76, 43, 1)),
                      ),
                    ),
                  ),
                  Container(

                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(

                        color: Colors.white
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        if(phoneIsEnable){
                          if(_phoneController.text != widget.rider.phoneNumber ){
                            if(_phoneController.text.trim().isNotEmpty){
                              widget.rider.phoneNumber = _phoneController.text;
                              String result = await _businessL.UpdateRiderField(widget.rider.uID, "PhoneNumber", _phoneController.text);

                              if(result=="Success"){
                                showSnackBar("Rider phone number has successfully updated");
                              }else{
                                showSnackBar("Something went wrong while updating rider phone number");
                              }
                            }
                          }
                          setState(()  {
                            phoneIsEnable = false;
                            //  update function should be here



                          });
                        } else {
                          setState(() {
                            phoneIsEnable = true;
                          });
                        }
                      },
                      icon: phoneIsEnable ? Icon(Icons.check) : Icon(Icons.edit) ,
                      color: Color.fromRGBO(250, 94, 38, 1),
                    ),
                  )
                  
                ],
              ),
              SizedBox(height: 20),
              
              //Address Text field
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: addressIsEnable,
                      controller: _addressController,
                      style: AddRiderTFStyle,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: AddRiderEnableBorder,
                        labelStyle: AddRiderTFStyle,
                        focusedBorder: AddRiderFocusBorder,
                        labelText: 'Address',
                        icon: Icon(Icons.home,color: Color.fromRGBO(224, 76, 43, 1)),
                      ),
                    ),
                  ),

                  Container(

                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(

                        color: Colors.white
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        if(addressIsEnable){
                          if(_addressController.text != widget.rider.address ){
                            if(_addressController.text.trim().isNotEmpty){
                              widget.rider.address = _addressController.text;
                              String result = await _businessL.UpdateRiderField(widget.rider.uID, "Address", _addressController.text);

                              if(result=="Success"){
                                showSnackBar("Rider address has successfully updated");
                              }else{
                                showSnackBar("Something went wrong while Updating Rider address");
                              }
                            }
                          }
                          setState(()  {
                            nameIsEnable = false;
                            //  update function should be here



                          });
                        } else {
                          setState(() {
                            nameIsEnable = true;
                          });
                        }
                      },
                      icon: nameIsEnable ? Icon(Icons.check) : Icon(Icons.edit) ,
                      color: Color.fromRGBO(250, 94, 38, 1),
                    ),
                  )
                ],
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
                        dataChanged();
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

                      fillColor: Colors.white,
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
                    label: "Male",
                    onSelect: (value){
                      setState(() {
                        _gender = value;
                        dataChanged();
                      });
                    },
                    groupValue: _gender,

                    backgroundColor: Color.fromRGBO(224, 76, 43, 1),
                    defaultBgColor: Color.fromRGBO(74, 74, 74, 1),
                    defaultIconColor: Color.fromRGBO(228, 228, 228, 1),
                    iconColor: Colors.black,

                  ),

                  SizedBox(width: 20),
                  CustomRadioButton1(
                      icon: Icons.woman,
                      label: "Female",
                      value: GenderSelector.female,
                      onSelect: (value){
                        setState(() {
                          _gender = value;
                          dataChanged();
                        });
                      },
                      groupValue: _gender,

                    backgroundColor: Color.fromRGBO(224, 76, 43, 1),
                    defaultBgColor: Color.fromRGBO(74, 74, 74, 1),
                    defaultIconColor: Color.fromRGBO(228, 228, 228, 1),
                    iconColor: Colors.black,
                  ),
                ],
              ),



              SizedBox(height: 20),


              // Create Admin button
              Visibility(
                visible: isDataChanged,
                child: ElevatedButton(
                  style: ButtonStyle(

                  ),
                  onPressed: () {
                    updateRider();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: Text("Update Rider"),
                  ),
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
