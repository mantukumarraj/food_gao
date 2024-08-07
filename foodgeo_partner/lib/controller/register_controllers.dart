import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class RegistrationController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future<void> registerUser(String gender, File image,String phoneNumber) async {
    String name = nameController.text.trim();
    String address = addressController.text.trim();

    if (name.isEmpty || address.isEmpty) {
      throw Exception("All fields are required.");
    }

    User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("No user is currently logged in.");
    }

    try {
      String uid = user.uid;
      String imageUrl = await _uploadImage(uid, image);

      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'address': address,
        'gender': gender,
        'imageUrl': imageUrl,
        'uid': uid,
        'phone':phoneNumber
      });
    } catch (e) {
      throw Exception("Registration failed with error: $e");
    }
  }

  Future<String> _uploadImage(String uid, File image) async {
    try {
      Reference storageRef = _storage.ref().child('user_images/$uid');
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Image upload failed with error: $e");
    }
  }

  void dispose() {
    nameController.dispose();
    addressController.dispose();
  }
}
