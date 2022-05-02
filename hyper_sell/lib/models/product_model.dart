import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  final String? productCategoryName;
  final String? searchString;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.productCategoryName,
      required this.searchString});


  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": title,
      "description": description,
      "price": price as double,
      "image": imageUrl,
      "category": productCategoryName,
      "search": searchString
    };
  }

  Product.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> map)
      : id = map["id"],
        title = map["name"],
        description = map["description"],
        price = map["price"].toDouble(),
        imageUrl = map["image"],
        productCategoryName = map["category"],
        searchString = map["search"];
}
