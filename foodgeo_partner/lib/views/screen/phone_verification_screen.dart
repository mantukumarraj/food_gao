import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodgeo_partner/views/screen/register_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'otpverification_screen.dart';

class PhoneAuthView extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<PhoneAuthView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String verificationId;
  bool isLoading = false;
  String phoneNumber = ''; // Store the phone number input

  void _verifyPhoneNumber() async {
    setState(() {
      isLoading = true;
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage(phoneNumber: phoneNumber)),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed. Error: ${e.message}")),
        );
        print('Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          isLoading = false;
          this.verificationId = verificationId;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              phoneNumber: phoneNumber.toString(),
              verificationId: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
          isLoading = false;
        });
      },
    );
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
