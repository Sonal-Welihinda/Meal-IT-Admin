
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_it_admin/Classes/User.dart';

class Rider extends User{
  late String phoneNumber,gender,name,accountType,branchID,address;
  late String img;


  Rider ({required this.name,required this.gender,required this.phoneNumber,required this.address,
    required this.accountType,required this.branchID,required this.img, required email}) :super(email);

  Rider.createOne(email) : super(email);

  Map<String , dynamic> toJson(){
    return {
      'Name': name,
      'Email': email,
      'Address': address,
      'PhoneNumber': phoneNumber,
      'Gender': gender,
      'AccountType': accountType,
      'BranchID': branchID,
      'ImageUrl': img,


    };
  }

  factory Rider.fromSnapshot(DocumentSnapshot snapshot){
    return Rider(
        email: snapshot.get("Email"),
        name: snapshot.get("Name"),
        address: snapshot.get("Address"),
        phoneNumber: snapshot.get("PhoneNumber"),
        accountType: snapshot.get("AccountType"),
        gender : snapshot.get("Gender") ,
        branchID: snapshot.get("BranchID"),
        img: snapshot.get("ImageUrl")
    );
  }

}