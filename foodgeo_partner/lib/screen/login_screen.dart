// import 'package:flutter/material.dart';
// import 'package:zomato_resturant/screen/register_screen.dart';
//
// import '../widget/costum_button.dart';
// import '../widget/costum_textfield.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool _isPasswordVisible = false;
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
//                 "Hello\nSign in!",
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
//                       CustomTextField(
//                         labelText: "Phone Number",
//                         icon: Icons.phone,
//                         controller: phoneController,
//                       ),
//                       SizedBox(height: screenHeight * 0.03),
//                       CustomTextField(
//                         labelText: "Password",
//                         icon: Icons.lock,
//                         controller: passwordController,
//                         obscureText: !_isPasswordVisible,
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                             color: Colors.grey,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isPasswordVisible = !_isPasswordVisible;
//                             });
//                           },
//                         ),
//                       ),
//                       SizedBox(height: screenHeight * 0.03),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Text(
//                           "Forgot Password?",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: screenHeight * 0.022,
//                             color: Color(0xFF424242),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: screenHeight * 0.1),
//                       CustomButton(
//                         text: "SIGN IN",
//                         onPressed: () {},
//                         height: screenHeight * 0.07,
//                         width: screenWidth * 0.8,
//                       ),
//                       SizedBox(height: screenHeight * 0.05),
//                       Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Don't have an account?",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>RegistrationPage() ));
//                               },
//                               child: Text(
//                                 "Sign up",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: screenHeight * 0.022,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
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
