import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screen/Profile.dart';
import '../screen/RestaurantListScreen.dart';
import '../screen/phone_verification_screen.dart';
import '../screen/restaurant_register_screen.dart';
import '../screen/upload_screen.dart';
import '../screen/verfication_screen.dart';


class DrawerW extends StatefulWidget {
  const DrawerW({super.key});

  @override
  State<DrawerW> createState() => _DrawerWState();
}

class _DrawerWState extends State<DrawerW> {
  String? name;
  String? address;
  String? imageUrl;
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      DocumentSnapshot userDoc = await _fetchUserProfile();

      setState(() {
        var data = userDoc.data() as Map<String, dynamic>?;

        name = data?['name'] ?? 'No Name';
        address = data?['address'] ?? 'No Address';
        imageUrl = data?['imageUrl'];
        isVerified = data?['verification'] ?? false;
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<DocumentSnapshot> _fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user logged in.");
    }

    DocumentReference docRef;
    if (user.email != null && user.email!.contains('@restaurant.com')) {
      // For restaurant users
      docRef =
          FirebaseFirestore.instance.collection('restaurants').doc(user.uid);
    } else {
      // For regular users
      docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    }

    DocumentSnapshot doc = await docRef.get();
    print("Fetched document data: ${doc.data()}");

    return doc;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        imageUrl != null ? NetworkImage(imageUrl!) : null,
                    child: imageUrl == null
                        ? Icon(Icons.person, size: 40, color: Colors.orange)
                        : null,
                  ),
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => UpdatePage()));
                  },
                ),
                SizedBox(height: 10),
                Text(
                  name ?? 'Loading...',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  address ?? 'Loading...',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.orange),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RestaurantListScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.restaurant_menu, color: Colors.orange),
            title: Text('Register Your Restaurant'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RestaurantRegistrationPage()));
            },
          ),
          if (isVerified) // Show Add Product option if verified
            ListTile(
              leading: Icon(Icons.add_box, color: Colors.orange),
              title: Text('Add Product'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProductScreen()));
              },
            ),
          ListTile(
            leading: Icon(Icons.receipt, color: Colors.orange),
            title: Text('Orders'),
            onTap: () {
              // Navigate to Orders
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.orange),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.orange),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RestaurantVerificationScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text('Logout'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                        child: AlertDialog(
                            title: Center(
                                child: Text("Are you sure you want to logout?",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold))),
                            actions: [
                          Center(
                              child: Row(
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PhoneAuth()));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("You have logged out")));
                                  },
                                  child: Text("Ok")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"))
                            ],
                          ))
                        ]));
                  });
            },
          ),
        ],
      ),
    );
  }
}
