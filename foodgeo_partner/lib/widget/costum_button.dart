// import 'dart:io';
// import 'package:flutter/material.dart';
// import '../widget/costum_button.dart';
// import '../widget/costum_textfield.dart';
//
// class RestaurantRegistrationPage extends StatefulWidget {
//   @override
//   _RestaurantRegistrationPageState createState() => _RestaurantRegistrationPageState();
// }
//
// class _RestaurantRegistrationPageState extends State<RestaurantRegistrationPage> {
//   final TextEditingController restaurantNameController = TextEditingController();
//   final TextEditingController restaurantLocationController = TextEditingController();
//   final TextEditingController ownerNameController = TextEditingController();
//   final TextEditingController pincodeController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final screenHeight = mediaQuery.size.height;
//     final screenWidth = mediaQuery.size.width;
//     File? _selectedImage;
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
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: screenHeight * 0.1),
//             child: Container(
//               height: screenHeight * 0.9,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(40),
//                   topRight: Radius.circular(40),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: screenHeight * 0.02),
//                     Text(
//                       "Register Restaurant",
//                       style: TextStyle(
//                         fontSize: screenHeight * 0.04,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF424242),
//                       ),
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//
//
//                     SizedBox(height: screenHeight * 0.03),
//                     CustomTextField(
//                       labelText: "Restaurant Name",
//                       icon: Icons.restaurant,
//                       controller: restaurantNameController,
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     CustomTextField(
//                       labelText: "Location",
//                       icon: Icons.location_on,
//                       controller: restaurantLocationController,
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     CustomTextField(
//                       labelText: "Owner Name",
//                       icon: Icons.person,
//                       controller: ownerNameController,
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     CustomTextField(
//                       labelText: "Pin code",
//                       icon: Icons.pin,
//                       controller: pincodeController,
//                     ),
//
//                     SizedBox(height: screenHeight * 0.03),
//                     CustomButton(
//                       text: "Register",
//                       onPressed: () {
//                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RestaurantPhoneScreen()));
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Restaurant Registered!')),
//                         );
//                       },
//                       height: screenHeight * 0.07,
//                       width: screenWidth * 0.8,
//                     ),
//                     SizedBox(height: screenHeight * 0.05),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         "Back to Login",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
