
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_it_admin/Classes/Admin..dart';
import 'package:meal_it_admin/Classes/Branch.dart';
import 'package:meal_it_admin/Classes/Rider.dart';
import 'package:meal_it_admin/Interfaces/AdminInterface.dart';
import 'package:meal_it_admin/Interfaces/BranchInterface.dart';
import 'package:meal_it_admin/Interfaces/RiderInterface.dart';

class FirebaseDBServices implements BranchInterface,AdminInterface,RiderInterface {

  final userDocRef = FirebaseFirestore.instance.collection('users');
  final branchDocRef = FirebaseFirestore.instance.collection('Meal Ship-Branches');

  @override
  Future<String> createBranch(Branch branch) async {
    try {
      await branchDocRef.add(branch.toJson());
      return "Success";
      print('Data added successfully.');
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }

  }

  @override
  Future<List<Branch>> getAllBranches() async {
    QuerySnapshot querySnapshot = await branchDocRef.get();
    List<Branch> Branches = querySnapshot.docs.map((doc) => Branch.fromSnapshot(doc)).toList();

    return Branches;
  }

  // ADMIN IMPLEMENTS
  @override
  Future<String> createAdmin(Admin admin) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: admin.email,
        password: admin.password,
      );

      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      await userDocRef.doc(uid).set(admin.toJson());
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  @override
  Future<List<Admin>> getAllAdmins() async {
    QuerySnapshot querySnapshot = await userDocRef.where('AccountType', whereIn: ['AdminHQ', 'Branch-Admin']).get();
    List<Admin> Branches = querySnapshot.docs.map((doc) => Admin.fromSnapshot(doc)).toList();

    return Branches;
  }

  @override
  Future<String> LoginAdmin(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential != null) {
       return 'Success';
    } else {
      return 'failed';
    }

  }

  Future<String> getUserType(String? uid) async {

    if(uid == null){
      return "";
    }

    DocumentSnapshot documentSnapshot = await userDocRef.doc(uid).get();
    if (documentSnapshot.exists) {
      Object? data = documentSnapshot.data()!;
      print(data);
      // if (data.containsKey('type')) {
      //
      // }
    }
    return "";
  }

  //Riders

  @override
  Future<String> LoginRider(String email, String password) {
    // TODO: implement LoginRider
    throw UnimplementedError();
  }

  @override
  Future<String> createRiders(Rider rider) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: rider.email,
        password: rider.password,
      );

      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      await userDocRef.doc(uid).set(rider.toJson());
      return "Success";
    } on FirebaseException catch (e){
      print(e);
      return "failed";
    }
  }

  @override
  Future<List<Rider>> getAllRiders() async {
    QuerySnapshot querySnapshot = await userDocRef.where('AccountType', whereIn: ['Rider']).get();
    List<Rider> Riders = querySnapshot.docs.map((doc) => Rider.fromSnapshot(doc)).toList();

    return Riders;

  }


}