// import 'package:flutter/material.dart';
//
// class CustomTextField extends StatelessWidget {
//   final String labelText;
//   final IconData icon;
//   final TextEditingController controller;
//   final bool obscureText;
//   final Widget? suffixIcon;
//   final String? Function(String?)? validator; // Optional validator
//
//   const CustomTextField({
//     Key? key,
//     required this.labelText,
//     required this.icon,
//     required this.controller,
//     this.obscureText = false,
//     this.suffixIcon,
//     this.validator,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       keyboardType: labelText == "Phone Number" ? TextInputType.phone : TextInputType.text,
//       validator: validator,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.orange),
//         suffixIcon: suffixIcon,
//         labelText: labelText,
//         labelStyle: TextStyle(
//           fontWeight: FontWeight.bold,
//           color: Colors.orange,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CostumTextfield{

  Widget customTextField({
    required String labelText,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black,),
        suffixIcon: suffixIcon,
        labelText: labelText,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

