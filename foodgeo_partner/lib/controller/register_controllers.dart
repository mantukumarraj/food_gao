// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//
// class RegistrationController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   Future<User?> registerUser(String gender, File image) async {
//     String name = nameController.text.trim();
//     String address = addressController.text.trim();
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();
//
//     if (name.isEmpty || address.isEmpty || email.isEmpty || password.isEmpty) {
//       throw Exception("All fields are required.");
//     }
//
//     try {
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       User? user = userCredential.user;
//
//       if (user != null) {
//         String uid = user.uid;
//         String imageUrl = await _uploadImage(uid, image);
//
//         await _firestore.collection('users').doc(uid).set({
//           'name': name,
//           'address': address,
//           'email': email,
//           'gender': gender,
//           'imageUrl': imageUrl,
//           'uid': uid,
//         });
//
//         return user;
//       }
//     } catch (e) {
//       throw Exception("Registration failed with error: $e");
//     }
//
//     return null;
//   }
//
//   Future<String> _uploadImage(String uid, File image) async {
//     try {
//       Reference storageRef = _storage.ref().child('user_images/$uid');
//       UploadTask uploadTask = storageRef.putFile(image);
//       TaskSnapshot taskSnapshot = await uploadTask;
//       return await taskSnapshot.ref.getDownloadURL();
//     } catch (e) {
//       throw Exception("Image upload failed with error: $e");
//     }
//   }
//
//   void dispose() {
//     nameController.dispose();
//     addressController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//   }
// }