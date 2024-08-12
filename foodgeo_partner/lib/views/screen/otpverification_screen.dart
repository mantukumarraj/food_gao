import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'dart:async';
import 'package:foodgeo_partner/views/screen/register_screen.dart';
import 'package:pinput/pinput.dart'; // Import the pinput package
import 'home_page.dart';

class Verify extends StatefulWidget {
  final String verificationid;
  final String phoneNumber;

  Verify({Key? key, required this.verificationid, required this.phoneNumber}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  TextEditingController OtpController = TextEditingController();
  int resendCountdown = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startResendCountdown();
    checkRegistrationStatus();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startResendCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendCountdown > 0) {
        setState(() {
          resendCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> checkRegistrationStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      bool isPhoneAuthUser = user.providerData.any((provider) => provider.providerId == 'phone');
      if (isPhoneAuthUser) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage(phoneNumber: widget.phoneNumber,)),
        );
      }
    }
  }

  Future<bool> registerUser(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return snapshot.exists;
    } catch (error) {
      print('Error checking user registration: $error');
      return false;
    }
  }

  Future<void> verifyOtp(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationid,
        smsCode: otp,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      bool isRegistered = await registerUser(userCredential.user!.uid);

      if (isRegistered) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegistrationPage(phoneNumber: widget.phoneNumber,)));
      }
    } catch (ex) {
      log(ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    final padding = mediaQuery.padding;
    final safeAreaHeight = height - padding.top - padding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.white,
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
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Verify Your Phone Number",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: safeAreaHeight * 0.01),
                    Text(
                      'We have sent a verification code to ${widget.phoneNumber}',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: safeAreaHeight * 0.07),
              Pinput(
                length: 6,
                showCursor: true,
                onCompleted: (pin) => verifyOtp(pin),
                controller: OtpController,
                defaultPinTheme: defaultPinTheme,
              ),
              SizedBox(height: 20),
              Text(
                'Resend code in $resendCountdown seconds',
                style: TextStyle(
                  fontSize: 16,
                  color: resendCountdown == 0 ? Colors.red : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              Container(
                width: double.infinity,
                height: 42,
                child: MaterialButton(
                  onPressed: () {
                    verifyOtp(OtpController.text.toString());
                  },
                  color: Colors.orange,
                  child: Text(
                    'VERIFY OTP',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
