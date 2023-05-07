import 'package:cloud_firestore/cloud_firestore.dart';

class Branch{
  late String _uid;
  late String _name;
  late String _phoneNumber;
  late String _address;
  late double _longitude;
  late double _latitude;


  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get phoneNumber => _phoneNumber;

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  Branch({ uID, required String name,required String address,required String phoneNumber,required double longitude,required double latitude}): _name = name,_phoneNumber= phoneNumber,_address = address,
        _longitude = longitude, _latitude = latitude, _uid  = uID;

  Branch.createOne(this._name,this._phoneNumber,this._address,this._longitude,
      this._latitude);


  Map<String , dynamic> toJson(){
    return {
      'Name': _name,
      'address': _address,
      'phoneNumber': _phoneNumber,
      'longitude': _longitude,
      'latitude': _latitude,
    };
  }

  factory Branch.fromSnapshot(DocumentSnapshot snapshot){
    return Branch(
      uID: snapshot.id,
      name: snapshot.get("Name"),
      address: snapshot.get("address"),
      phoneNumber: snapshot.get("phoneNumber"),
      longitude: snapshot.get("longitude") ,
      latitude: snapshot.get("latitude"),
    );
  }


}