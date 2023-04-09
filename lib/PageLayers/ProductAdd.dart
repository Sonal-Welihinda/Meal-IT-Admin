import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({Key? key}) : super(key: key);

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*.35,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Icon(Icons.image, size: 64),
                ),
                SizedBox(width: 16),


                Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 10,left: 20,right: 20),
                  child: TextField(
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


                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: TextField(
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
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: DropdownSearch<String>(

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
                    items: ['Type 1', 'Type 2', 'Type 3'],

                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        style: TextStyle(
                        ),

                      ),
                      itemBuilder: (context, item, isSelected) {
                        return ListTile(
                          title: Text(item),
                        );
                      }
                    ),


                    onChanged: (value) {
                      print(value);
                    },
                    selectedItem: 'Type 1',

                  ),
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: DropdownSearch<String>(

                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromRGBO(246, 242, 242, 1),
                            prefixIconColor: Color.fromRGBO(224, 76, 43, 1),
                            prefixIcon: Icon(Icons.search),
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
                    items: ['Type 1', 'Type 2', 'Type 3'],

                    popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          style: TextStyle(
                          ),

                        ),
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Text(item),
                          );
                        }
                    ),


                    onChanged: (value) {
                      print(value);
                    },
                    selectedItem: 'Type 1',

                  ),
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: TextField(
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
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: TextField(
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
                  ),
                ),


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
                    onPressed: () {
                      // Add product logic
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
