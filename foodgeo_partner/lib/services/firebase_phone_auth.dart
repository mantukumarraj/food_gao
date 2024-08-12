import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebasePhoneAuth with ChangeNotifier{
  var auth = FirebaseAuth.instance;

  Future<void> sendotp (String verficationid ,  int phoneNumber ,BuildContext context , String otpVerfication) async{

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "$phoneNumber",
      verificationCompleted: (PhoneAuthCredential credential)async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("faield otp ${e}")));
      },
      codeSent: (String verificationId, int? resendToken) async {
        verficationid= verificationId;
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpVerfication);
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("verfication sussfullely ")));
      },
    );

  }
}