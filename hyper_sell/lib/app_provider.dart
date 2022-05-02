import 'package:flutter/material.dart';
import 'package:hyper_sell/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {

  List<Product> _products = [];
  List<Product> _cartProducts = [];
  List<dynamic> _categories = [];

  /// Getters


  List<Product> get products => _products;
  List<Product> get cartProducts => _cartProducts;
  List<dynamic> get categories => _categories;


  void updateProducts(List<Product> product) {
    _products = product;
    notifyListeners();
  }
  void updateCategories(List<dynamic> categories) {
    _categories = categories;
    notifyListeners();
  }

  void setCartProducts() {
    List<Product> cProd =[];
    SharedPreferences.getInstance().then((value) {
      List<String> _productIDs =
          value.getStringList('products') ?? [];
      for(var pID in _productIDs){
        for(var element in _products){
          if(element.id == pID){
            cProd.add(element);
          }
        }
      }
    });
    _cartProducts = cProd;
    notifyListeners();
  }

  List<Product> getCategoryItems(String category){
   return _products.where((element) => element.productCategoryName == category).toList();
    return [];
  }
}
