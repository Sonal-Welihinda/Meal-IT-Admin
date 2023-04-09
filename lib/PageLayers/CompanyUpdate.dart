import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:meal_it_admin/Classes/BL.dart';
import 'package:meal_it_admin/Classes/Company.dart';
import 'package:meal_it_admin/Classes/PhoneNumberFormatter%20_SL.dart';
import 'package:meal_it_admin/Services/FirebaseDBService.dart';
import 'dart:io' as i;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';


class CompanyUpdate extends StatefulWidget {

  Company company;


  CompanyUpdate({Key? key, required this.company}) : super(key: key);

  @override
  State<CompanyUpdate> createState() => _CompanyUpdateState();
}

class _CompanyUpdateState extends State<CompanyUpdate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BusinessLayer _businessL = BusinessLayer();

  var _companyNameController = TextEditingController();
  var _companyEmailController = TextEditingController();
  var _companyPhoneNumberController = TextEditingController();
  var _companyLocationController = TextEditingController();
  late i.File? companyImage=null;

  bool nameIsEnable = false;
  bool emailIsEnable = false;
  bool phoneIsEnable = false;
  bool locationIsEnable = false;

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
      companyImage=file;
      setState(()  {});
    }

  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _companyNameController.text = widget.company.companyName;
    _companyEmailController.text = widget.company.email;
    _companyPhoneNumberController.text = widget.company.phoneNumber;
    _companyLocationController.text = widget.company.address;

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(247, 249, 254, 1),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom),
            child: Form(

              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,

                children: [
                  // Square to place image
                  GestureDetector(
                    onTap: () async {
                      await selectedImage();
                      if(companyImage == null){
                        return;
                      }
                      String result = await _businessL.UpdateCompanyImage(widget.company.uID,widget.company.companyImgUrl, companyImage!);

                      if(result=="Success"){
                        showSnackBar("Company image has successfully updated");
                      }else{
                        showSnackBar("Something went wrong while updating company image");
                      }

                    },
                    child: Container(
                      height: (MediaQuery.of(context).size.height)*.3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: companyImage != null ? !kIsWeb? Image.file(companyImage!).image: Image.network(companyImage!.path).image : NetworkImage(widget.company.companyImgUrl),
                          fit: BoxFit.cover
                        ),
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  Padding(
                    padding:  EdgeInsets.only(top: 30,left: 20,right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: emailIsEnable,
                            controller: _companyEmailController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(228, 228, 228, 1)
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(42, 107, 225, 1)
                                  )
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(228, 228, 228, 1),
                              prefixIcon: Icon(Icons.email),
                              prefixIconColor: Color.fromRGBO(225, 77, 42, 1),
                              labelStyle: TextStyle(color: Color.fromRGBO(42, 107, 225, 1)),
                              labelText: 'Email',
                              border: OutlineInputBorder(

                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              // if (!EmailValidator.validate(value)) {
                              //   return 'Please enter a valid email';
                              // }
                              return null;
                            },
                          ),
                        ),

                        // Container(
                        //   padding: EdgeInsets.zero,
                        //   margin: EdgeInsets.only(left: 10),
                        //   decoration: BoxDecoration(
                        //
                        //     color: Colors.white
                        //   ),
                        //   child: IconButton(
                        //     padding: EdgeInsets.zero,
                        //     onPressed: () async {
                        //       if(emailIsEnable){
                        //         if(_companyEmailController.text != widget.company.email ){
                        //           if(_companyEmailController.text.trim().isNotEmpty){
                        //             widget.company.email = _companyEmailController.text;
                        //             String result = await _businessL.UpdateRiderField(widget.company.uID, "Email", _companyEmailController.text);
                        //
                        //             if(result=="Success"){
                        //               showSnackBar("Company email has successfully updated");
                        //             }else{
                        //               showSnackBar("Something went wrong while updating company email");
                        //             }
                        //           }
                        //         }
                        //         setState(()  {
                        //           emailIsEnable = false;
                        //           //  update function should be here
                        //
                        //
                        //
                        //         });
                        //       } else {
                        //         setState(() {
                        //           emailIsEnable = true;
                        //         });
                        //       }
                        //     },
                        //     icon: emailIsEnable ? Icon(Icons.check) : Icon(Icons.edit) ,
                        //     color: Color.fromRGBO(250, 94, 38, 1),
                        //   ),
                        // )
                      ],
                    ),
                  ),


                  // FormTextFields
                  Padding(
                    padding: EdgeInsets.only(top: 20,left: 20,right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: nameIsEnable,
                            controller: _companyNameController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(228, 228, 228, 1)
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(42, 107, 225, 1)
                                  )
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(228, 228, 228, 1),
                              prefixIcon: Icon(Icons.store),
                              prefixIconColor: Color.fromRGBO(225, 77, 42, 1),
                              labelStyle: TextStyle(color: Color.fromRGBO(42, 107, 225, 1)),
                              labelText: 'Company Name',
                              border: OutlineInputBorder(
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
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
                                if(_companyNameController.text != widget.company.companyName ){
                                  if(_companyNameController.text.trim().isNotEmpty){
                                    widget.company.companyName = _companyNameController.text;
                                    String result = await _businessL.UpdateCompanyField(widget.company.uID, "CompanyName", _companyNameController.text);

                                    if(result=="Success"){
                                      showSnackBar("Company name has successfully updated");
                                    }else{
                                      showSnackBar("Something went wrong while updating company name");
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
                  ),




                  Padding(
                    padding:  EdgeInsets.only(top: 16,left: 20,right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: phoneIsEnable,
                            controller: _companyPhoneNumberController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(228, 228, 228, 1)
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(42, 107, 225, 1)
                                  )
                              ),


                              filled: true,
                              fillColor: Color.fromRGBO(228, 228, 228, 1),
                              prefixIcon: Icon(Icons.phone),
                              prefixIconColor: Color.fromRGBO(225, 77, 42, 1),
                              labelStyle: TextStyle(color: Color.fromRGBO(42, 107, 225, 1)),
                              labelText: 'Phone number',
                              border: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(10)
                              ),
                            ),

                            inputFormatters:[
                              MaskTextInputFormatter(
                                mask: '+94 ## ### ####',
                                filter:{ "#": RegExp(r'[0-9]') },
                                type: MaskAutoCompletionType.lazy

                              )
                            ],
                              // FilteringTextInputFormatter.digitsOnly,
                              // LengthLimitingTextInputFormatter(12),


                            validator: (value) {
                              if (value==null || value.trim().isEmpty) {
                                return 'Please enter a Phone number';
                              }

                              if(value.length<15){
                                return 'Please enter a valid Phone number';
                              }

                              return null;
                            },
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
                                if(_companyPhoneNumberController.text != widget.company.phoneNumber ){
                                  if(_companyPhoneNumberController.text.trim().isNotEmpty){
                                    widget.company.phoneNumber = _companyPhoneNumberController.text;
                                    String result = await _businessL.UpdateCompanyField(widget.company.uID, "PhoneNumber", _companyPhoneNumberController.text);

                                    if(result=="Success"){
                                      showSnackBar("Company phone number has successfully updated");
                                    }else{
                                      showSnackBar("Something went wrong while updating company phone number");
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
                  ),


                  Padding(
                    padding:  EdgeInsets.only(top: 16,left: 20,right: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: locationIsEnable,
                            controller: _companyLocationController,
                            maxLines: 2,
                            decoration:  InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(228, 228, 228, 1)
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(42, 107, 225, 1)
                                  )
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(228, 228, 228, 1),
                              alignLabelWithHint: true,
                              prefixIcon: Column(
                                children: [
                                  SizedBox(height: 1,),
                                  Icon(Icons.location_on)
                                ],
                              ),
                              prefixIconColor: Color.fromRGBO(225, 77, 42, 1),
                              labelStyle: TextStyle(color: Color.fromRGBO(42, 107, 225, 1)),
                              labelText: 'Location',
                              border: OutlineInputBorder(
                              ),
                            ),
                            validator: (value) {
                              if (value==null || value.trim().isEmpty) {
                                return 'Please entry the location of company';
                              }
                              return null;
                            },
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
                              if(locationIsEnable){
                                if(_companyLocationController.text != widget.company.address ){
                                  if(_companyLocationController.text.trim().isNotEmpty){
                                    widget.company.address = _companyLocationController.text;
                                    String result = await _businessL.UpdateCompanyField(widget.company.uID, "Address", _companyLocationController.text);

                                    if(result=="Success"){
                                      showSnackBar("Company address has successfully updated");
                                    }else{
                                      showSnackBar("Something went wrong while updating company address");
                                    }
                                  }
                                }
                                setState(()  {
                                  locationIsEnable = false;
                                  //  update function should be here



                                });
                              } else {
                                setState(() {
                                  locationIsEnable = true;
                                });
                              }
                            },
                            icon: locationIsEnable ? Icon(Icons.check) : Icon(Icons.edit) ,
                            color: Color.fromRGBO(250, 94, 38, 1),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Submit button
                  
                  Expanded(child: SizedBox(width: 1,)),

                  // Container(
                  //   width: double.infinity,
                  //   padding:  EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                  //   child: TextButton(
                  //
                  //     style: ButtonStyle(
                  //
                  //       backgroundColor: MaterialStatePropertyAll(
                  //         Colors.black
                  //       ),
                  //       padding: MaterialStatePropertyAll<EdgeInsets>(
                  //         EdgeInsets.symmetric(vertical: 2,horizontal: 1)
                  //       ),
                  //       foregroundColor: MaterialStatePropertyAll(
                  //           Color.fromRGBO(225, 77, 42, 1)
                  //       ),
                  //       textStyle: MaterialStatePropertyAll(
                  //         TextStyle(
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.bold
                  //         )
                  //       ),
                  //
                  //     ),
                  //     onPressed: () async {
                  //       if (_formKey.currentState!.validate()) {
                  //         if(companyImage == null){
                  //           ScaffoldMessenger.of(context).showSnackBar(
                  //             SnackBar(
                  //               content: Text('Please select image company image'),
                  //             ),
                  //           );
                  //           return;
                  //         }
                  //
                  //           await _businessL.createCompany(
                  //             _companyEmailController.text,
                  //              "test1234",
                  //              _companyNameController.text,
                  //              _companyLocationController.text,
                  //              _companyPhoneNumberController.text,
                  //               companyImage!
                  //           ).then((value) => {
                  //           ScaffoldMessenger.of(context).showSnackBar(
                  //             SnackBar(
                  //             content: Text('Company successfully created'),
                  //             ),
                  //
                  //
                  //           ),
                  //
                  //           Navigator.pop(context)
                  //         });
                  //
                  //
                  //         // Submit form
                  //       } else {
                  //         // Show warning
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           SnackBar(
                  //             content: Text('Please fix the errors in the form'),
                  //           ),
                  //         );
                  //       }
                  //     },
                  //     child: Text('Register Company',),
                  //   ),
                  //   ),
                ],
              ),
            ),
          ),
        ),

      ),
    )
    ;
  }
}
