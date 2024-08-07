import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UpdateController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future<Map<String, dynamic>> getCurrentUserData() async {
    User? user = _auth.currentUser;
    if (user == null) throw Exception("No user logged in.");

    DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
    var data = doc.data() as Map<String, dynamic>;

    return {
      'name': data['name'],
      'address': data['address'],
      'gender': data['gender'],
      'image': data['imageUrl'] != null ? await _downloadImage(data['imageUrl']) : null,
    };
  }

  Future<File?> _downloadImage(String imageUrl) async {
    // If you need to download the image, implement the logic here
    // For now, this method returns null as image validation is removed
    return null;
  }

  Future<void> updateUserProfile(
      String name,
      String address,
      String gender,
      File? image, // Nullable since image might not be provided
      ) async {
    User? user = _auth.currentUser;
    if (user == null) throw Exception("No user logged in.");

    String imageUrl = '';
    if (image != null) {
      TaskSnapshot uploadTask = await _storage.ref('user_images/${user.uid}').putFile(image);
      imageUrl = await uploadTask.ref.getDownloadURL();
    }

    await _firestore.collection('users').doc(user.uid).update({
      'name': name,
      'address': address,
      'gender': gender,
      'imageUrl': imageUrl.isNotEmpty ? imageUrl : null, // Only set imageUrl if it's not empty
    });
  }
}
