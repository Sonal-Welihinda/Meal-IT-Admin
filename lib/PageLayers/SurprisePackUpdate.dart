import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_it_admin/Classes/BL.dart';
import 'package:meal_it_admin/Classes/FoodCategory.dart';
import 'package:meal_it_admin/Classes/Recipe.dart';
import 'package:meal_it_admin/Classes/SurprisePack.dart';

class SurprisePackUpdate extends StatefulWidget {
  SurprisePack surprisePack;

  SurprisePackUpdate({Key? key, required this.surprisePack}) : super(key: key);

  @override
  State<SurprisePackUpdate> createState() => _SurprisePackUpdateState();
}

class _SurprisePackUpdateState extends State<SurprisePackUpdate> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _numOfItemsController = TextEditingController();
  late File? _image =null;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isNameEnable = false;
  bool isDescriptionEnable = false;
  bool isPriceEnable = false;
  bool isQuantityEnable = false;
  bool isNumOfItemsEnable = false;

  final BusinessLayer _businessL = BusinessLayer();




  //Methods
  //
  Future<void> _pickImage() async {
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
    
    _nameController.text = widget.surprisePack.packName;
    _descriptionController.text = widget.surprisePack.packDescription;
    _quantityController.text = widget.surprisePack.quantity.toString();
    _priceController.text = widget.surprisePack.price.toString();
    _numOfItemsController.text = widget.surprisePack.numberOfItems.toString();

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
                  onTap: () async {
                    await _pickImage();
                    if(_image != null){
                      String result = await _businessL.updateImage(widget.surprisePack.imageUrl, _image!);
                      if(result=="Success"){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Food pack image updated"))
                        );
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Something went wrong while updating food pack image"))
                        );
                      }
                    }

                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*.35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child:_image==null ? Image.network(widget.surprisePack.imageUrl): Image.file(_image!),
                  ),
                ),
                SizedBox(width: 16),

                //Product name
                Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 10,left: 20,right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: isNameEnable,
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

                      Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: IconButton(
                          onPressed: () async {
                            if(isNameEnable){
                              isNameEnable = false;
                              // Update code
                              if(!_formKey.currentState!.validate()){
                                return;
                              }

                              if(widget.surprisePack.packName.trim() != _nameController.text.trim()){
                                String result = await _businessL.updateFoodPackField(widget.surprisePack.docID, "PackName", _nameController.text.trim());

                                if(result=="Success"){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Food pack name updated"))
                                  );
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Something went wrong while updating food pack name"))
                                  );
                                }

                              }


                            }else{
                              isNameEnable = true;
                            }

                            setState(() {

                            });
                          },
                          icon: isNameEnable ? Icon(Icons.check): Icon(Icons.edit),
                          color: isNameEnable ? Color.fromRGBO(224, 76, 43, 1) : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                //Product Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: isDescriptionEnable,
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

                      Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: IconButton(
                          onPressed: () async {
                            if(isDescriptionEnable){
                              isDescriptionEnable = false;
                              // Update code
                              if(!_formKey.currentState!.validate()){
                                return;
                              }

                              if(widget.surprisePack.packDescription.trim() != _descriptionController.text.trim()){
                                String result = await _businessL.updateFoodPackField(widget.surprisePack.docID, "Description", _descriptionController.text.trim());

                                if(result=="Success"){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Food pack description updated"))
                                  );
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Something went wrong while updating food pack description"))
                                  );
                                }

                              }


                            }else{
                              isDescriptionEnable = true;
                            }

                            setState(() {

                            });
                          },
                          icon: isDescriptionEnable ? Icon(Icons.check): Icon(Icons.edit),
                          color: isDescriptionEnable ? Color.fromRGBO(224, 76, 43, 1) : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                //Price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: isPriceEnable,
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

                      Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: IconButton(
                          onPressed: () async {
                            if(isPriceEnable){
                              isPriceEnable = false;
                              // Update code
                              if(!_formKey.currentState!.validate()){
                                return;
                              }

                              if(widget.surprisePack.price != BigInt.parse(_priceController.text.trim())){
                                String result = await _businessL.updateFoodPackField(widget.surprisePack.docID, "Price", _priceController.text.trim());

                                if(result=="Success"){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Food pack price updated"))
                                  );
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Something went wrong while updating food pack price"))
                                  );
                                }

                              }


                            }else{
                              isPriceEnable = true;
                            }

                            setState(() {

                            });
                          },
                          icon: isPriceEnable ? Icon(Icons.check): Icon(Icons.edit),
                          color: isPriceEnable ? Color.fromRGBO(224, 76, 43, 1) : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                //Quantity
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: isQuantityEnable,
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


                      Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: IconButton(
                          onPressed: () async {
                            if(isQuantityEnable){
                              isQuantityEnable = false;
                              // Update code
                              if(!_formKey.currentState!.validate()){
                                return;
                              }

                              if(widget.surprisePack.quantity != BigInt.parse(_quantityController.text.trim()) ){
                                String result = await _businessL.updateFoodPackField(widget.surprisePack.docID, "Quantity", _quantityController.text.trim());

                                if(result=="Success"){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Food pack quantity updated"))
                                  );
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Something went wrong while updating food pack quantity"))
                                  );
                                }

                              }


                            }else{
                              isQuantityEnable = true;
                            }

                            setState(() {

                            });
                          },
                          icon: isQuantityEnable ? Icon(Icons.check): Icon(Icons.edit),
                          color: isQuantityEnable ? Color.fromRGBO(224, 76, 43, 1) : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                //how many items in the surprise pack
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: isNumOfItemsEnable,
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

                      Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: IconButton(
                          onPressed: () async {
                            if(isNumOfItemsEnable){
                              isNumOfItemsEnable = false;
                              // Update code
                              if(!_formKey.currentState!.validate()){
                                return;
                              }

                              if(widget.surprisePack.numberOfItems!= BigInt.parse(_numOfItemsController.text.trim())){
                                String result = await _businessL.updateFoodPackField(widget.surprisePack.docID, "NumOfItems", _numOfItemsController.text.trim());

                                if(result=="Success"){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Number of items updated"))
                                  );
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Something went wrong while updating number of items"))
                                  );
                                }

                              }


                            }else{
                              isNumOfItemsEnable = true;
                            }

                            setState(() {

                            });
                          },
                          icon: isNumOfItemsEnable ? Icon(Icons.check): Icon(Icons.edit),
                          color: isNumOfItemsEnable ? Color.fromRGBO(224, 76, 43, 1) : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),


                //Add product button


                // Padding(
                //   padding: const EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 10),
                //   child: ElevatedButton(
                //     style: ButtonStyle(
                //       backgroundColor: MaterialStatePropertyAll(
                //         Color.fromRGBO(225, 77, 42, 1)
                //       ),
                //
                //       foregroundColor: MaterialStatePropertyAll(
                //         Colors.black
                //       )
                //     ),
                //     onPressed: () async {
                //       if(_formKey.currentState!.validate()){
                //         if(_image !=null){
                //           String result = await _businessL.addSurprisePack( _nameController.text, _descriptionController.text,
                //               _priceController.text, _quantityController.text, _numOfItemsController.text, _image);
                //
                //           if(result=="Success"){
                //             ScaffoldMessenger.of(context).showSnackBar(
                //               SnackBar(
                //                 content: Text("Food pack added"),
                //               ),
                //             );
                //           }else{
                //             ScaffoldMessenger.of(context).showSnackBar(
                //               SnackBar(
                //                 content: Text("Something went wrong while Adding Food pack"),
                //               ),
                //             );
                //           }
                //         }
                //       }
                //     },
                //     child: Text('Update pack',style: TextStyle(
                //       fontWeight: FontWeight.bold
                //     )),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
