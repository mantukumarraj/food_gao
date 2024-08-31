import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderProviderGet with ChangeNotifier {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get orders => _orders;
  bool get isLoading => _isLoading;

  String? r_restaurant_Id;

  // Fetch orders for the current restaurant
  Future<void> getOrderData() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firebase.collection("orders").get();
      _orders = snapshot.docs
          .map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        // Filter orders based on the restaurant ID
        if (r_restaurant_Id == data['restaurantId']) {
          return data;
        }
        return null;
      })
          .where((order) => order != null)
          .cast<Map<String, dynamic>>()
          .toList();
    } catch (e) {
      print('Error fetching orders: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch the current restaurant ID from products
  Future<void> getOrderProduct() async {
    try {
      QuerySnapshot snapshot = await _firebase.collection("products").get();
      if (snapshot.docs.isNotEmpty) {
        r_restaurant_Id = (snapshot.docs.first.data() as Map<String, dynamic>)['restaurantId'];
      } else {
        r_restaurant_Id = null; // Handle case where no products are found
      }
    } catch (e) {
      print('Error fetching restaurant ID: $e');
    }
  }

}