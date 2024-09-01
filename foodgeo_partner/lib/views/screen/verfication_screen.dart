// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:foodgeo_partner/views/screen/home_page.dart';
// // import 'package:uuid/uuid.dart';
// //
// // class RestaurantVerificationScreen extends StatefulWidget {
// //   const RestaurantVerificationScreen({super.key});
// //
// //   @override
// //   State<RestaurantVerificationScreen> createState() =>
// //       _RestaurantVerificationScreenState();
// // }
// //
// // class _RestaurantVerificationScreenState
// //     extends State<RestaurantVerificationScreen> {
// //   String uuid = Uuid().v4();
// //   bool isRegistered = false;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //
// //   // Variable to store the 'name' value
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.orangeAccent,
// //       ),
// //       body: Center(
// //         child: Column(
// //           children: [
// //             SizedBox(
// //               height: 50,
// //             ),
// //             Center(
// //                 child: Text("Verify Restaurant ",
// //                     style:
// //                         TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
// //             SizedBox(
// //               height: 50,
// //             ),
// //             Image.network(
// //                 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiocuPPGmSUZC6IIOWC1SDmCeMdMLYt2qbqQ&s",
// //                 fit: BoxFit.fill),
// //             SizedBox(height: 50),
// //             StreamBuilder<DocumentSnapshot>(
// //               stream:
// //                   _firestore.collection("restaurants").doc(uuid).snapshots(),
// //               builder: (context, snapshot) {
// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   return Center(
// //                     child: CircularProgressIndicator(),
// //                   );
// //                 } else if (snapshot.hasError) {
// //                   return Center(
// //                     child: Text("Error: ${snapshot.error}"),
// //                   );
// //                 } else if (!snapshot.hasData || !snapshot.data!.exists) {
// //                   return Center(
// //                     child: Text("No Data",
// //                         style: TextStyle(
// //                             fontSize: 25, fontWeight: FontWeight.bold)),
// //                   );
// //                 } else {
// //                   var data = snapshot.data!.data() as Map<String, dynamic>;
// //                   isRegistered = data['name'];
// //                   return isRegistered
// //                       ? TextButton(
// //                           onPressed: () {
// //                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //                                 content: Text(
// //                                     "Restaurant not registerd wait for one weak")));
// //                           },
// //                           child: Text("Not restaurant registerd"))
// //                       : TextButton(
// //                           onPressed: () {
// //                             Navigator.pushReplacement(
// //                                 context,
// //                                 MaterialPageRoute(
// //                                     builder: (context) => HomePage()));
// //                           },
// //                           child: Text(" Registerd restaurant"));
// //                   //   Text(
// //                   //   isRegistered ? "User Registered" : "User Not Registered",
// //                   // );
// //                 }
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:foodgeo_partner/views/screen/home_screen.dart';
// class RestaurantVerificationScreen extends StatefulWidget {
//   const RestaurantVerificationScreen({super.key});
//
//   @override
//   State<RestaurantVerificationScreen> createState() =>
//       _RestaurantVerificationScreenState();
// }
//
// class _RestaurantVerificationScreenState
//     extends State<RestaurantVerificationScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool isRegistered = false;
//   bool isVerified = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final user = _auth.currentUser;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.orangeAccent,
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             SizedBox(height: 50),
//             Center(
//               child: Text(
//                 "Verify Restaurant",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
//               ),
//             ),
//             SizedBox(height: 50),
//             Image.network(
//               "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiocuPPGmSUZC6IIOWC1SDmCeMdMLYt2qbqQ&s",
//               fit: BoxFit.fill,
//             ),
//             SizedBox(height: 50),
//             if (user != null)
//               StreamBuilder<DocumentSnapshot>(
//                 stream: _firestore.collection("restaurants").doc(user.uid).snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   } else if (snapshot.hasError) {
//                     return Center(
//                       child: Text("Error: ${snapshot.error}"),
//                     );
//                   } else if (!snapshot.hasData || !snapshot.data!.exists) {
//                     return Center(
//                       child: Text(
//                         "No Data",
//                         style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//                       ),
//                     );
//                   } else {
//                     var data = snapshot.data!.data() as Map<String, dynamic>;
//                     isRegistered = data.containsKey('name') && data['name'].isNotEmpty;
//                     isVerified = data['verification'] ?? false;
//
//                     return Column(
//                       children: [
//                         Text(
//                           isRegistered
//                               ? "Restaurant Registered"
//                               : "Restaurant Not Registered",
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 20),
//                         Text(
//                           isVerified ? "Restaurant Verified" : "Waiting for Verification",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: isVerified ? Colors.green : Colors.red,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         isRegistered && isVerified
//                             ? TextButton(
//                           onPressed: () {
//                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageScreen(),));
//                           },
//                           child: Text("Go to Home"),
//                         )
//                             : TextButton(
//                           onPressed: () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   "Restaurant not verified, please wait.",
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Text("Not Verified"),
//                         ),
//                       ],
//                     );
//                   }
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }