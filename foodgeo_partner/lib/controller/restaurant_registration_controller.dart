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

  String category = ''; // Use a variable to hold the category

  Future<void> registerUser(String gender, File image) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user logged in.");
      }

      // Generate a unique UUID for the restaurant
      final String restaurantId = Uuid().v4();

      // Upload image to Firebase Storage with a unique name
      String imageUrl = await _uploadImage(restaurantId, image);

      // Save restaurant data to Firestore
      final userData = {
        'name': nameController.text,
        'address': addressController.text,
        'gender': gender,
        'ownerName': ownerNameController.text,
        'location': locationController.text,
        'category': category, // Use category variable
        'imageUrl': imageUrl,
        'restaurantid': restaurantId, // Store the generated restaurant ID
        'verification': false,
        'userId': user.uid, // Store the user ID associated with the restaurant
      };

      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId) // Use the generated restaurant ID as the document ID
          .set(userData); // Use set() to create a new document with the specified ID
    } catch (e) {
      throw Exception("Failed to register user: ${e.toString()}");
    }
  }

  Future<String> _uploadImage(String restaurantId, File image) async {
    try {
      // Use the restaurantId in the file name to ensure each image is stored separately
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

  Future<List<Map<String, dynamic>>> getUserRestaurants() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user logged in.");
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .where('userId', isEqualTo: user.uid) // Filter based on user ID
        .get();

    final restaurants = querySnapshot.docs.map((doc) => {
      ...doc.data(),
      'id': doc.id, // Include document ID
    }).toList();
    return restaurants;
  }
}
