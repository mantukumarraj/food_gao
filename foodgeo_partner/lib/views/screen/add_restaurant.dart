// import 'package:flutter/material.dart';
// import 'package:foodgeo_partner/views/screen/restaurant_register_screen.dart';
// import '../widget/costum_buttom.dart';
//
// class AddRestaurant extends StatefulWidget {
//   @override
//   _AddRestaurantState createState() => _AddRestaurantState();
// }
//
// class _AddRestaurantState extends State<AddRestaurant> {
//
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
//                 "Add Restaurant",
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
//                       Center(
//                         child: Image.network(
//                           "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHx8MA%3D%3D",
//                           height: screenHeight * 0.3,
//                           width: screenWidth * 0.8,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       SizedBox(height: screenHeight * 0.03),
//                       Center(
//                         child: CustomButton(
//                           text: 'Add Restaurant',
//                           onPressed: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => RestaurantRegistrationPage(),
//                               ),
//                             );
//                           },
//                           height: 40,
//                           width: 200,
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
