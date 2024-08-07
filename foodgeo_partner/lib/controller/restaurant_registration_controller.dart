import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class RegisterControllers {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> registerUser(String gender, File image, String category) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user logged in.");
      }

      // Upload image to Firebase Storage
      String imageUrl = await _uploadImage(user.uid, image);

      final userData = {
        'name': nameController.text,
        'address': addressController.text,
        'gender': gender,
        'ownerName': ownerNameController.text,
        'location': locationController.text,
        'description': descriptionController.text,
        'category': category,
        'imageUrl': imageUrl,
        "restaurant id": user.uid,
        'verification': false,
      };
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(user.uid)
          .set(userData);
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
}
