import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodgeo_partner/views/screen/phone_verification_screen.dart';

import '../../home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  static const int splashDurationInSeconds = 2;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _checkAuthenticationState();
  }

  void _initAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: splashDurationInSeconds),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  void _checkAuthenticationState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      Timer(Duration(seconds: splashDurationInSeconds), () {
        _navigateBasedOnAuthState(user);
      });
    }, onError: (error) {
      // Handle error if necessary
      print('Error checking auth state: $error');
      // Optionally navigate to an error screen or show a message
    });
  }

  void _navigateBasedOnAuthState(User? user) {
    if (user == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => PhoneAuth()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
    }
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
      backgroundColor: Colors.black,
        body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
                      color: Colors.orangeAccent,
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
}}