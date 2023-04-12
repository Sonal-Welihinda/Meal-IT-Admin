import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/BL.dart';
import 'package:meal_it_admin/Classes/Recipe.dart';
import 'package:meal_it_admin/PageLayers/RecipeAdd.dart';
import 'package:meal_it_admin/PageLayers/RecipeUpdate.dart';

class RecipePage extends StatefulWidget {

  GlobalKey<ScaffoldState> homeScaffoldState = GlobalKey<ScaffoldState>();

  RecipePage({Key? key,required this.homeScaffoldState}) : super(key: key);


  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {

  List<Recipe> recipeList =[];
  BusinessLayer _businessL = BusinessLayer();

  Future<void> getRecipe() async {
    recipeList.clear();
    recipeList = await _businessL.getAllRecipe();

    // recipeList.forEach((element) {print(element.recipeName);});
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                IconButton(
                    onPressed: () {
                      widget.homeScaffoldState.currentState?.openDrawer();
                    },
                    icon: Icon(Icons.menu)
                ),
                SizedBox(width: 1),
                Text(
                  'Recipe',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),

              ],
            ),


            SizedBox(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Color.fromRGBO(255, 112, 80, 1),
                  filled: true,
                  fillColor: Color.fromRGBO(242, 247, 255, 1),

                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 215, 206, 1),
                      width: 2
                    )
                  ),

                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 112, 80, 1),
                        width: 3
                      )
                  )

                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  getRecipe();
                },
                child: ListView.builder(
                  itemCount: recipeList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecipeUpdate(recipe:recipeList[index],)
                            )
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromRGBO(249, 249, 249, 1),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                        padding: EdgeInsets.only(top:8, bottom:4,left: 8,right: 10),
                        height: 120,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[300],
                              ),
                              // Replace this Image.asset with your image
                              child: Image.asset('assets/Images/dog.jpg'),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipeList[index].recipeName,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    recipeList[index].recipeDescription,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 16,

                                    ),
                                  ),
                                  Expanded(child: SizedBox(width: 1,)),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.timer,color: Color.fromRGBO(255, 112, 80, 1),),
                                        Text(recipeList[index].time),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeAdd(),));
          },
          child: Icon(Icons.add),
        ),


      ),
    );
  }
}
