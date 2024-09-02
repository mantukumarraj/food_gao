import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisterFirebaseProvider with ChangeNotifier {
  Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      final Reference storageRef = FirebaseStorage.instance.ref();
      final Reference imageRef = storageRef.child('partner_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await imageRef.putFile(imageFile);
      final String imageUrl = await imageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<void> registerUser({
    required String name,
    required String age,
    required String gender,
    required String address,
    required String phoneNumber,
    required File? imageFile,
  }) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      String imageUrl = '';
      if (imageFile != null) {
        imageUrl = await uploadImageToFirebaseStorage(imageFile);
      }

      await FirebaseFirestore.instance.collection('partners').doc(user.uid).set({
        'partnerId': user.uid,
        'name': name.trim(),
        'phone': phoneNumber,
        'gender': gender,
        'age': age.trim(),
        'address': address.trim(),
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print('Error registering user: $e');
      throw e;
    }
  }
}