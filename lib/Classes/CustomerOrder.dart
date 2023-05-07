import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meal_it_admin/Classes/CartModel.dart';

class CustomerOrder {
  late String orderID;
  late String customerName;
  late String customerEmail;
  late String customerNumber;
  late CartModel orderItems;
  late String address;
  late GeoPoint location;
  late DateTime orderPlaceTime;
  late String status;
  late double deliveryFee;
  late String deliveryType;
  late String deliveryTimeID;
  late String customerID;
  late String? paymentID;
  late String? paymentMethod;
  late String orderBranchID;
  late String? driverID;
  late String? driverName;

  CustomerOrder.empty();

  Map<String, dynamic> toJson() => {
    'customerName': customerName,
    'customerEmail': customerEmail,
    'customerNumber': customerNumber,
    'orderItems': orderItems.toJson(),
    'address': address,
    'location': location,
    'orderPlaceTime': Timestamp.fromDate(orderPlaceTime),
    'status': status,
    'deliveryFee': deliveryFee,
    'deliveryType': deliveryType,
    if(deliveryType != "Standard delivery")
      'deliveryTimeID': deliveryTimeID,
    'customerID': customerID,
    if(paymentMethod=="gateway")
      'paymentID': paymentID,
    'OrderBranchID':orderBranchID,
    'driverID':driverID,
    'driverName':driverName

  };

  static CustomerOrder fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    print(snapshot);
    return CustomerOrder.empty()
      ..orderID = snapshot.id
      ..customerName = data['customerName']
      ..customerEmail = data['customerEmail']
      ..customerNumber = data['customerNumber']
      ..orderItems = CartModel.fromSnapshot3(snapshot)
      ..address = data['address']
      ..location = data['location']
      ..orderPlaceTime = (data['orderPlaceTime'] as Timestamp).toDate()
      ..status = data['status']
      ..deliveryFee = data['deliveryFee']
      ..deliveryType = data['deliveryType']
      ..deliveryTimeID =data['deliveryType']!="Standard delivery" ? data['deliveryTimeID']:""
      ..customerID = data['customerID']
      ..paymentID = data['paymentID']
      ..orderBranchID = data['OrderBranchID'];
  }
}
