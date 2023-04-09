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


class CompanyAdd extends StatefulWidget {
  const CompanyAdd({Key? key}) : super(key: key);

  @override
  State<CompanyAdd> createState() => _CompanyAddState();
}

class _CompanyAddState extends State<CompanyAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BusinessLayer _businessL = BusinessLayer();

  var _companyNameController = TextEditingController();
  var _companyEmailController = TextEditingController();
  var _companyPhoneNumberController = TextEditingController();
  var _companyLocationController = TextEditingController();
  late i.File? companyImage=null;

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
                    onTap: () {
                      selectedImage();
                    },
                    child: Container(
                      height: (MediaQuery.of(context).size.height)*.3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: companyImage != null ? !kIsWeb? Image.file(companyImage!).image: Image.network(companyImage!.path).image : Image.asset('assets/Images/dog.jpg').image,
                          fit: BoxFit.cover
                        ),
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // FormTextFields
                  Padding(
                    padding: EdgeInsets.only(top: 20,left: 20,right: 20),
                    child: TextFormField(

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


                  Padding(
                    padding:  EdgeInsets.only(top: 16,left: 20,right: 20),
                    child: TextFormField(
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

                  Padding(
                    padding:  EdgeInsets.only(top: 16,left: 20,right: 20),
                    child: TextFormField(
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
                            borderRadius: BorderRadius.circular(10)
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


                  Padding(
                    padding:  EdgeInsets.only(top: 16,left: 20,right: 20),
                    child: TextFormField(
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

                  // Submit button
                  
                  Expanded(child: SizedBox(width: 1,)),

                  Container(
                    width: double.infinity,
                    padding:  EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                    child: TextButton(

                      style: ButtonStyle(

                        backgroundColor: MaterialStatePropertyAll(
                          Colors.black
                        ),
                        padding: MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(vertical: 2,horizontal: 1)
                        ),
                        foregroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(225, 77, 42, 1)
                        ),
                        textStyle: MaterialStatePropertyAll(
                          TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                        ),

                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if(companyImage == null){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please select image company image'),
                              ),
                            );
                            return;
                          }

                            await _businessL.createCompany(
                              _companyEmailController.text,
                               "test1234",
                               _companyNameController.text,
                               _companyLocationController.text,
                               _companyPhoneNumberController.text,
                                companyImage!
                            ).then((value) => {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                              content: Text('Company successfully created'),
                              ),


                            ),

                            Navigator.pop(context)
                          });


                          // Submit form
                        } else {
                          // Show warning
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fix the errors in the form'),
                            ),
                          );
                        }
                      },
                      child: Text('Register Company',),
                    ),
                    ),
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
