import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final List<String> _products = [];

  List<String> get products => _products;

  void addProduct(String product) {
    _products.add(product);
    notifyListeners();
  }
}
