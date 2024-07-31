// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class PhoneAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> verifyPhoneNumber(String phoneNumber, Function(String) codeSentCallback, Function(String) verificationFailedCallback) async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         _addPhoneUserToFirestore(phoneNumber);
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         verificationFailedCallback(e.message ?? 'Verification failed');
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         codeSentCallback(verificationId);
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         codeSentCallback(verificationId);
//       },
//     );
//   }
//
//   // Sign in with phone number
//   Future<void> signInWithPhoneNumber(String verificationId, String smsCode) async {
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: verificationId,
//       smsCode: smsCode,
//     );
//
//     await _auth.signInWithCredential(credential);
//     User? user = _auth.currentUser;
//     if (user != null) {
//       await _addPhoneUserToFirestore(user.phoneNumber);
//     }
//   }
//
//   // Add user to Firestore
//   Future<void> _addPhoneUserToFirestore(String? phoneNumber) async {
//     User? user = _auth.currentUser;
//     if (user != null && phoneNumber != null) {
//       await _firestore.collection('users').doc(user.uid).set({
//         'phone_number': phoneNumber,
//         'provider': 'phone',
//         'uid': user.uid,
//       });
//     }
//   }
// }
