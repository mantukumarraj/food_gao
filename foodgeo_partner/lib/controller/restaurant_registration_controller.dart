import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
class RegisterControllers {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController locationlongitudeController = TextEditingController();
  final TextEditingController phonenoController = TextEditingController();
  String category = '';

  // Register a new restaurant
  Future<void> registerUser(String gender, File image) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user logged in.");
      }

      final String restaurantId = Uuid().v4();
      String imageUrl = await _uploadImage(restaurantId, image);

      final userData = {
        'name': nameController.text.trim(),
        'address': addressController.text.trim(),
        'gender': gender,
        'ownerName': ownerNameController.text.trim(),
        'phoneNo': phonenoController.text.trim(),
        'location': locationController.text.trim(),
        'locationlongitude': locationlongitudeController.text.trim(),
        'category': category,
        'imageUrl': imageUrl,
        'restaurantId': restaurantId,
        'verification': false,
        'userId': user.uid,
      };

      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .set(userData);
    } catch (e) {
      throw Exception("Failed to register restaurant: ${e.toString()}");
    }
  }

  // Upload image to Firebase Storage
  Future<String> _uploadImage(String restaurantId, File image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('restaurant_images')
          .child('$restaurantId.jpg');

      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload image: ${e.toString()}");
    }
  }

  // Retrieve restaurants associated with the current user
  Future<List<Map<String, dynamic>>> getUserRestaurants() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user logged in.");
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .where('userId', isEqualTo: user.uid)
        .get();

    final restaurants = querySnapshot.docs.map((doc) => {
      ...doc.data(),
      'id': doc.id,
    }).toList();
    return restaurants;
  }

  // Update existing restaurant details
  Future<void> updateRestaurant({
    required String restaurantId,
    required String name,
    required String address,
    required String ownerName,
    required String phoneNo,
    required String location,
    required String gender,
    required String category,
    File? image,
  }) async {
    try {
      String? imageUrl;
      if (image != null) {
        imageUrl = await _uploadImage(restaurantId, image);
      }

      final updateData = {
        'name': name.trim(),
        'address': address.trim(),
        'gender': gender,
        'ownerName': ownerName.trim(),
        'phoneNo': phoneNo.trim(),
        'location': location.trim(),
        'category': category,
      };

      if (imageUrl != null) {
        updateData['imageUrl'] = imageUrl;
      }

      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .update(updateData);
    } catch (e) {
      throw Exception("Failed to update restaurant: ${e.toString()}");
    }
  }
  Future<void> deleteRestaurant(String restaurantId) async {
    try {
      await _deleteProducts(restaurantId);
      await _deleteRestaurantImage(restaurantId);
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .delete();
      print("Restaurant and its products have been deleted.");
    } catch (e) {
      throw Exception("Failed to delete restaurant: ${e.toString()}");
    }
  }

  Future<void> _deleteProducts(String restaurantId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('restaurantId', isEqualTo: restaurantId)
          .get();

      final batch = FirebaseFirestore.instance.batch();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception("Failed to delete products: ${e.toString()}");
    }
  }
  Future<void> _deleteRestaurantImage(String restaurantId) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('restaurant_images')
          .child('$restaurantId.jpg');

      await ref.delete();
    } catch (e) {
      throw Exception("Failed to delete restaurant image: ${e.toString()}");
    }
  }
}