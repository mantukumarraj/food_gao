import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator; // Optional validator
  final TextInputType? keyboardType; // Optional keyboard type
  final List<TextInputFormatter>? inputFormatters; // Optional input formatters

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.icon,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.keyboardType, // Add this
    this.inputFormatters, // Add this
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType, // Use keyboardType here
      inputFormatters: inputFormatters, // Use inputFormatters here
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        suffixIcon: suffixIcon,
        labelText: labelText,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
