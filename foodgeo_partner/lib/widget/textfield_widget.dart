import 'package:flutter/material.dart';

class EditText extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType type;
  final double horizontalPadding;

  EditText({
    super.key,
    required this.controller,
    required this.labelText,
    required this.type,
    required this.horizontalPadding,
  });

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    double padding = widget.horizontalPadding;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Colors.black), // Change label color to black
          filled: true,
          fillColor: Colors.white, // Background color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red), // Default border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red), // Enabled border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red), // Focused border color
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red), // Focused error border color
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red), // Error border color
          ),
        ),
        keyboardType: widget.type,
        style: TextStyle(color: Colors.black), // Change input text color to black
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please enter ${widget.labelText}");
          }
          return null;
        },
      ),
    );
  }
}
