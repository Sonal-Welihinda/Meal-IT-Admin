import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_it_admin/Classes/BL.dart';
import 'package:meal_it_admin/Classes/FoodCategory.dart';
import 'package:meal_it_admin/Classes/IngredientItem.dart';
import 'package:meal_it_admin/Classes/Recipe.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';

class RecipeAdd extends StatefulWidget {
  const RecipeAdd({Key? key}) : super(key: key);

  @override
  State<RecipeAdd> createState() => _RecipeAddState();
}

class _RecipeAddState extends State<RecipeAdd> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool formValidated = false;


  final BusinessLayer _businessL = BusinessLayer();

  late List<IngredientItem> ingredientList = [IngredientItem.name(name: TextEditingController(), amount: TextEditingController())];
  late List<TextEditingController> stepsControllerList = [TextEditingController()];

  late List<FoodCategory> foodCategoriesList=[];
  late FoodCategory? selectedFoodType;
  late File? _recipeImage =null;

  late List<Widget> _pages;
  int _currentPage = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllFoodCategories();


  }

  void importFileData() async{
    // void extractZipFileContents(List<int> bytes) {
    //   final archive = ZipDecoder().decodeBytes(bytes);
    //   for (final file in archive) {
    //     if (file.isFile && file.name.endsWith('.csv')) {
    //       final csvBytes = file.content as List<int>;
    //       final csvString = String.fromCharCodes(csvBytes);
    //       final csvLines = csvString.split('\n');
    //       for (final csvLine in csvLines) {
    //         final imageName = csvLine.trim();
    //         final imageFile = archive.files.firstWhere(
    //               (file) => file.isFile && file.name.endsWith(imageName),
    //           orElse: () => null,
    //         );
    //         if (imageFile != null) {
    //           final imageBytes = imageFile.content as List<int>;
    //           // pass imageBytes to a class here
    //         }
    //       }
    //     }
    //   }
    // }

    // var request = http.MultipartRequest('POST', Uri.parse('https://your-upload-url.com'));
    // request.files.add(await http.MultipartFile.fromPath('file', '/path/to/your/zip/file'));
    // var response = await request.send();
    // if (response.statusCode == 200){
    //   extractZipFileContents();
    // }
  }

  Future<void> createRecipe() async {
    if(!formValidated){
      return;
    }

    if(selectedFoodType==null){
      return;
    }

    if(_recipeImage == null){
      return;
    }

    String name = _nameController.text;
    String description = _descriptionController.text;
    String time = _timeController.text;
    int serving = int.parse(_servingsController.text);

    List<String> stepsList = List.generate(stepsControllerList.length, (index) => stepsControllerList[index].text);


    //
    String result = await _businessL.createRecipe(name, description, selectedFoodType!, time, ingredientList, stepsList,serving,_recipeImage);

    if("Success"==result){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Recipe successfully created"),
        ),
      );

      Navigator.pop(context);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong while creating recipe"),
        ),
      );
    }


  }


  Future<void> getAllFoodCategories() async {
    foodCategoriesList = await _businessL.getAllFoodCategories();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    _pages =[
      //First page - recipe info
      Container(
        padding: EdgeInsets.only(top: 30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          importFileData();
                        },
                        child: Icon(Icons.file_open)
                    ),
                  ],
                ),
                //Recipe name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Recipe Name',
                    prefixIcon: Icon(Icons.topic),
                    prefixIconColor: Color.fromRGBO(225, 77, 42, 1),
                    filled: true,
                    fillColor: Color.fromRGBO(246, 242, 242, 1),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter recipe name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Recipe descriptionn
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    prefixIconColor: Color.fromRGBO(225, 77, 42, 1),
                    filled: true,
                    fillColor: Color.fromRGBO(246, 242, 242, 1),
                    labelText: 'Recipe Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter recipe description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                //food category
                DropdownSearch<FoodCategory>(
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
                      hintText: "Select food type",
                      prefixIcon: Icon(Icons.restaurant_menu),
                      prefixIconColor: Color.fromRGBO(225, 77, 42, 1),
                      filled: true,
                      fillColor: Color.fromRGBO(246, 242, 242, 1),
                    ),
                  ),
                  onChanged: (value) {
                    selectedFoodType = value;
                  },
                  // validator: (value) {
                  //   if(value== null || value.categoryName.trim().isEmpty){
                  //     return "Please selected food category";
                  //   }
                  //
                  //   return null;
                  // },
                ),
                SizedBox(height: 16),

                //Recipe time
                TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.timer),
                    prefixIconColor: Color.fromRGBO(225, 77, 42, 1),
                    filled: true,
                    fillColor: Color.fromRGBO(246, 242, 242, 1),
                    labelText: 'Time',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Time that will take to make this recipe';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                //Servings
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _servingsController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.groups),
                    prefixIconColor: Color.fromRGBO(225, 77, 42, 1),
                    filled: true,
                    fillColor: Color.fromRGBO(246, 242, 242, 1),
                    labelText: 'Servings',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter number of servings';
                    }else if(int.parse(value)==0){
                      return "Number of servings can't be 0";
                    }
                    return null;
                  },
                ),


              ],
            ),
          ),
        ),
      ),

      //Ingredients page
      //container
      Container(
        height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //ingredient list
            Container(
              constraints: BoxConstraints(
                maxHeight: 400, // set the maximum height here
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: ingredientList.length,
                itemBuilder: (context, index) {
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

            //Ingredient Add button
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
      ),

      //Steps page
      Container(
        height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: 400, // set the maximum height here
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: stepsControllerList.length,
                itemBuilder: (context, index) {
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
                                    // stepsControllerList[index].clear();

                                    stepsControllerList[index].dispose();
                                    // stepsControllerList[index].dispose();
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
                  setState(() {
                    stepsControllerList.add(TextEditingController());
                  });
                },
                child: Text("Add Steps")
            )

          ],
        ),
      ),

    ];


    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _recipeImage = File(image.path);
                    });
                  }
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[200],
                  ),
                  child: _recipeImage != null
                      ? Image.file(
                    _recipeImage!,
                    fit: BoxFit.cover,
                  )
                      : Icon(
                    Icons.image,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                ),
              ),

              Expanded(
                child: PageView.builder(

                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _pages[index];
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _currentPage > 0 ? Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text('Previous',
                          style: TextStyle(
                          fontSize: 24,
                          // fontWeight: FontWeight.w600,
                        ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.grey.shade100),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              )
                          ),
                          side: MaterialStatePropertyAll(
                            BorderSide(color: Colors.black,),
                          ),
                          foregroundColor: MaterialStatePropertyAll(Colors.black)
                        ),
                      ),
                    )  : Container(),
                    _currentPage > 0 ? SizedBox(width: 10,)  : Container(),
                    Expanded(
                      child: ElevatedButton(
                        
                        onPressed: () {
                          if (_currentPage == _pages.length - 1) {
                            // submit form

                            createRecipe();
                          } else {

                            if(_currentPage==0){
                              formValidated = false;
                              if(_formKey.currentState!.validate()){
                                formValidated = true;
                              }

                            }
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _currentPage > 0 ? (_currentPage == 2 ? Container() : SizedBox(width: 24, ))  : Container(),
                            Text(_currentPage == _pages.length - 1 ? 'Submit' : 'Next',
                              style: TextStyle(
                                fontSize: 24,
                                // fontWeight: FontWeight.w600,

                              ),
                              textAlign: TextAlign.center,
                            ),
                            _currentPage == 2 ? Container() : Icon(Icons.navigate_next,
                              size: 24,
                            )
                          ],
                        ),
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                            )
                          ),
                          backgroundColor: MaterialStatePropertyAll(Colors.black),
                          foregroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(224, 76, 43, 1)
                          )
                        ),

                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );;
  }
}
