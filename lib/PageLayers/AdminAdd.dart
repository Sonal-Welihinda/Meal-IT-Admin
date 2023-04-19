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
class AdminAdd extends StatefulWidget {
  const AdminAdd({Key? key}) : super(key: key);

  @override
  State<AdminAdd> createState() => _AdminAddState();
}

class _AdminAddState extends State<AdminAdd> {

  String currentAccType ="AdminHQ";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  late Branch? selectedBranch =null;
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

  Future<void> uploadImage() async {
    if(profilePic==null){
      return;
    }

    final storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
    final uploadTask = storageRef.putFile(profilePic!,SettableMetadata(
      contentType: "image/jpeg",
    ));
    final snapshot = await uploadTask.whenComplete(() => null);
    imageUrl = await snapshot.ref.getDownloadURL();
    setState(()  {});
  }



  Future<void> createAdmin() async {
    if(profilePic == null){
      return;
    }

    if(_nameController.text.isEmpty || imageUrl == null || imageUrl.isEmpty){
      return;
    }

    if(selectedBranch==null){
      return;
    }

    await _businessL.createAdmin(_nameController.text,_addressController.text,_phoneController.text,_gender.name,profilePic!,AccType,_emailController.text
        ,"test1234",selectedBranch!).then((value) => null);
  }

  Future<void> getBranches() async {

    branchesList = await _businessL.getAllBranches();
    setState(() {});

  }

  var AddAdminTFStyle = const TextStyle(
      color: Colors.white
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

  GenderSelector _gender = GenderSelector.male;


  Future<void> isUserAllowToCreateMainAdmins() async {
    await getBranches();
    String accType = await _businessL.loadSavedValue("AccountType");
    if(accType=="Branch-Admin"){
      String branchID = await _businessL.loadSavedValue("BranchID");
      currentAccType="Branch-Admin";
      selectedBranch = branchesList.firstWhere((element) => element.uid ==branchID);
      setState(() {
      });
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isUserAllowToCreateMainAdmins();
  }

  @override
  Widget build(BuildContext context) {



    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(45, 45, 45, 1),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Text("MealShip - Create Admin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,

                  ),

                ),
                SizedBox(height: 20),

                //Image holder/selector
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

                //Name
                TextField(
                  controller: _nameController,
                  style: AddAdminTFStyle,
                  decoration: InputDecoration(
                    fillColor: Color.fromRGBO(96, 96, 96, 1),
                    filled: true,
                    labelStyle: AddAdminTFStyle,
                    enabledBorder: AddAdminEnableBorder,
                    focusedBorder: AddAdminFocusBorder,
                    labelText: 'Name',
                    icon: Icon(Icons.person_2,color: Color.fromRGBO(224, 76, 43, 1)),
                  ),
                ),
                SizedBox(height: 20),
                //Email
                TextField(
                  controller: _emailController,
                  style: AddAdminTFStyle,
                  decoration: InputDecoration(
                    fillColor: Color.fromRGBO(96, 96, 96, 1),
                    filled: true,
                    enabledBorder: AddAdminEnableBorder,
                    labelStyle: AddAdminTFStyle,
                    focusedBorder: AddAdminFocusBorder,
                    labelText: 'Email',
                    icon: Icon(Icons.email,color: Color.fromRGBO(224, 76, 43, 1)),
                  ),
                ),
                SizedBox(height: 20),
                //Phone
                TextField(
                  controller: _phoneController,
                  style: AddAdminTFStyle,
                  decoration: InputDecoration(
                    fillColor: Color.fromRGBO(96, 96, 96, 1),
                    filled: true,
                    enabledBorder: AddAdminEnableBorder,
                    labelStyle: AddAdminTFStyle,
                    focusedBorder: AddAdminFocusBorder,
                    labelText: 'Phone',
                    icon: Icon(Icons.phone,color: Color.fromRGBO(224, 76, 43, 1)),
                  ),
                ),
                SizedBox(height: 20),
                //Address
                TextField(
                  controller: _addressController,
                  style: AddAdminTFStyle,
                  decoration: InputDecoration(
                    fillColor: Color.fromRGBO(96, 96, 96, 1),
                    filled: true,
                    enabledBorder: AddAdminEnableBorder,
                    labelStyle: AddAdminTFStyle,
                    focusedBorder: AddAdminFocusBorder,
                    labelText: 'Address',
                    icon: Icon(Icons.home,color: Color.fromRGBO(224, 76, 43, 1)),
                  ),
                ),
                SizedBox(height: 20),

                Visibility(
                  visible: currentAccType!="Branch-Admin",
                    child: Column(
                      children: [
                        Text("Account Type", style: AddAdminTFStyle,), SizedBox(height: 10),
                        //Account type selector
                        //drop down
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(96, 96, 96, 1),
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
                                color: Colors.white,

                              ),
                              items: const [
                                DropdownMenuItem(child: Text("MealShip Branch-Admin"), value: "Branch-Admin"),
                                DropdownMenuItem(child: Text("MealShip AdminHQ"), value: "AdminHQ"),
                              ],
                              onChanged: (value )=> {
                                setState(() {
                                  AccType = value!;
                                }),
                              }
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                ),


                //Assign branch drop down
                Visibility(
                  visible: AccType!="AdminHQ",
                  child: DropdownSearch<Branch>(
                    enabled: !(currentAccType=="Branch-Admin"),
                    selectedItem: selectedBranch,
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
                      baseStyle: AddAdminTFStyle,
                      dropdownSearchDecoration: InputDecoration(
                        labelStyle: AddAdminTFStyle,

                        fillColor: Color.fromRGBO(96, 96, 96, 1),
                        filled: true,
                        labelText: isBranchAssigned? "Assigned Branch":"Assign Branch",

                      ),
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
                    createAdmin();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: Text("Create Admin"),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),

      ),
    );
  }


}
