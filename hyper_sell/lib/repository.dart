import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hyper_sell/models/product_model.dart';

class Repository {
  final _db = FirebaseFirestore.instance;

  Future<List<Product>> getProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("product").get();
    return snapshot.docs
        .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
  Future<List<dynamic>> getCategories() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("categories").get();
    return snapshot.docs
        .first['categories'];
  }
}
