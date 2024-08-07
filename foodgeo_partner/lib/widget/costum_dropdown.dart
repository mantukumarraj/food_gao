import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final String? value;
  final List<String> items;
  final Function(String?)? onChanged;

  const CustomDropdown({
    required this.labelText,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black), // Orange text color
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black), // Black border color
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        prefixIcon: Icon(icon, color: Colors.black), // Orange icon color
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(labelText, style: TextStyle(color: Colors.black)), // Orange hint text color
          items: items.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category, style: TextStyle(color: Colors.black)), // Orange item text color
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
