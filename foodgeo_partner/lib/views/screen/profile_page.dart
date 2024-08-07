import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgeo_partner/home_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Profile'),
        backgroundColor: Colors.orange, // Set AppBar color to orange
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No profile data available.'));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: SizedBox(
                  width: 300, // Adjust card width
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(data['imageUrl'] ?? ''),
                          backgroundColor: Colors.grey[200],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Name: ${data['name'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Address: ${data['address'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Gender: ${data['gender'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        if (data.containsKey('ownerName')) ...[
                          Divider(thickness: 2),
                          SizedBox(height: 16),
                          Text(
                            'Owner Name: ${data['ownerName'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Location: ${data['location'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Description: ${data['description'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Category: ${data['category'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                            },
                            child: Text("Go Back!"),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<DocumentSnapshot> _fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user logged in.");
    }

    DocumentReference docRef;
    if (user.email != null && user.email!.contains('@restaurant.com')) {
      // For restaurant users
      docRef = FirebaseFirestore.instance.collection('restaurants').doc(user.uid);
    } else {
      // For regular users
      docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    }

    return docRef.get();
  }
}
