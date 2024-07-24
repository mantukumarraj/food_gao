import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodgeo_partner/Screen/restaurant_register_screen.dart';
import '../widget/appbar_widget.dart';
import '../widget/button_widget.dart';
import '../widget/image_picker_widget.dart';
import '../widget/textfield_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File? _image;

  void _onImagePicked(File? image) {
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController userName = TextEditingController();
    TextEditingController userPhone = TextEditingController();
    TextEditingController userEmail = TextEditingController();
    TextEditingController userAddress = TextEditingController();
    final size = MediaQuery.of(context).size;
    return AppbarScreen(
      background: Colors.white,
      titleText: "Register Page",
      body: Center(
        child: ListView(
          children: [
            SizedBox(height: size.height / 13),
            Center(
              child: ImagePickerWidget(
                radius: 40,
                image: _image,
                onImagePicked: _onImagePicked,
              ),
            ),
            SizedBox(height: size.height / 13),
            EditText(
                controller: userName,
                labelText: "User Name",
                type: TextInputType.text,
                horizontalPadding: size.width / 12),
            SizedBox(height: size.height / 13),
            EditText(
                controller: userEmail,
                labelText: "user email",
                type: TextInputType.text,
                horizontalPadding: size.width / 12),
            SizedBox(height: size.height / 13),
            EditText(
                controller: userAddress,
                labelText: "user Address",
                type: TextInputType.text,
                horizontalPadding: size.width / 12),
            SizedBox(height: size.height / 4.6),
            DesignButton(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestruntRegister()));
                },
                width: size.width / 1,
                color: Colors.red,
                ButtonText: "Register",
                contect: context)
          ],
        ),
      ),
    );
  }
}
