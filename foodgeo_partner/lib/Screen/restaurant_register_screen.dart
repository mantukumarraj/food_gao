import 'dart:io';
import 'package:flutter/material.dart';
import '../widget/appbar_widget.dart';
import '../widget/button_widget.dart';
import '../widget/image_picker_widget.dart';
import '../widget/textfield_widget.dart';

class RestruntRegister extends StatefulWidget {
  const RestruntRegister({super.key});

  @override
  State<RestruntRegister> createState() => _RestruntRegisterState();
}

class _RestruntRegisterState extends State<RestruntRegister> {
  File? _image;

  void _onImagePicked(File? image) {
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController restaurantName = TextEditingController();
    TextEditingController WonerPhone = TextEditingController();
    TextEditingController restaurantPinCode = TextEditingController();
    TextEditingController restaurantAddress = TextEditingController();
    final size = MediaQuery.of(context).size;
    return AppbarScreen(
      background: Colors.white,
      titleText: "Restaurant Register Page",
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
                controller: restaurantName,
                labelText: "Restaurant name ",
                type: TextInputType.text,
                horizontalPadding: size.width / 12),
            SizedBox(height: size.height / 13),
            EditText(
                controller: WonerPhone,
                labelText: "Woner phone ",
                type: TextInputType.phone,
                horizontalPadding: size.width / 12),
            SizedBox(height: size.height / 13),
            EditText(
                controller: restaurantAddress,
                labelText: "Restaurant address",
                type: TextInputType.emailAddress,
                horizontalPadding: size.width / 12),
            SizedBox(height: size.height / 13),
            EditText(
                controller: restaurantPinCode,
                labelText: "Restaurant pin code",
                type: TextInputType.phone,
                horizontalPadding: size.width / 12),
            SizedBox(height: size.height / 4.6),
            DesignButton(
                onTap: () {

                },
                width: size.width / 1,
                color: Colors.red,
                ButtonText: "Restaurant Register",
                contect: context)
          ],
        ),
      ),
    );
  }
}
