// import 'package:flutter/material.dart';
// import 'package:zomato_resturant/screen/resturant_screen.dart';
//
// import '../widget/costum_button.dart';
// import '../widget/costum_textfield.dart';
//
// class RestaurantPhoneScreen extends StatefulWidget {
//   @override
//   _RestaurantPhoneScreenState createState() => _RestaurantPhoneScreenState();
// }
//
// class _RestaurantPhoneScreenState extends State<RestaurantPhoneScreen> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//   bool _isOtpSent = false;
//
//   // Simulate sending OTP
//   void _sendOtp() {
//     setState(() {
//       _isOtpSent = true;
//     });
//   }
//
//   // Simulate OTP verification
//   void _verifyOtp() {
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>RestaurantRegistrationPage() ));
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('OTP Verified!')),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final screenHeight = mediaQuery.size.height;
//     final screenWidth = mediaQuery.size.width;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: double.infinity,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFFFA726), Color(0xFF424242)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Padding(
//               padding: EdgeInsets.only(top: screenHeight * 0.08, left: screenWidth * 0.06),
//               child: Text(
//                 "Phone Verification",
//                 style: TextStyle(
//                   fontSize: screenHeight * 0.04,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: screenHeight * 0.25),
//             child: Container(
//               height: screenHeight * 0.75,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(40),
//                   topRight: Radius.circular(40),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (!_isOtpSent) ...[
//                         CustomTextField(
//                           labelText: "Phone Number",
//                           icon: Icons.phone,
//                           controller: phoneController,
//                         ),
//                         SizedBox(height: screenHeight * 0.03),
//                         CustomButton(
//                           text: "Send OTP",
//                           onPressed: _sendOtp,
//                           height: screenHeight * 0.07,
//                           width: screenWidth * 0.8,
//                         ),
//                       ] else ...[
//                         CustomTextField(
//                           labelText: "OTP",
//                           icon: Icons.lock,
//                           controller: otpController,
//                         ),
//                         SizedBox(height: screenHeight * 0.03),
//                         CustomButton(
//                           text: "Verify OTP",
//                           onPressed: _verifyOtp,
//                           height: screenHeight * 0.07,
//                           width: screenWidth * 0.8,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
