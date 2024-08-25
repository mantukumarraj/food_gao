import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgeo_partner/views/screen/home_page.dart';
import 'package:foodgeo_partner/views/screen/phone_verification_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      // Check if the user is authenticated
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // If the user is authenticated, navigate to Home Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  HomePage()),
        );
      } else {
        // If the user is not authenticated, navigate to PhoneAuthView
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PhoneAuthView()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: screenHeight * 0.15,
                  color: Colors.orangeAccent
                  ,
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'FoodGeo Partner',
                  style: TextStyle(
                    fontSize: screenHeight * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
