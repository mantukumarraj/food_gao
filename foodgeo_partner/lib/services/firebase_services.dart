// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//
// class FirebaseService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//
//   Future<User?> registerUser(String email, String password, String name, String address, String gender, File image) async {
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
//       print("Registration failed with error: $e");
//       throw e;
//     }
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
//       print("Image upload failed with error: $e");
//       throw e;
//     }
//   }
// }
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Email/Password user registration
  Future<User?> registerUser(String email, String password, String name, String address, String gender, File image) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        String uid = user.uid;
        String imageUrl = await _uploadImage(uid, image);

        await _firestore.collection('users').doc(uid).set({
          'name': name,
          'address': address,
          'email': email,
          'gender': gender,
          'imageUrl': imageUrl,
          'uid': uid,
        });

        return user;
      }
    } catch (e) {
      print("Registration failed with error: $e");
      throw e;
    }
    return null;
  }

  Future<String> _uploadImage(String uid, File image) async {
    try {
      Reference storageRef = _storage.ref().child('user_images/$uid');
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print("Image upload failed with error: $e");
      throw e;
    }
  }
}
