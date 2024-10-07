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
  bool isRestaurantRegistered = false;

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
            .collection('partners')
            .doc(_currentUser!.uid)
            .get();

        // Check if restaurant is already registered
        QuerySnapshot restaurantQuery = await FirebaseFirestore.instance
            .collection('restaurants')
            .where('partnerId', isEqualTo: _currentUser!.uid)
            .get();

        setState(() {
          userName = userDoc['name'];
          userProfileImage = userDoc['imageUrl'];
          isRestaurantRegistered = restaurantQuery.docs.isNotEmpty; // Check if restaurant is registered
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
          Container(
            width: double.infinity,
            height: 260,
            decoration: const BoxDecoration(
              color: Color(0xFFFFA726),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80),
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
                      : null,
                  child: userProfileImage == null
                      ? const Icon(Icons.person, size: 50, color: Color(0xFFFFA726))
                      : null,
                ),
                const SizedBox(height: 10),
                Text(
                  userName ?? 'Loading...',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileUpdateScreen(),
                    ),
                  );
                }),
                _buildMenuItem(Icons.restaurant_menu, 'Register Your Restaurant', () {
                  if (isRestaurantRegistered) {
                    _showAlreadyRegisteredMessage();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantRegistrationPage(),
                      ),
                    );
                  }
                }),

                // Notification item with switch
                SwitchListTile(
                  title: Text(
                    'Notification',
                    style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87),
                  ),
                  secondary: Icon(Icons.notifications, color: Colors.black26),
                  value: switchValue,
                  onChanged: (bool value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
                  activeColor: Color(0xFFFFA726),
                ),

                const Divider(),
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

  void _showAlreadyRegisteredMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("You have already registered a restaurant."),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
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
                    const SnackBar(content: Text("You have logged out")));
              },
              child: const Text("Logout"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
