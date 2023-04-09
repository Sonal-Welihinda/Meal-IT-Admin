import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/IngredientItem.dart';

class RecipeAdd extends StatefulWidget {
  const RecipeAdd({Key? key}) : super(key: key);

  @override
  State<RecipeAdd> createState() => _RecipeAddState();
}

class _RecipeAddState extends State<RecipeAdd> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  late List<IngredientItem> ingredientList = [IngredientItem.name(name: TextEditingController(), amount: TextEditingController())];

  late List stepsList = [TextEditingController()];

  int _currentPage = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  void createRecipe(){
    String name = _nameController.text;
    String description = _descriptionController.text;
    String type = _typeController.text;
    String time = _timeController.text;



  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages =[
      //First page - recipe info
      Container(
        padding: EdgeInsets.only(top: 30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

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
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.restaurant_menu),
                  prefixIconColor: Color.fromRGBO(225, 77, 42, 1),
                  filled: true,
                  fillColor: Color.fromRGBO(246, 242, 242, 1),
                  labelText: 'Recipe type',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter recipe type';
                  }
                  return null;
                },
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
            ],
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
                itemCount: stepsList.length,
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
                                  controller: stepsList[index],
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
                                  if(stepsList.length != 1){
                                    stepsList[index].name.clear();
                                    stepsList[index].amount.clear();

                                    stepsList[index].name.dispose();
                                    stepsList[index].amount.dispose();
                                    stepsList.removeAt(index);
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
      ),

    ];


    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                child: Icon(
                  Icons.image,
                  size: 80,
                  color: Colors.grey[400],
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
                    _currentPage > 0
                        ? ElevatedButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text('Previous'),
                    )
                        : Container(),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage == _pages.length - 1) {
                          // submit form
                        } else {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(_currentPage == _pages.length - 1 ? 'Submit' : 'Next'),
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
