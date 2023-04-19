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
import 'package:meal_it_admin/Services/FirebaseDBService.dart';
import 'package:meal_it_admin/view_models/custom_RadioButton1.dart';
import 'package:permission_handler/permission_handler.dart';

enum GenderSelector { male, female }
class AdminUpdate extends StatefulWidget {
  
  late Admin admin;
  AdminUpdate({Key? key, required this.admin}) : super(key: key);

  @override
  State<AdminUpdate> createState() => _AdminUpdateState();
}

class _AdminUpdateState extends State<AdminUpdate> {



  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  late GenderSelector _gender = GenderSelector.male;

  bool nameIsEnable = false;
  bool emailIsEnable = false;
  bool phoneIsEnable = false;
  bool addressIsEnable = false;

  // GlobalKey<DropdownSearchState> _dropdownKey = GlobalKey<DropdownSearchState>();
  late Branch? selectedBranch  = null;
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

  // Future<void> uploadImage() async {
  //   if(profilePic==null){
  //     return;
  //   }
  //
  //   final storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
  //   final uploadTask = storageRef.putFile(profilePic!,SettableMetadata(
  //     contentType: "image/jpeg",
  //   ));
  //   final snapshot = await uploadTask.whenComplete(() => null);
  //   imageUrl = await snapshot.ref.getDownloadURL();
  //   setState(()  {});
  // }



  Future<void> UpdateAdmin() async {


    Admin admin =widget.admin;
    if(_gender.name != admin.gender){
      admin.gender = _gender.name;
    }

    if(AccType != admin.accountType ){
      admin.accountType = AccType;
    }

    if("Branch-Admin" == AccType){
      if(selectedBranch?.uid != admin.branchID){
        admin.gender = _gender.name;
      }
    }


    _businessL.UpdateAdmin(admin,profilePic).then((value) {
      if(value == "Success"){
        showSnackBar("Admin info updated");
      }else{
        showSnackBar("Something went wrong while updating the admin");
      }
      Navigator.pop(context);
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

    if(AccType != widget.admin.accountType){
      isDataChanged = true;
    }

    if(AccType == "Branch-Admin"){
      if(selectedBranch?.uid != widget.admin.branchID){
        isDataChanged = true;
      }
    }

    if(_gender.name != widget.admin.gender){
      isDataChanged = true;
    }

    setState(() {

    });

  }


  var AddAdminTFStyle = const TextStyle(
      color: Colors.black
  );

  var AddAdminFocusBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(5),
  );

  var AddAdminEnableBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
    borderRadius: BorderRadius.circular(5),
  );


  bool isBranchAssigned = false;
  String AccType = "Branch-Admin";



  bool isDataChanged = false;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _focusNode = FocusNode();

    _nameController.text = widget.admin.name;
    _emailController.text = widget.admin.email;
    _phoneController.text = widget.admin.phoneNumber;
    _addressController.text = widget.admin.address;

    imageUrl = widget.admin.img;
    AccType = widget.admin.accountType;

    setState(() {
      if(widget.admin.gender == GenderSelector.male.name){
        _gender = GenderSelector.male;
      }else{
        _gender = GenderSelector.female;
      }

    });


    getBranches().then((value) {
      if(AccType == "Branch-Admin"){
        if(!widget.admin.branchID.isEmpty){
          selectedBranch =branchesList.where((element) => element.uid == widget.admin.branchID).single;
          setState(() {});
        }
      }
    }
    );







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
              Text("MealShip - Update Admin",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,

                ),

              ),
              SizedBox(height: 20),

              //admin profile image
              GestureDetector(
                onTap: () async {
                  await selectedImage();
                  UpdateAdmin();
                  showSnackBar("Admin Image updated");
                },
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: profilePic != null ? !kIsWeb? Image.file(profilePic!).image: Image.network(profilePic!.path).image : NetworkImage(widget.admin.img),
                  child: (profilePic == null && widget.admin.img == null) ? Text('Tap to add photo') : null,

                ),
              ),

              SizedBox(height: 30),

              //email
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      enabled: false,
                      style: AddAdminTFStyle,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: AddAdminEnableBorder,
                        labelStyle: AddAdminTFStyle,
                        focusedBorder: AddAdminFocusBorder,
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email,color: Color.fromRGBO(224, 76, 43, 1)),
                      ),
                    ),
                  ),
                  SizedBox(width: 1,),
                  // Container(
                  //   margin: EdgeInsets.only(left: 10),
                  //   decoration: BoxDecoration(
                  //       color: Colors.white
                  //   ),
                  //   child: IconButton(
                  //     onPressed: () async {
                  //       if(emailIsEnable){
                  //         if(_emailController.text != widget.admin.email ){
                  //           if(_emailController.text.trim().isNotEmpty){
                  //             widget.admin.email = _emailController.text;
                  //             String result = await _businessL.UpdateAdminField(widget.admin.uID, "Email", _emailController.text);
                  //             if(result=="Success"){
                  //               showSnackBar("Admin email has successfully updated");
                  //             }else{
                  //               showSnackBar("Something went wrong while updating admin email");
                  //             }
                  //
                  //             // showSnackBar("Company Email has successfully updated");
                  //           }
                  //         }
                  //
                  //         setState(() {
                  //           emailIsEnable=false;
                  //           //  update function
                  //
                  //         });
                  //
                  //       }else{
                  //         setState(() {
                  //           emailIsEnable=true;
                  //         });
                  //       }
                  //
                  //     },
                  //     icon: emailIsEnable ? Icon(Icons.check) : Icon(Icons.edit) ,
                  //     color: Color.fromRGBO(250, 94, 38, 1),
                  //   ),
                  //
                  // )
                ],
              ),
              SizedBox(height: 20),
              //name
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      enabled: nameIsEnable,
                      style: AddAdminTFStyle,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelStyle: AddAdminTFStyle,
                        enabledBorder: AddAdminEnableBorder,
                        focusedBorder: AddAdminFocusBorder,
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person_2,color: Color.fromRGBO(224, 76, 43, 1)),
                      ),
                    ),
                  ),
                  // SizedBox(width: 1,),
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
                          if(_nameController.text != widget.admin.name ){
                            if(_nameController.text.trim().isNotEmpty){
                              widget.admin.name = _nameController.text;
                              String result = await _businessL.UpdateAdminField(widget.admin.uID, "Name", _nameController.text);

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

              //phone
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      enabled: phoneIsEnable,
                      style: AddAdminTFStyle,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: AddAdminEnableBorder,
                        labelStyle: AddAdminTFStyle,
                        focusedBorder: AddAdminFocusBorder,
                        labelText: 'Phone',
                        prefixIcon: Icon(Icons.phone,color: Color.fromRGBO(224, 76, 43, 1)),
                      ),
                    ),
                  ),
                  SizedBox(width: 1,),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    child: IconButton(
                      onPressed: () async {
                        if(phoneIsEnable){
                          if(_phoneController.text != widget.admin.phoneNumber ){
                            if(_phoneController.text.trim().isNotEmpty){
                              widget.admin.phoneNumber = _phoneController.text;
                              String result = await _businessL.UpdateAdminField(widget.admin.uID, "PhoneNumber", _phoneController.text);
                              if(result=="Success"){
                                showSnackBar("Admin phone number has successfully updated");
                              }
                            }
                          }

                          setState(() {
                            phoneIsEnable = false;
                          //  update phone

                          });
                        }else{
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
              //address
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addressController,
                      enabled: addressIsEnable,
                      style: AddAdminTFStyle,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: AddAdminEnableBorder,
                        labelStyle: AddAdminTFStyle,
                        focusedBorder: AddAdminFocusBorder,
                        labelText: 'Address',
                        prefixIcon: Icon(Icons.home,color: Color.fromRGBO(224, 76, 43, 1)),
                      ),
                    ),
                  ),
                  SizedBox(width: 1,),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    child: IconButton(
                      onPressed: () async {
                        if(addressIsEnable){
                          if(_addressController.text != widget.admin.address ){
                            if(_addressController.text.trim().isNotEmpty){
                              widget.admin.address = _addressController.text;
                              String result = await _businessL.UpdateAdminField(widget.admin.uID, "Address", _addressController.text);
                              if(result=="Success"){
                                showSnackBar("Admin address has successfully updated");
                              }else{
                                showSnackBar("Something went wrong while updating Admin address");
                              }

                            }
                          }

                          //Setting State
                          setState(() {
                            addressIsEnable = false;
                          //  Update function

                          });

                        }else{
                          setState(() {
                            addressIsEnable = true;
                          });

                        }
                      },
                      icon: addressIsEnable ? Icon(Icons.check) : Icon(Icons.edit) ,
                      color: Color.fromRGBO(250, 94, 38, 1),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),

              Text("Account Type", style: AddAdminTFStyle,

              ),
              SizedBox(height: 10),
              //Account type selector
              //drop down
              Container(
                padding: EdgeInsets.only(left: 10,right: 10),
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade600, width: 1
                  )

                ),
                child: DropdownButton(
                  underline: Container(),
                  isExpanded: true,
                  value: AccType,
                  icon: Icon(Icons.arrow_drop_down,color: Color.fromRGBO(224, 76, 43, 1),size: 30,),

                  iconSize: 30,
                  dropdownColor: Colors.grey,
                  style: TextStyle(
                    color: Colors.black,

                  ),
                  items: const [
                    DropdownMenuItem(child: Text("MealShip Branch-Admin"), value: "Branch-Admin"),
                    DropdownMenuItem(child: Text("MealShip AdminHQ"), value: "AdminHQ"),
                  ],
                  onChanged: (value )=> {
                    setState(() {
                      AccType = value!;

                      dataChanged();
                    }),
                  }
                ),
              ),

              SizedBox(height: 20),

              //Assign branch drop down
              Visibility(
                visible: AccType!="AdminHQ",
                child: DropdownSearch<Branch>(
                  selectedItem: selectedBranch != null ? selectedBranch : null,
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
                    baseStyle: AddAdminTFStyle,
                    dropdownSearchDecoration: InputDecoration(
                      labelStyle: AddAdminTFStyle,

                      fillColor: Colors.white,
                      filled: true,
                      labelText: isBranchAssigned? "Assigned Branch":"Assign Branch",

                    ),
                  ),
                  validator: (value) {
                    if(value == null ){
                      return "Please assign branch to user";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),



              Text("Gender",
              style: TextStyle(
                color: Colors.black
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
                      onSelect: (value){
                        setState(() {
                          _gender = value;
                          dataChanged();
                        });
                      },
                      groupValue: _gender,
                      value: GenderSelector.female,
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
                    UpdateAdmin();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: Text("Update Admin"),
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
