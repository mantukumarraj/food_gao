import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'otp_verfication_screen.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
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
          isLoading = true;
        });
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
            builder: (context) => Verify(
              verificationid: verificationId,
              phoneNumber: phoneNumber,
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
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    final padding = mediaQuery.padding;
    final safeAreaHeight = height - padding.top - padding.bottom;

    return Scaffold(
        appBar: AppBar(
          title:
             Text("PHONE AUTH"),

          backgroundColor: Colors.orange,
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: safeAreaHeight * 0.1),
                  Container(
                    width: width * 1.0,
                    height: height * 0.3,
                    padding: EdgeInsets.all(18.0),
                    color: Colors.black, // Set the background color to black
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "India's #1 Food Delivery and Dining App",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: safeAreaHeight * 0.01),
                        Text(
                          "Phone Number Verification",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: safeAreaHeight * 0.01),
                        Text(
                          "Login in or sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: safeAreaHeight * 0.07),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      setState(() {
                        phoneNumber = phone.completeNumber;
                      });
                    },
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: safeAreaHeight * 0.03),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height/16,
                    margin: EdgeInsets.symmetric(horizontal: 18),
                    child: MaterialButton(
                      onPressed: () {
                        if (phoneNumber.isNotEmpty) {
                          _verifyPhoneNumber();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter a phone number.")),
                          );
                        }
                      },
                      color: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'By continuing, you agree to our Terms of Service, Privacy Policy, and Content Policy',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: safeAreaHeight * 0.05),
                ],
              ),
            ),
            ),
        );
    }
}