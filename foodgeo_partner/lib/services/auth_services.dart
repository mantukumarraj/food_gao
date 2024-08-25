import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class AuthService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;







  Future<void> favoriteAdd(String image, String name, String price,String description ,BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('favoriteAdd').add({
          'image': image,
          'name': name,
          'description': description,
          'price': price,
          'userId': user.uid, // Associate item with the current user's UID
          'timestamp': FieldValue.serverTimestamp(),
        });
        print('Product added to cart');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your favorite has been added ',),backgroundColor: Colors.orange,),
        );
      } else {
        print('No user is signed in.');
      }
    } catch (e) {
      print('Failed to add product to cart: $e');
    }
  }

  // saveUserDetails
  Future<void> saveDetails(BuildContext context, String name, String age, String gender, String address, File? image) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User not authenticated');
      }

      String userId = user.uid;
      String phoneNumber = user.phoneNumber ?? '';
      String email = user.email ?? '';

      String? imageUrl;
      if (image != null) {
        final storageRef = FirebaseStorage.instance.ref().child('profileImages/$userId.jpg');
        await storageRef.putFile(image);
        imageUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('usersDetails').doc(userId).set({
        'name': name,
        'phoneNumber': phoneNumber,
        'email': email,
        'age': age,
        'gender': gender,
        'address': address,
        'imageUrl': imageUrl,
        'firstLogin': false, // Mark as not first login
      });

      // sendToPageReplacement(context: context, page: const HomeScreen());
    } catch (e) {
      print('Error saving details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving details: $e'),
        ),
      );
    }
  }



  // fetchUserData









  // userLogout



  // fetch products data from firebase
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('products').get();
      List<Map<String, dynamic>> products = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Handle type conversion for price
        String price;
        final priceValue = data['price'];
        if (priceValue is String) {
          price = priceValue;
        } else if (priceValue is double) {
          price = priceValue.toStringAsFixed(2);  // Convert double to string with 2 decimal places
        } else {
          price = 'N/A';  // Default value if price is neither String nor double
        }

        return {
          'image': data['image'] as String? ?? 'No image',
          'name': data['name'] as String? ?? 'Product Name',
          'description': data['description'] as String? ?? 'Product Description',
          'price': price,
        };
      }).toList();

      print('Total products fetched: ${products.length}');
      return products;
    } catch (e) {
      print('Error fetching products: $e');
      return [];
   }
    }

}