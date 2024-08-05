import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgeo_partner/views/screen/home_page.dart';
import 'package:foodgeo_partner/views/screen/phone_verification_screen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';
  String email = '';
  String gender = '';
  String address = '';
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchCurrentUserData();
  }

  Future<void> fetchCurrentUserData() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        name = 'User not logged in';
        email = '';
        gender = '';
        address = '';
        imageUrl = '';
      });
      return;
    }

    // Retrieve user data from Firestore
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users1').doc(user.uid).get();

      if (snapshot.exists) {
        // Access the user data
        Map<String, dynamic> data = snapshot.data()!;

        // Retrieve name, email, gender, address, and imageUrl
        setState(() {
          name = data['userName'];
          email = data['email'];
          gender = data['gender'];
          address = data['address'];
          imageUrl = data['imageUrl'];
        });
      } else {
        setState(() {
          name = 'User document not found';
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
      setState(() {
        name = 'Error fetching user data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        leading: IconButton(

          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 100.0),
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                            child: imageUrl.isEmpty ? Icon(Icons.person, size: 60) : null,
                          ),
                          const SizedBox(height: 20.0),
                          Text('Name: $name', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.cyan)),
                          Text('Email: $email', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.cyan)),
                          Text('Gender: $gender', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.cyan)),
                          Text('Address: $address', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.cyan)),
                          const SizedBox(height: 60.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
