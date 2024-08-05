// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class FirebaseServiceRestaurant {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<List<Map<String, dynamic>>> getUserRestaurants() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       throw Exception("No user logged in.");
//     }
//
//     final querySnapshot = await _firestore
//         .collection('restaurants')
//         .where('restaurantid', isEqualTo: user.uid)
//         .get();
//
//     final restaurants = querySnapshot.docs.map((doc) => {
//       ...doc.data(),
//       'id': doc.id, // Include document ID
//     }).toList();
//     return restaurants;
//   }
// }
