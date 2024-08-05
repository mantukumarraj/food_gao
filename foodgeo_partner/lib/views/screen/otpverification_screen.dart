import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgeo_partner/views/screen/home_screen.dart';
import 'dart:developer';
import 'dart:async';
import 'package:foodgeo_partner/views/screen/register_screen.dart';
import 'package:pinput/pinput.dart';
import '../../home_page.dart';

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
  bool isButtonEnabled = true;

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
        setState(() {
          isButtonEnabled = false;
        });
      }
    });
  }

  Future<void> checkRegistrationStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Check if the user is signed in with phone authentication
      bool isPhoneAuthUser = user.providerData.any((provider) => provider.providerId == 'phone');
      if (isPhoneAuthUser) {
        // If the user is signed in with phone authentication, navigate to the home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(title: 'home',)),
        );
      } else {
        // If the user is not signed in with phone authentication, navigate to the register page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage()),
        );
      }
    }
  }

  Future<bool> registerUser(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users1').doc(userId).get();
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
        // If the user is registered, navigate to the home page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(title: 'home',)));
      } else {
        // If the user is not registered, navigate to the registration page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
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
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network("https://media.istockphoto.com/id/1221578901/vector/2fa-authentication-password-secure-notice-login-verification-or-sms-with-push-code-message.jpg?s=612x612&w=0&k=20&c=zganV8pxvPCp2aNZG6uDHL_qStrXerKneEcWRFxkVQA="),
              SizedBox(
                height: 25,
              ),
              Text(
                'We have sent a verification code to ${widget.phoneNumber}',
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Pinput(
                length: 6,
                showCursor: true,
                onCompleted: (pin) => verifyOtp(pin),
                controller: OtpController,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Resend code in $resendCountdown seconds',
                style: TextStyle(
                  fontSize: 16,
                  color: resendCountdown == 0 ? Colors.red : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () async {
                    verifyOtp(OtpController.text.toString());
                  }
                      : null,
                  child: Text('VERIFY OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
