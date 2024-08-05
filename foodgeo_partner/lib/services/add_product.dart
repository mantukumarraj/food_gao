import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServiceRestaurant {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> _uploadImage(File image, String userId) async {
    try {
      final storageRef = _storage.ref();
      final imageRef = storageRef.child('restaurants/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await imageRef.putFile(image);
      return await imageRef.getDownloadURL();
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  Future<void> registerRestaurant({
    required String restaurantName,
    required String location,
    required String ownerName,
    required String pincode,
    required File image,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user signed in');
    }

    try {
      final imageUrl = await _uploadImage(image, user.uid);
      final restaurantData = {
        'restaurantName': restaurantName,
        'location': location,
        'ownerName': ownerName,
        'pincode': pincode,
        'imageUrl': imageUrl,
        'userId': user.uid,
      };
      await _firestore.collection('restaurants').doc(user.uid).set(restaurantData);
    } catch (e) {
      throw Exception('Restaurant registration failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserRestaurants() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user signed in');
    }

    try {
      final querySnapshot = await _firestore
          .collection('restaurants')
          .where('userId', isEqualTo: user.uid)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch restaurants: $e');
    }
  }
}
