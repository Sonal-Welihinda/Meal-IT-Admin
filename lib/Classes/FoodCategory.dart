import 'package:cloud_firestore/cloud_firestore.dart';

class FoodCategory{
  late String categoryName;
  late String docID;

  FoodCategory.name({this.categoryName = '', this.docID = ''});

  Map<String , dynamic> toJson(){
    print(categoryName);
    return {
      'FoodCategoryName': categoryName,
    };
  }

  factory FoodCategory.fromSnapshot(DocumentSnapshot snapshot){
    return FoodCategory.name(
      categoryName: snapshot.get("FoodCategoryName"),
      docID: snapshot.id,
    );
  }

}