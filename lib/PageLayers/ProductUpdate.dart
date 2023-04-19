import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_it_admin/Classes/BL.dart';
import 'package:meal_it_admin/Classes/FoodCategory.dart';
import 'package:meal_it_admin/Classes/FoodProduct.dart';
import 'package:meal_it_admin/Classes/Recipe.dart';

class ProductUpdate extends StatefulWidget {
  FoodProduct foodProduct;
  ProductUpdate({Key? key, required this.foodProduct}) : super(key: key);

  @override
  State<ProductUpdate> createState() => _ProductUpdateState();
}

class _ProductUpdateState extends State<ProductUpdate> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late File? _image =null;

  bool isNameEnable = false;
  bool isDescriptionEnable = false;
  bool isPriceEnable = false;
  bool isQuantityEnable =false;
  bool isRecipeEnable =false;
  bool isTypeEnable =false;

  late FoodCategory? selectedFoodCategory = null;
  late Recipe? selectedRecipe=null;

  final BusinessLayer _businessL = BusinessLayer();
  late List<FoodCategory> foodCategoriesList=[];
  List<Recipe> recipeList =[];



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

    _nameController.text = widget.foodProduct.foodName;
    _descriptionController.text = widget.foodProduct.foodDescription;
    _priceController.text = widget.foodProduct.price.toString();
    _quantityController.text = widget.foodProduct.quantity.toString();


    getAllFoodCategories().then((value) {
      selectedFoodCategory = foodCategoriesList.firstWhere((element) => element.docID == widget.foodProduct.foodTypes.docID);
    });
    getAllRecipe().then((value) {
      selectedRecipe = recipeList.firstWhere((element) => element.docID == widget.foodProduct.foodRecipe.docID);
    });
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
                      String result = await _businessL.updateImage(widget.foodProduct.imgUrl, _image!);
                      if(result=="Success"){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Food product image updated"))
                        );
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Something went wrong while updating food product image"))
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
                    child:_image==null ? Image.network(widget.foodProduct.imgUrl) : Image.file(_image!),
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

                              if(widget.foodProduct.foodName.trim() != _nameController.text.trim()){
                                String result = await _businessL.updateFoodProductFields(widget.foodProduct.docID, "FoodName", _nameController.text.trim());

                                if(result=="Success"){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Product name updated"))
                                  );
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Something went wrong while updating product name "))
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

                              if(widget.foodProduct.foodDescription != _descriptionController.text.trim()){
                                String result = await _businessL.updateFoodProductFields(widget.foodProduct.docID, "FoodDescription", _descriptionController.text.trim());

                                if(result=="Success"){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Food item description updated"))
                                  );
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Something went wrong while updating food item description"))
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

                //Recipe
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownSearch<Recipe>(
                          enabled: isRecipeEnable,
                          itemAsString: (item) {
                            return item.recipeName;
                          },
                          selectedItem: selectedRecipe,
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

                      Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: IconButton(
                          onPressed: () async {
                            if(isRecipeEnable){
                              isRecipeEnable = false;
                              // Update code
                              if(!_formKey.currentState!.validate()){
                                return;
                              }

                              if(widget.foodProduct.foodRecipe.docID != selectedRecipe!.docID){
                                String result = await _businessL.updateFoodProductFields(widget.foodProduct.docID, "FoodRecipe", selectedRecipe!.productToJson());

                                if(result=="Success"){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Food item recipe updated"))
                                  );
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Something went wrong while updating food item recipe"))
                                  );
                                }

                              }


                            }else{
                              isRecipeEnable = true;
                            }

                            setState(() {

                            });
                          },
                          icon: isRecipeEnable ? Icon(Icons.check): Icon(Icons.edit),
                          color: isRecipeEnable ? Color.fromRGBO(224, 76, 43, 1) : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                //Food type
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownSearch<FoodCategory>(
                          enabled: isTypeEnable,
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

                      Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: IconButton(
                          onPressed: () async {
                            if(isTypeEnable){
                              isTypeEnable = false;
                              // Update code
                              if(!_formKey.currentState!.validate()){
                                return;
                              }

                              if(widget.foodProduct.foodTypes != selectedFoodCategory?.docID){
                                String result = await _businessL.updateFoodProductFields(widget.foodProduct.docID, "FoodTypes", selectedFoodCategory?.docID);

                                if(result=="Success"){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Food item category updated"))
                                  );
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Something went wrong while updating food item category"))
                                  );
                                }

                              }


                            }else{
                              isTypeEnable = true;
                            }

                            setState(() {

                            });
                          },
                          icon: isTypeEnable ? Icon(Icons.check): Icon(Icons.edit),
                          color: isTypeEnable ? Color.fromRGBO(224, 76, 43, 1) : Colors.black,
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

                              if(widget.foodProduct.price != BigInt.parse(_priceController.text.trim())){
                                String result = await _businessL.updateFoodProductFields(widget.foodProduct.docID, "Price",_priceController.text.trim());

                                if(result=="Success"){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Food item price updated"))
                                  );
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Something went wrong while updating food item price"))
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

                              if(widget.foodProduct.quantity != BigInt.parse(_quantityController.text.trim())){
                                String result = await _businessL.updateFoodProductFields(widget.foodProduct.docID, "Quantity", _quantityController.text.trim());

                                if(result=="Success"){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Food quantity updated"))
                                  );
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Something went wrong while updating food quantity"))
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

              ],
            ),
          ),
        ),
      ),
    );
  }
}
