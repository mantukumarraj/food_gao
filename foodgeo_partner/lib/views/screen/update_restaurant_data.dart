import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterControllers {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to get the list of restaurants associated with the user
  Future<List<Map<String, dynamic>>> getUserRestaurants() async {
    // Replace 'restaurants' with the actual collection name
    final QuerySnapshot snapshot = await _firestore.collection('restaurants').get();

    return snapshot.docs.map((doc) => {
      'id': doc.id,
      'name': doc['name'],
      'ownerName': doc['ownerName'],
      'address': doc['address'],
      'location': doc['location'],
      'category': doc['category'],
      'gender': doc['gender'],
      'verification': doc['verification'],
      'imageUrl': doc['imageUrl'],
    }).toList();
  }

  // Function to update the restaurant data
  Future<void> updateRestaurantData(String restaurantId, Map<String, dynamic> data) async {
    try {
      // Replace 'restaurants' with the actual collection name
      await _firestore.collection('restaurants').doc(restaurantId).update(data);
    } catch (e) {
      throw Exception('Failed to update restaurant: $e');
    }
  }
}
