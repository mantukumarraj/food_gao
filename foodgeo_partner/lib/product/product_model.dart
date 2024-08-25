// import 'package:flutter/material.dart';
//
// class ProductModel extends StatelessWidget {
//   final String imageUrl;
//   final String name;
//   final String description;
//   final String price;
//   final String productId; // Product ID
//
//   const ProductModel({
//     Key? key,
//     required this.imageUrl,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.productId,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//
//       },
//       child: Card(
//         margin: EdgeInsets.symmetric(horizontal: 3, vertical: 7),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(7),
//         ),
//         child: Container(
//           padding: EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.start, // Center the Row vertically
//             children: [
//
//
//               Image.network(
//                 imageUrl,
//                 width: 90,
//                 height: 80,
//                 fit: BoxFit.cover,
//               ),
//               SizedBox(height: 3),
//               Text(
//                 'Title : $name', style: TextStyle(fontSize: 15),
//               ),
//               Text('Description : $description', style: TextStyle(fontSize: 15, color: Colors.black),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center, // Center the content horizontally
//                 children: [
//                   Text('Price : $price', style: TextStyle(fontSize: 20, color: Colors.cyan)),
//                   Icon(Icons.currency_rupee, color: Colors.cyan,), // Currency icon
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
