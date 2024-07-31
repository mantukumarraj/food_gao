import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServiceRestaurant {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> uploadImageToFirebase(File image, String uid) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance.ref().child('restaurants/$uid/$fileName');
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> registerRestaurant({
    required String restaurantName,
    required String location,
    required String ownerName,
    required String pincode,
    required File image,
  }) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      String? imageUrl = await uploadImageToFirebase(image, uid);

      if (imageUrl != null) {
        await _firestore.collection('restaurants user').doc(uid).set({
          'restaurantName': restaurantName,
          'location': location,
          'ownerName': ownerName,
          'pincode': pincode,
          'imageUrl': imageUrl,
          'uid': uid,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    }
  }
}
