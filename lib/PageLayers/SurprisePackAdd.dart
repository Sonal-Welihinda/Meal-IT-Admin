import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_it_admin/Classes/BL.dart';
import 'package:meal_it_admin/Classes/FoodCategory.dart';
import 'package:meal_it_admin/Classes/Recipe.dart';

class SurprisePackAdd extends StatefulWidget {
  const SurprisePackAdd({Key? key}) : super(key: key);

  @override
  State<SurprisePackAdd> createState() => _SurprisePackAddState();
}

class _SurprisePackAddState extends State<SurprisePackAdd> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _numOfItemsController = TextEditingController();
  late File? _image =null;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final BusinessLayer _businessL = BusinessLayer();



  //Methods
  //
  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Image
                GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*.35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child:_image==null ? Icon(Icons.image, size: 64) : Image.file(_image!),
                  ),
                ),
                SizedBox(width: 16),

                //Product name
                Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 10,left: 20,right: 20),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(42, 107, 225, 1)
                      ),
                      labelText: 'Product Name',
                      prefixIcon: Icon(Icons.shopping_cart),
                      prefixIconColor: Color.fromRGBO(224, 76, 43, 1),
                      filled: true,
                      fillColor: Color.fromRGBO(246, 242, 242, 1),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(246, 242, 242, 1)
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(42, 107, 225, 1),
                        )
                      )
                    ),
                    validator: (value) {
                      if(value == null || value.trim().isEmpty){
                        return "Please enter product name";
                      }
                    },


                  ),
                ),

                //Product Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(42, 107, 225, 1)
                      ),
                      labelText: 'Product Description',
                      filled: true,
                      fillColor: Color.fromRGBO(246, 242, 242, 1),
                      prefixIcon: Icon(Icons.description),
                      prefixIconColor: Color.fromRGBO(224, 76, 43, 1),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(246, 242, 242, 1)
                        )
                      ),

                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(42, 107, 225, 1),
                          )
                      ),
                    ),
                    validator: (value) {
                      if(value == null || value.trim().isEmpty){
                        return "Please enter description";
                      }

                      return null;
                    },
                  ),
                ),

                //Price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(246, 242, 242, 1),
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(42, 107, 225, 1)
                      ),
                      labelText: 'Price',
                      prefixIcon: Icon(Icons.monetization_on),
                      prefixIconColor: Color.fromRGBO(224, 76, 43, 1),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(246, 242, 242, 1)
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(42, 107, 225, 1),
                          )
                      ),
                    ),
                    validator: (value) {
                      if(value==null || value.trim().isEmpty){
                        return "Please enter an price";
                      }
                    },
                  ),
                ),

                //Quantity
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(246, 242, 242, 1),
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(42, 107, 225, 1)
                      ),
                      labelText: 'Quantity',
                      prefixIcon: Icon(Icons.shopping_basket),
                      prefixIconColor: Color.fromRGBO(224, 76, 43, 1),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(246, 242, 242, 1)
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(42, 107, 225, 1),
                          )
                      ),
                    ),
                    validator: (value) {
                      if(value == null || value.trim().isEmpty){
                        return "Please enter quantity of the product";
                      }

                      return null;
                    },
                  ),
                ),

                //how many items in the surprise pack
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: TextFormField(
                    controller: _numOfItemsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(246, 242, 242, 1),
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(42, 107, 225, 1)
                      ),
                      labelText: 'Number of items',
                      prefixIcon: Icon(Icons.scatter_plot),
                      prefixIconColor: Color.fromRGBO(224, 76, 43, 1),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(246, 242, 242, 1)
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(42, 107, 225, 1),
                          )
                      ),
                    ),
                    validator: (value) {
                      if(value == null || value.trim().isEmpty){
                        return "Please enter number of items in pack";
                      }

                      return null;
                    },
                  ),
                ),


                //Add product button
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromRGBO(225, 77, 42, 1)
                      ),

                      foregroundColor: MaterialStatePropertyAll(
                        Colors.black
                      )
                    ),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        if(_image !=null){
                          String result = await _businessL.addSurprisePack( _nameController.text, _descriptionController.text,
                              _priceController.text, _quantityController.text, _numOfItemsController.text, _image);

                          if(result=="Success"){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Food pack added"),
                              ),
                            );
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Something went wrong while Adding Food pack"),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: Text('Add pack',style: TextStyle(
                      fontWeight: FontWeight.bold
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
