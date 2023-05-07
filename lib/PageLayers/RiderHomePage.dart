import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/BL.dart';
import 'package:meal_it_admin/Classes/CustomerOrder.dart';
import 'package:meal_it_admin/Classes/Rider.dart';
import 'package:meal_it_admin/view_models/CartCard.dart';

class RiderHomePage extends StatefulWidget {
  const RiderHomePage({Key? key}) : super(key: key);

  @override
  State<RiderHomePage> createState() => _RiderHomePageState();
}

class _RiderHomePageState extends State<RiderHomePage> {
  BusinessLayer _businessL = BusinessLayer();

  String username = ""; // replace with actual username
  String customerName= ""; // replace with actual customer name
  String customerPhoneNumber= ""; // replace with actual customer phone number
  String customerAddress= ""; // replace with actual customer address

  late int currentIndex;
  late List<CustomerOrder> ridersOrders;
  Rider? rider ;

  CustomerOrder? currentOrder;



  Future<void> loadOrderData() async {
    await _businessL.assignOrderToRiders();
    ridersOrders = await _businessL.getOrderByDriverID();

    rider = await _businessL.getLoginRider();
    setState(() {

    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadOrderData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*.12,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(

                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    // color: Color.fromRGBO(225, 77, 42, 1),
                    child: Text(
                      'Hello, ${rider!=null ? rider!.name :""}',
                      style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                  ),

                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: MediaQuery.of(context).size.height*.03,
                    backgroundImage: rider!= null ? Image.network(rider!.img,
                      fit: BoxFit.cover,

                    ).image:Image.asset("assets/Images/backgroundM.jpg").image,
                  )
                ],
              ),
            ),
            currentOrder!=null ? Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer Details:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Name: $customerName',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Phone Number: $customerPhoneNumber',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Address: $customerAddress',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ) : Expanded(child: Container(
              color: Color.fromRGBO(255, 209, 201, 1.0),
              child: Center(child: Text("No delivery to be complete",
                style: TextStyle(
                  fontSize: 24,

                ),

              ),),
            )),

            // order items
            if(currentOrder!=null)
              Expanded(
              child: ListView.builder(
                itemCount: currentOrder!.orderItems.surpriseList.length+currentOrder!.orderItems.foodProduct.length+currentOrder!.orderItems.colabFoodProduct.length, // replace with actual number of orders
                itemBuilder: (context, index) {
                  if (index < currentOrder!.orderItems.surpriseList.length) {
                    // build cart card for surpriseList[index]
                    return CartCard(surprisePack: currentOrder!.orderItems.surpriseList[index]);
                  } else if (index < currentOrder!.orderItems.surpriseList.length + currentOrder!.orderItems.foodProduct.length) {
                    // build cart card for foodProduct[index - surpriseList.length]
                    return CartCard(foodProduct: currentOrder!.orderItems.foodProduct[index - currentOrder!.orderItems.surpriseList.length]);
                  } else{
                    return CartCard(colabFoodProduct: currentOrder!.orderItems.colabFoodProduct[index - currentOrder!.orderItems.surpriseList.length - currentOrder!.orderItems.foodProduct.length]);
                  }
                },
              ),
            ),

            if(currentOrder!=null)
            Container(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  // logic for going to next page
                },
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

