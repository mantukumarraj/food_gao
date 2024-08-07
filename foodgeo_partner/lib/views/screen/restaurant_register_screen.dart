import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodgeo_partner/home_page.dart';
import 'package:foodgeo_partner/views/screen/verfication_screen.dart';
import 'package:foodgeo_partner/views/widget/image_picker_widget.dart';
import '../../controller/restaurant_registration_controller.dart';
import '../../widget/costum_dropdown.dart';
import '../widget/costum_buttom.dart';
import '../widget/costum_textfeld.dart';


class RestaurantRegistrationPage extends StatefulWidget {
  @override
  _RestaurantRegistrationPageState createState() =>
      _RestaurantRegistrationPageState();
}

class _RestaurantRegistrationPageState
    extends State<RestaurantRegistrationPage> {
  final TextEditingController restaurantNameController = TextEditingController();
  final TextEditingController restaurantLocationController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  File? _image;
  String? _selectedCategory;

  final List<String> _categories = [
    'Fast Food',
    'Casual Dining',
    'Fine Dining',
    'Cafe',
    'Buffet'
  ];

  bool _isLoading = false; // Flag to track loading state

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
              color: Colors.orange,
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
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      "Register Restaurant",
                      style: TextStyle(
                        fontSize: screenHeight * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF424242),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ImagePickerWidget(onImagePicked: (pickedImage) {
                      setState(() {
                        _image = pickedImage;
                      });
                    }),
                    SizedBox(height: screenHeight * 0.02),
                    CustomDropdown(
                      labelText: "Select Category",
                      icon: Icons.category,
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      labelText: "Restaurant Name",
                      icon: Icons.restaurant,
                      controller: restaurantNameController,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      labelText: "Location",
                      icon: Icons.location_on,
                      controller: restaurantLocationController,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      labelText: "Owner Name",
                      icon: Icons.person,
                      controller: ownerNameController,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      labelText: "Pin code",
                      icon: Icons.pin,
                      controller: pincodeController,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Center(
                      child: _isLoading
                          ? CircularProgressIndicator() // Show progress bar
                          : CustomButton(
                        text: "Register",
                        onPressed: () async {
                          if (_image != null && _selectedCategory != null) {
                            setState(() {
                              _isLoading = true; // Start loading
                            });
                            try {
                              final registerController = RegisterControllers();

                              registerController.nameController.text =
                                  restaurantNameController.text;
                              registerController.addressController.text =
                                  restaurantLocationController.text;
                              registerController.ownerNameController.text =
                                  ownerNameController.text;
                              registerController.locationController.text =
                                  restaurantLocationController.text;
                              registerController.descriptionController.text =
                              ''; // Set if needed

                              // Register the restaurant
                              await registerController.registerUser(
                                  'someGender', _image!, _selectedCategory!);

                              // Navigate and show success message
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RestaurantVerificationScreen()),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Restaurant Registered!')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: ${e.toString()}')),
                              );
                            } finally {
                              setState(() {
                                _isLoading = false; // End loading
                              });
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select an image and category')),
                            );
                          }
                        },
                        height: screenHeight * 0.07,
                        width: screenWidth * 1.2,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                      },
                      child: Text(
                        "Back to",
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
        ],
      ),
    );
  }
}
