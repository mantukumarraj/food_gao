import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterControllers {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String category = '';  // Use a variable to hold the category

  Future<void> registerUser(String gender, File image) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user logged in.");
      }

      // Upload image to Firebase Storage
      String imageUrl = await _uploadImage(user.uid, image);

      // Save restaurant data to Firestore
      final userData = {
        'name': nameController.text,
        'address': addressController.text,
        'gender': gender,
        'ownerName': ownerNameController.text,
        'location': locationController.text,
        'category': category, // Use category variable
        'imageUrl': imageUrl,
        "restaurantid": user.uid, // Change from 'restaurant id' to 'restaurantid' for consistency
        'verification': false,
      };

      await FirebaseFirestore.instance
          .collection('restaurants')
          .add(userData); // Use add() to create a new document with an auto-generated ID
    } catch (e) {
      throw Exception("Failed to register user: ${e.toString()}");
    }
  }

  Future<String> _uploadImage(String userId, File image) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('restaurant_images').child('$userId.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload image: ${e.toString()}");
    }
  }

  Future<List<Map<String, dynamic>>> getUserRestaurants() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user logged in.");
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .where('restaurantid', isEqualTo: user.uid) // Filter based on user ID
        .get();

    final restaurants = querySnapshot.docs.map((doc) => {
      ...doc.data(),
      'id': doc.id, // Include document ID
    }).toList();
    return restaurants;
  }
}
