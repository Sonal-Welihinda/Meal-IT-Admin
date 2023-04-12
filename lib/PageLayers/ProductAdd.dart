import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_it_admin/Classes/BL.dart';
import 'package:meal_it_admin/Classes/FoodCategory.dart';
import 'package:meal_it_admin/Classes/Recipe.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({Key? key}) : super(key: key);

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  late File? _image =null;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late FoodCategory? selectedFoodCategory = null;
  late Recipe selectedRecipe;

  final BusinessLayer _businessL = BusinessLayer();
  late List<FoodCategory> foodCategoriesList=[];
  List<Recipe> recipeList =[];



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

  Future<void> getAllRecipe() async {
    recipeList.clear();
    recipeList = await _businessL.getAllRecipe();

    setState(() {

    });
  }

  Future<void> getAllFoodCategories() async {
    foodCategoriesList.clear();
    foodCategoriesList = await _businessL.getAllFoodCategories();
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllFoodCategories();
    getAllRecipe();
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

                //Recipe
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: DropdownSearch<Recipe>(
                    itemAsString: (item) {
                      return item.recipeName;
                    },

                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromRGBO(246, 242, 242, 1),
                            prefixIconColor: Color.fromRGBO(224, 76, 43, 1),
                            prefixIcon: Icon(Icons.menu_book),
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
                            labelText:"Recipes",
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(42, 107, 225, 1)
                            )
                        )
                    ),
                    items: recipeList,
                    popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          style: TextStyle(
                          ),

                        ),
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Text(item.recipeName),
                          );
                        }
                    ),
                    onChanged: (value) {
                      selectedRecipe = value!;
                      selectedFoodCategory = value.type;
                      setState(() {
                      });
                      print(value);
                    },
                    validator: (value) {
                      if(value==null || value.recipeName.isEmpty){
                        return "Please select the recipe";
                      }

                      return null;
                    },

                  ),
                ),

                //Food type
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: DropdownSearch<FoodCategory>(
                    itemAsString: (item) {
                      return item.categoryName;
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(246, 242, 242, 1),
                        prefixIcon: Icon(Icons.search),
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
                        labelText:"Types",
                        labelStyle: TextStyle(
                            color: Color.fromRGBO(42, 107, 225, 1)
                        )

                      )
                    ),
                    items: foodCategoriesList,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        style: TextStyle(
                        ),
                      ),
                      itemBuilder: (context, item, isSelected) {
                        return ListTile(
                          title: Text(item.categoryName.toString()),
                        );
                      }
                    ),


                    onChanged: (value) {
                      print(value);
                    },
                    selectedItem: selectedFoodCategory

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
                          String result = await _businessL.addProduct(_nameController.text, _descriptionController.text, selectedRecipe.docID!,
                              selectedFoodCategory!.docID, _priceController.text, _quantityController.text, _image);

                          if(result=="Success"){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Food Item added"),
                              ),
                            );
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Something went wrong while Adding Food Item"),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: Text('Add Product',style: TextStyle(
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
