import 'dart:ffi';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_it_admin/Classes/BL.dart';
import 'package:meal_it_admin/Classes/FoodCategory.dart';
import 'package:meal_it_admin/Classes/IngredientItem.dart';
import 'package:meal_it_admin/Classes/Recipe.dart';


class RecipeUpdate extends StatefulWidget {
  // const RecipeUpdate({super.key});

  late Recipe recipe;


  RecipeUpdate({required this.recipe});

  @override
  _RecipeUpdateState createState() => _RecipeUpdateState();
}

class _RecipeUpdateState extends State<RecipeUpdate> {
  List<IngredientItem> ingredientList = [];
  late List<TextEditingController> stepsControllerList = [];
  bool isShowingSteps = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // final TextEditingController _textController3 = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();
  bool nameIsEnable = false;
  bool descriptionIsEnable = false;
  bool typeIsEnable = false;
  bool timeIsEnable = false;
  bool servingsIsEnable = false;
  late List<FoodCategory> foodCategoriesList=[];
  late FoodCategory? selectedFoodType;
  late File? imgFile =null;
  final BusinessLayer _businessL = BusinessLayer();




  @override
  void initState() {
    super.initState();
    getAllFoodCategories();

    ingredientList = widget.recipe.ingredientList;
    stepsControllerList = List.generate(widget.recipe.steps.length, (index) => TextEditingController(text:widget.recipe.steps[index] )) ;
    _nameController.text = widget.recipe.recipeName;
    _descriptionController.text = widget.recipe.recipeDescription;
    _timeController.text = widget.recipe.time;
    _servingsController.text = widget.recipe.servings.toString();
    selectedFoodType = widget.recipe.type;


  }

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imgFile = File(pickedFile.path);
      } else {
        imgFile = null;
      }
    });
  }

  Future<void> getAllFoodCategories() async {
    foodCategoriesList = await _businessL.getAllFoodCategories();
    setState(() {

    });
  }

  Future<void> updateRecipe() async {
    String result = await _businessL.updateRecipe(widget.recipe, imgFile);

    if("Success"==result){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Recipe successfully updated"),
        ),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong while updating recipe"),
        ),
      );
    }

  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(247, 249, 254, 1),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[200],
                    ),
                    child: imgFile == null
                        ? Image.network(
                      widget.recipe.recipeImage,
                      fit: BoxFit.cover,
                    )
                        : Image.file(imgFile!),

                  ),
                ),
                SizedBox(height: 16),
                //Recipe Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: nameIsEnable,
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Recipe name',
                            floatingLabelStyle: TextStyle(
                              color: Color.fromRGBO(225, 77, 42, 1)
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white
                              )
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(230, 135, 113, 1),
                                  width: 0.8
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(225, 77, 42, 1)
                              )
                            ),
                            errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              height: 1.0,
                            ),
                          ),
                          validator: (value) {
                            if(value==null || value.trim().isEmpty){
                              return "Please enter recipe name";
                            }
                            return null;
                          },
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: IconButton(
                          onPressed: () {
                            if(nameIsEnable){
                              if(_nameController.text != widget.recipe.recipeName ){
                                if(!_formKey.currentState!.validate()){return;}
                                if(_nameController.text.trim().isNotEmpty){
                                  widget.recipe.recipeName = _nameController.text;
                                  updateRecipe();
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
                          icon: !nameIsEnable ? Icon(Icons.edit) : Icon(Icons.check),
                          color: Color.fromRGBO(225, 77, 42, 1),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16),
                //Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: descriptionIsEnable,
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Recipe description',
                            floatingLabelStyle: TextStyle(
                                color: Color.fromRGBO(225, 77, 42, 1)
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white
                                )
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(230, 135, 113, 1),
                                  width: 0.8
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(225, 77, 42, 1)
                                )
                            ),
                            errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              height: 1.0,
                            ),
                          ),
                          validator: (value) {
                            if(value==null || value.trim().isEmpty){
                              return "Please enter recipe description";
                            }
                          },
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: IconButton(
                          onPressed: () {
                            if(descriptionIsEnable){
                              if(_descriptionController.text != widget.recipe.recipeDescription ){
                                if(!_formKey.currentState!.validate()){return;}
                                if(_descriptionController.text.trim().isNotEmpty){
                                  widget.recipe.recipeDescription = _descriptionController.text;
                                  updateRecipe();
                                }
                              }
                              setState(()  {
                                descriptionIsEnable = false;
                                //  update function should be here



                              });
                            } else {
                              setState(() {
                                descriptionIsEnable = true;
                              });
                            }
                          },
                          icon: !descriptionIsEnable ? Icon(Icons.edit) : Icon(Icons.check),
                          color: Color.fromRGBO(225, 77, 42, 1),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16),

                //type
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [

                      Expanded(
                        child: DropdownSearch<FoodCategory>(
                          selectedItem: selectedFoodType,
                          enabled: typeIsEnable,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            // showSelectedItems: true,
                            disabledItemFn: (FoodCategory s) => s==null,
                          ),
                          items: foodCategoriesList,
                          itemAsString: (FoodCategory u) => u.categoryName,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Food type",
                              floatingLabelStyle: TextStyle(
                                  color: Color.fromRGBO(225, 77, 42, 1)
                              ),
                              hintText: "Select food type",
                              // prefixIcon: Icon(Icons.restaurant_menu),
                              // prefixIconColor: Color.fromRGBO(225, 77, 42, 1),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(230, 135, 113, 1),
                                    width: 0.8
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(225, 77, 42, 1)
                                  )
                              ),
                              errorStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                height: 1.0,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            selectedFoodType = value;
                          },
                          validator: (value) {
                            if(value== null || value.categoryName.trim().isEmpty){
                              return "Please selected food category";
                            }

                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: IconButton(
                          onPressed: () {
                            if(typeIsEnable){
                              if(selectedFoodType != widget.recipe.type ){
                                if(!_formKey.currentState!.validate()){return;}
                                if(selectedFoodType != null){
                                  widget.recipe.type = selectedFoodType!;
                                  updateRecipe();

                                }
                              }
                              setState(()  {
                                typeIsEnable = false;
                                //  update function should be here



                              });
                            } else {
                              setState(() {
                                typeIsEnable = true;
                              });
                            }
                          },
                          icon: !typeIsEnable ? Icon(Icons.edit) : Icon(Icons.check),
                          color: Color.fromRGBO(225, 77, 42, 1),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16),
                //Time
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: timeIsEnable,
                          controller: _timeController,
                          decoration: InputDecoration(
                            labelText: 'time',
                              floatingLabelStyle: TextStyle(
                                color: Color.fromRGBO(225, 77, 42, 1)
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white
                                )
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(230, 135, 113, 1),
                                  width: 0.8
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(225, 77, 42, 1)
                                )
                            ),
                            errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              height: 1.0,
                            ),
                          ),
                          validator: (value) {
                            if(value== null|| value.trim().isEmpty){
                              return "Please enter the time it will take";
                            }
                          },

                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: IconButton(
                          onPressed: () {
                            if(timeIsEnable){
                              if(_timeController.text != widget.recipe.time ){
                                if(!_formKey.currentState!.validate()){return;}
                                if(_timeController.text.trim().isNotEmpty){
                                  widget.recipe.time = _timeController.text;

                                  updateRecipe();
                                }
                              }
                              setState(()  {
                                timeIsEnable = false;
                                //  update function should be here



                              });
                            } else {
                              setState(() {
                                timeIsEnable = true;
                              });
                            }
                          },
                          icon: !timeIsEnable ? Icon(Icons.edit) : Icon(Icons.check),
                          color: Color.fromRGBO(225, 77, 42, 1),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16),
                //Servings
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: servingsIsEnable,
                          controller: _servingsController,
                          decoration: InputDecoration(
                            labelText: 'Servings',
                            floatingLabelStyle: TextStyle(
                              color: Color.fromRGBO(225, 77, 42, 1)
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white
                              )
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(230, 135, 113, 1),
                                width: 0.8
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(225, 77, 42, 1)
                                )
                            ),
                            errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              height: 1.0,
                            ),
                            filled: true,
                            fillColor: Colors.white
                          ),
                          validator: (value) {
                            if(value==null||value.trim().isEmpty){
                              return "Please enter number of servings";
                            }
                          },
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: IconButton(
                          onPressed: () {
                            if(servingsIsEnable){
                              if(int.parse(_servingsController.text) != widget.recipe.servings ){
                                if(!_formKey.currentState!.validate()){return;}
                                if(_servingsController.text.trim().isNotEmpty){
                                  if (int.parse(_servingsController.text) != 0) {
                                    widget.recipe.servings = int.parse(_servingsController.text);

                                    updateRecipe();
                                  }
                                }
                              }
                              setState(()  {
                                servingsIsEnable = false;
                                //  update function should be here



                              });
                            } else {
                              setState(() {
                                servingsIsEnable = true;
                              });
                            }
                          },
                          icon: !servingsIsEnable ? Icon(Icons.edit) : Icon(Icons.check),
                          color: Color.fromRGBO(225, 77, 42, 1),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16),

                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isShowingSteps = false;
                        });
                      },
                      child: Text('Ingredients'),
                      style: ButtonStyle(
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.1,vertical: MediaQuery.of(context).size.height*.015)),
                        backgroundColor: isShowingSteps ? MaterialStatePropertyAll(Color.fromRGBO(236, 236, 236, 1)): MaterialStatePropertyAll(Color.fromRGBO(225, 77, 42, 1)),
                        foregroundColor: isShowingSteps ? MaterialStatePropertyAll(Color.fromRGBO(225, 77, 42, 1)): MaterialStatePropertyAll(Color.fromRGBO(236, 236, 236, 1)),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        ))

                      ),

                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isShowingSteps = true;
                        });
                      },
                      child: Text('Steps'),
                      style: ButtonStyle(
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.1,vertical: MediaQuery.of(context).size.height*.015)),
                          backgroundColor: !isShowingSteps ? MaterialStatePropertyAll(Color.fromRGBO(236, 236, 236, 1)): MaterialStatePropertyAll(Color.fromRGBO(225, 77, 42, 1)),
                          foregroundColor: !isShowingSteps ? MaterialStatePropertyAll(Color.fromRGBO(225, 77, 42, 1)): MaterialStatePropertyAll(Color.fromRGBO(236, 236, 236, 1)),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ))

                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        !isShowingSteps ?
                        _showIngredientsBS(context)
                        :
                        _showStepsBS(context);
                      },
                      child: Icon(Icons.edit),

                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*.014 , horizontal: MediaQuery.of(context).size.height*.014),
                        backgroundColor: Color.fromRGBO(236, 236, 236, 1), // <-- Button color
                        foregroundColor: Colors.black, // <-- Splash color
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 400
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: isShowingSteps? stepsControllerList.length : ingredientList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(isShowingSteps ? stepsControllerList[index].text: "${ingredientList[index].amount.text} -- ${ingredientList[index].name.text}"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _showIngredientsBS(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height*.9

            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height*.7

                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: ingredientList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 6,horizontal: 14) ,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  //Ingredient and amount card
                                  Expanded(
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: ingredientList[index].name,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color.fromRGBO(246, 242, 242, 1),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color.fromRGBO(246, 242, 242, 1),
                                                )
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color.fromRGBO(225, 77, 42, 1),
                                                )
                                            ),
                                            labelText: "Ingredient Name",
                                            labelStyle: TextStyle(
                                                color: Colors.black
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        TextField(
                                          controller: ingredientList[index].amount,
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.black,
                                                  )
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color.fromRGBO(225, 77, 42, 1),
                                                  )
                                              ),
                                              labelText: "Amount",
                                              labelStyle: TextStyle(
                                                  color: Color.fromRGBO(225, 77, 42, 1)
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //remove Ingredient button
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if(ingredientList.length != 1){
                                            ingredientList[index].name.clear();
                                            ingredientList[index].amount.clear();

                                            ingredientList[index].name.dispose();
                                            ingredientList[index].amount.dispose();
                                            ingredientList.removeAt(index);
                                          }

                                        });

                                      },
                                      icon: Icon(Icons.close))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            ingredientList.add(IngredientItem.name(name: TextEditingController(), amount: TextEditingController()));
                          });
                        },
                        child: Text("Add Ingredients")
                    )
                  ],
                ),

                Row(

                  children: [
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel',
                          style: TextStyle(
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.grey.shade100),
                          foregroundColor: MaterialStatePropertyAll(Colors.black),
                          side: MaterialStatePropertyAll(BorderSide(
                            color: Colors.black
                          ))
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if(ingredientList != widget.recipe.ingredientList){
                            if(ingredientList.isNotEmpty){
                              widget.recipe.ingredientList = ingredientList;
                              await updateRecipe();
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text('Update',
                          style: TextStyle(
                            fontWeight: FontWeight.w600
                          ),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(224, 76, 43, 1)),
                          foregroundColor: MaterialStatePropertyAll(Colors.black)
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),

              ],
            ),
          );
        },

        );


      },
    );
  }


  void _showStepsBS(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height*.9
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height*.7
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: stepsControllerList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 6,horizontal: 14) ,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    //Steps text field
                                    Expanded(
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: stepsControllerList[index],
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color.fromRGBO(246, 242, 242, 1),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color.fromRGBO(246, 242, 242, 1),
                                                  )
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color.fromRGBO(225, 77, 42, 1),
                                                  )
                                              ),
                                              labelText: "Steps",
                                              labelStyle: TextStyle(
                                                  color: Colors.black
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),

                                    //remove step field
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if(stepsControllerList.length != 1){
                                              stepsControllerList[index].clear();

                                              stepsControllerList[index].dispose();
                                              stepsControllerList.removeAt(index);
                                            }

                                          });

                                        },
                                        icon: Icon(Icons.close))
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            print("add field");
                            stepsControllerList.add(TextEditingController());
                            setState(() {

                            });

                          },
                          child: Text("Add Steps")
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel',
                            style: TextStyle(
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Colors.grey.shade100),
                              foregroundColor: MaterialStatePropertyAll(Colors.black),
                              side: MaterialStatePropertyAll(BorderSide(
                                  color: Colors.black
                              ))
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            List<String> tempSteps = List.generate(stepsControllerList.length, (index) => stepsControllerList[index].text);
                            if(tempSteps != widget.recipe.steps){
                              if(tempSteps.isNotEmpty){
                                widget.recipe.steps = tempSteps;
                                await updateRecipe();
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Text('Update',
                            style: TextStyle(
                                fontWeight: FontWeight.w600
                            ),),
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(224, 76, 43, 1)),
                              foregroundColor: MaterialStatePropertyAll(Colors.black)
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      
                    ],
                  ),
                ],
              ),
            ),
          );
        });

      },
    );
  }

}

