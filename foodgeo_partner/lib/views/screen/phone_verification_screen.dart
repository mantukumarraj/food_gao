import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:foodgeo_partner/views/screen/restaurant_register_screen.dart';
import '../widget/costum_buttom.dart';
import '../widget/costum_textfeld.dart';

class PhoneVerificationScreen extends StatefulWidget {
  @override
  _PhoneVerificationScreenState createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController otpController = TextEditingController();
  String verificationId = '';
  bool _isOtpSent = false;
  bool _isLoading = false;  // Added for progress indication
  PhoneNumber? number;

  void _sendOtp() {
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddRestaurant()));
    if (number != null) {
      setState(() {
        _isLoading = true;  // Show progress bar
      });

      _auth.verifyPhoneNumber(
        phoneNumber: number!.completeNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;  // Hide progress bar
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send OTP: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId;
            _isOtpSent = true;
            _isLoading = false;  // Hide progress bar
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number')),
      );
    }
  }

  void _verifyOtp() async {
    setState(() {
      _isLoading = true;  // Show progress bar
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text,
      );
      await _auth.signInWithCredential(credential);

      final user = _auth.currentUser;
      if (user != null) {
        await user.updateProfile(displayName: number!.completeNumber);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RestaurantRegistrationPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP Verified! Phone number saved.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;  // Hide progress bar
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFA726), Color(0xFF424242)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.08, left: screenWidth * 0.06),
              child: Text(
                "Phone Verification",
                style: TextStyle(
                  fontSize: screenHeight * 0.04,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.25),
            child: Container(
              height: screenHeight * 0.75,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!_isOtpSent) ...[
                            IntlPhoneField(
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                              initialCountryCode: 'IN',
                              onChanged: (phone) {
                                number = phone;
                              },
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            CustomButton(
                              text: "Send OTP",
                              onPressed: _sendOtp,
                              height: screenHeight * 0.07,
                              width: screenWidth * 0.8,
                            ),
                          ] else ...[
                            Center(
                              child: CustomTextField(
                                labelText: "OTP",
                                icon: Icons.lock,
                                controller: otpController,
                              )
                            )
                            ,
                            SizedBox(height: screenHeight * 0.03),
                            CustomButton(
                              text: "Verify OTP",
                              onPressed: _verifyOtp,
                              height: screenHeight * 0.07,
                              width: screenWidth * 0.8,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
