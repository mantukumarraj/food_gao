import 'package:flutter/material.dart';
import 'package:foodgeo_partner/views/screen/phone_verification_screen.dart';
import 'package:foodgeo_partner/views/screen/profile_edit_screen.dart';
import 'package:foodgeo_partner/views/screen/restaurant_register_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool switchValue = true;
  String? userName;
  String? userProfileImage;

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (_currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .get();
        setState(() {
          userName = userDoc['name'];  // Fetch user's name
          userProfileImage = userDoc['imageUrl'];  // Fetch user's profile image URL
        });
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            height: 260,
            decoration: const BoxDecoration(
              color: Color(0xFFFFA726),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: userProfileImage != null
                      ? NetworkImage(userProfileImage!)
                      : null,  // Use user's profile image or show an icon if null
                  child: userProfileImage == null
                      ? const Icon(Icons.person, size: 50, color: Color(0xFFFFA726))
                      : null,
                ),
                const SizedBox(height: 10),
                Text(
                  userName ?? 'Loading...',  // Show user's name or "Loading..." while data is fetched
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Menu items
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(Icons.person, 'My Profile', () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileUpdateScreen(),));

                }),

                _buildMenuItem(Icons.restaurant_menu, 'Register Your Restaurant', () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RestaurantRegistrationPage(),));
                }),
                // Assuming you have a variable isVerified that checks if the user is verified


                _buildMenuItem(Icons.receipt, 'Orders', () {
                  // Navigate to Orders Screen
                }),


                _buildMenuItem(Icons.settings, 'Settings', () {
                  // Navigate to Settings Screen
                }),
                Divider(),
                _buildMenuItem(Icons.exit_to_app, 'Logout', () {
                  _showLogoutDialog(context);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, [VoidCallback? onTap]) {
    return ListTile(
      leading: Icon(icon, color: Colors.black26),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87),
      ),
      onTap: onTap ?? () {},
    );
  }

  Widget _buildMenuItemWithSwitch(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87),
      ),
      trailing: Switch(
        value: switchValue,
        onChanged: (bool newValue) {
          setState(() {
            switchValue = newValue;
          });
        },
        activeColor: Colors.orange,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Are you sure you want to logout?",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PhoneAuthView()));
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("You have logged out")));
              },
              child: Text("logout"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}

