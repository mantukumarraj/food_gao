// import 'package:flutter/material.dart';
// import 'package:foodgeo_partner/views/screen/phone_verification_screen.dart';
// import 'dart:io';
//
// import '../../controller/register_controllers.dart';
// import '../widget/costum_buttom.dart';
// import '../widget/costum_textfeld.dart';
// import '../widget/image_picker_widget.dart';
// import 'login_screen.dart';
//
// class RegistrationPage extends StatefulWidget {
//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }
//
// class _RegistrationPageState extends State<RegistrationPage> {
//   final RegistrationController _controller = RegistrationController();
//   String _selectedGender = 'Male';
//   File? _selectedImage;
//   bool _isLoading = false;
//   String? _errorMessage;
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
//                   children: [
//                     SizedBox(height: screenHeight * 0.02),
//                     Text(
//                       "Register",
//                       style: TextStyle(
//                         fontSize: screenHeight * 0.04,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF424242),
//                       ),
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     ImagePickerWidget(
//                       onImagePicked: (image) {
//                         _selectedImage = image;
//                       },
//                     ),
//                     SizedBox(height: screenHeight * 0.03),
//                     CustomTextField(
//                       labelText: "Name",
//                       icon: Icons.person,
//                       controller: _controller.nameController,
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     CustomTextField(
//                       labelText: "Address",
//                       icon: Icons.location_on,
//                       controller: _controller.addressController,
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Radio<String>(
//                                 value: 'Male',
//                                 groupValue: _selectedGender,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _selectedGender = value!;
//                                   });
//                                 },
//                               ),
//                               Text('Male'),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Radio<String>(
//                                 value: 'Female',
//                                 groupValue: _selectedGender,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _selectedGender = value!;
//                                   });
//                                 },
//                               ),
//                               Text('Female'),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     CustomTextField(
//                       labelText: "Email",
//                       icon: Icons.email,
//                       controller: _controller.emailController,
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     CustomTextField(
//                       labelText: "Password",
//                       icon: Icons.lock,
//                       controller: _controller.passwordController,
//                       obscureText: true,
//                     ),
//                     SizedBox(height: screenHeight * 0.03),
//                     if (_errorMessage != null)
//                       Padding(
//                         padding: EdgeInsets.only(bottom: screenHeight * 0.02),
//                         child: Text(
//                           _errorMessage!,
//                           style: TextStyle(color: Colors.red),
//                         ),
//                       ),
//                     if (_isLoading)
//                       CircularProgressIndicator(),
//                     if (!_isLoading)
//                       CustomButton(
//                         text: "Register",
//                         onPressed: () async {
//                           setState(() {
//                             _isLoading = true;
//                             _errorMessage = null;
//                           });
//                           try {
//                             if (_selectedImage == null) {
//                               throw Exception("Please select an image.");
//                             }
//                             await _controller.registerUser(_selectedGender, _selectedImage!);
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(builder: (context) => PhoneVerificationScreen()),
//                             );
//                           } catch (e) {
//                             setState(() {
//                               _errorMessage = e.toString();
//                             });
//                           } finally {
//                             setState(() {
//                               _isLoading = false;
//                             });
//                           }
//                         },
//                         height: screenHeight * 0.07,
//                         width: screenWidth * 0.8,
//                       ),
//                     SizedBox(height: screenHeight * 0.05),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
//                       },
//                       child: Text(
//                         "Already have an account? Sign in",
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
//
