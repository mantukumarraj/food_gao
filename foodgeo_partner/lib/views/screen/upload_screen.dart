import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/add_product.dart'; // Ensure this path is correct
import '../../widget/custom_text_field.dart';
import '../widget/costum_buttom.dart';
import '../widget/image_picker_widget.dart'; // Fixed typo in import path

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController restaurantNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  final FirebaseServiceRestaurant _firebaseServiceRestaurant = FirebaseServiceRestaurant();

  Future<void> _registerRestaurant() async {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      try {
        await _firebaseServiceRestaurant.registerRestaurant(
          restaurantName: restaurantNameController.text,
          location: locationController.text,
          ownerName: ownerNameController.text,
          pincode: pincodeController.text,
          image: _selectedImage!,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restaurant Registered Successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFA726), Color(0xFF424242)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.1),
            child: Container(
              height: screenHeight * 0.9,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        "Product Add",
                        style: TextStyle(
                          fontSize: screenHeight * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF424242),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      ImagePickerWidget(
                        onImagePicked: (image) {
                          setState(() {
                            _selectedImage = image;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      CustomTextField(
                        labelText: "Restaurant Name",
                        icon: Icons.food_bank_outlined,
                        controller: restaurantNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter restaurant name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CustomTextField(
                        labelText: "Location",
                        icon: Icons.location_on,
                        controller: locationController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter location';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CustomTextField(
                        labelText: "Owner Name",
                        icon: Icons.person,
                        controller: ownerNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter owner name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CustomTextField(
                        labelText: "Pincode",
                        icon: Icons.pin_drop,
                        controller: pincodeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter pincode';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      CustomButton(
                        text: "Register",
                        onPressed: _registerRestaurant,
                        height: screenHeight * 0.07,
                        width: screenWidth * 0.8,
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Back to Login",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
