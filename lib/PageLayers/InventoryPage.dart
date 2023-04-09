import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:meal_it_admin/Classes/BL.dart';
import 'package:meal_it_admin/Classes/FoodCategory.dart';
import 'package:meal_it_admin/PageLayers/ProductAdd.dart';
import 'package:meal_it_admin/view_models/CategoryCard.dart';
import 'package:meal_it_admin/view_models/ItemCard.dart';
import 'package:meal_it_admin/view_models/ItemSupriceCard.dart';

class InventoryPage extends StatefulWidget {
  late GlobalKey<ScaffoldState> sacffoldKey = GlobalKey<ScaffoldState>();

  InventoryPage({Key? key, required this.sacffoldKey}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  bool IsCategories = false;
  final TextEditingController _categoryController = TextEditingController();

  ValueNotifier<bool> isSpeedDialOpen = ValueNotifier(false);
  final BusinessLayer _businessL = BusinessLayer();
  String inputValue="";

  // List inventoryList = <Widget>[ItemCard(), CategoryCard() ,ItemSurpriseCard()];
  List<CategoryCard> categoryList = [];
  List<ItemCard> itemList = [ItemCard()];
  List<ItemSurpriseCard> itemSurpriseList = [ItemSurpriseCard()];

  List speedDialList = [];

  int currentList = 0;

  Future<void> getFoodCategories() async {
    List<FoodCategory> foodcategories = await _businessL.getAllFoodCategories();
    categoryList.clear();
    for (var element in foodcategories) {
      categoryList.add(CategoryCard(category: element,));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    speedDialList = [
      SpeedDialChild(
          label: "Food Categories",
          child: IconButton(
            icon: Icon(Icons.category),

            onPressed: () {
              setState(() {
                currentList =1;
                // IsCategories = true;
                isSpeedDialOpen.value = false;
              });

            },
          )
      ),
      SpeedDialChild(
          label: "Products",
          child: IconButton(
            icon: Icon(Icons.inventory),

            onPressed: () {
              setState(() {
                currentList =0;
                // IsCategories = false;
                isSpeedDialOpen.value = false;
              });

            },
          )
      ),
      SpeedDialChild(
          label: "Suprices",
          child: IconButton(
            icon: Icon(Icons.inventory),

            onPressed: () {
              setState(() {
                currentList =2;
                // IsCategories = false;
                isSpeedDialOpen.value = false;
              });

            },
          )
      ),
      SpeedDialChild(
          label: "Add Food Category",
          child: IconButton(
            icon: Icon(Icons.food_bank),
            onPressed: () {
              openDialog();

              setState(() {
                isSpeedDialOpen.value = false;
              });

            },
          )
      ),
      SpeedDialChild(
          label: "Food Items",
          child: IconButton(
            icon: Icon(Icons.food_bank),
            onPressed: () {
              setState(() {
                isSpeedDialOpen.value = false;
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductAdd(),));
              });

            },
          )
      ),
      SpeedDialChild(
          label: "Add Food suprices",
          child: IconButton(
            icon: Icon(Icons.food_bank),
            onPressed: () {
              openDialog();

              setState(() {
                isSpeedDialOpen.value = false;
              });

            },
          )
      )
    ];

    getFoodCategories();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed:() {
                    widget.sacffoldKey.currentState?.openDrawer();
                  },
                ),

                Text("Inventory",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(42, 107, 225, 1),
                    fontWeight: FontWeight.bold,

                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: TextStyle(
                  color: Colors.black
                ),
                // onChanged: (value) => filterItems(value),
                decoration: InputDecoration(

                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 3,
                      style: BorderStyle.solid,
                      color: Color.fromRGBO(255, 112, 80, 1),
                    )
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(242, 247, 255, 1),
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Color.fromRGBO(255, 112, 80, 1),
                  enabledBorder: UnderlineInputBorder(

                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 3,
                      style: BorderStyle.solid,
                        color: Color.fromRGBO(233, 202, 195, 1),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: currentList == 0 ? itemList.length:(currentList ==1 ? categoryList.length : itemSurpriseList.length),
                itemBuilder: (context, index) {
                  return currentList == 0 ? itemList[index]:(currentList ==1 ? categoryList[index] : itemSurpriseList[index]) ;
                },
              ),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          openCloseDial: isSpeedDialOpen,
          spacing: 10,
          spaceBetweenChildren: 11,
          icon: Icons.inventory_2,
          backgroundColor: Color.fromRGBO(225, 77, 42, 1),
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          children: [
            currentList ==0 ? speedDialList[0]:(currentList==1 ? speedDialList[1]: speedDialList[0]),
            currentList ==0 ? speedDialList[2]:(currentList==1 ? speedDialList[2]: speedDialList[1]),
            currentList ==0 ? speedDialList[4]:(currentList==1 ? speedDialList[3]: speedDialList[5]),

            // !IsCategories ? SpeedDialChild(
            //     label: "Food Categories",
            //     child: IconButton(
            //       icon: Icon(Icons.category),
            //
            //       onPressed: () {
            //         setState(() {
            //           IsCategories = true;
            //           isSpeedDialOpen.value = false;
            //         });
            //
            //       },
            //     )
            // ) : SpeedDialChild(
            //     label: "Products",
            //     child: IconButton(
            //       icon: Icon(Icons.inventory),
            //
            //       onPressed: () {
            //         setState(() {
            //           IsCategories = false;
            //           isSpeedDialOpen.value = false;
            //         });
            //
            //       },
            //     )
            // ),

            // !IsCategories ? SpeedDialChild(
            //     label: "Food Items",
            //     child: IconButton(
            //       icon: Icon(Icons.food_bank),
            //       onPressed: () {
            //         setState(() {
            //           isSpeedDialOpen.value = false;
            //           Navigator.push(context, MaterialPageRoute(builder: (context) => ProductAdd(),));
            //         });
            //
            //       },
            //     )
            // ) : SpeedDialChild(
            //     label: "Add Food Category",
            //     child: IconButton(
            //       icon: Icon(Icons.food_bank),
            //       onPressed: () {
            //         openDialog();
            //
            //         setState(() {
            //           isSpeedDialOpen.value = false;
            //         });
            //
            //       },
            //     )
            // ),
          ],
        ),
      ),
    );
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(247, 249, 254, 1),
            borderRadius: BorderRadius.circular(20),

          ),
          width: double.infinity,
          padding: EdgeInsets.only(left: 20,right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20,bottom: 20),
                child: Text("Create food category",
                  
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color.fromRGBO(42, 107, 225, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),

              TextField(
                controller: _categoryController,
                onChanged: (value) {
                  inputValue = value;
                },
                style: TextStyle(
                    color: Colors.black
                ),
                decoration: InputDecoration(
                  fillColor: Color.fromRGBO(228, 228, 228, 1),
                  filled: true,
                  labelText: "Category name",
                  labelStyle: TextStyle(
                    color: Colors.black
                  ),

                  prefixIcon: Icon(Icons.category,color: Color.fromRGBO(224, 76, 43, 1)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade100
                    )
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade100
                    )
                  ),




                ),

              ),

              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20,bottom: 10),
                    child: TextButton(
                      onPressed: () async {
                        if(_categoryController.text.trim().isEmpty){
                          return;
                        }
                        String result = await _businessL.createFoodCategory(_categoryController.text);

                        if(result=="Success"){
                          SnackBar(
                            content: Text('Food category added'),
                          );

                          Navigator.pop(context);
                        }else{
                          SnackBar(
                            content: Text('something went wrong while adding food category'),
                          );
                        }



                      },
                      style: ButtonStyle(
                        padding: MaterialStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 10,horizontal: 14)
                        ),
                        backgroundColor: MaterialStatePropertyAll(
                            Colors.black
                        ),

                        foregroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(224, 76, 43, 1)
                        ),

                      ),
                      child: Text("Create Category",
                        style: TextStyle(

                          fontSize: 16
                        ),
                      )
                    ),
                  ),
                ],
              )

            ],
          ),
        ),

      )
  );
}
