import 'package:flutter/material.dart';
import 'package:foodgeo_partner/views/screen/resturant_phone_verfication_screen.dart';
import 'dart:io';
import '../../controller/restaurant_registration_controller.dart';
import '../widget/costum_buttom.dart';
import '../widget/costum_textfeld.dart';
import '../widget/image_picker_widget.dart';

class RestaurantRegistrationPage extends StatefulWidget {
  @override
  _RestaurantRegistrationPageState createState() => _RestaurantRegistrationPageState();
}

class _RestaurantRegistrationPageState extends State<RestaurantRegistrationPage> {
  final RegisterControllers _controller = RegisterControllers();
  String _selectedGender = 'Male';
  File? _selectedImage;
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'Fast Food';

  final List<String> _categories = [
    'Fast Food',
    'Casual Dining',
    'Fine Dining',
    'Cafe',
    'Buffet',
    'Food Truck',
  ];

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
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      "Restaurant Registration",
                      style: TextStyle(
                        fontSize: screenHeight * 0.03,
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
                      labelText: "Restaurant name",
                      icon: Icons.restaurant,
                      controller: _controller.nameController,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      labelText: "Address",
                      icon: Icons.home,
                      controller: _controller.addressController,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.person, size: screenHeight * 0.025, color: Colors.orange),
                          SizedBox(width: screenWidth * 0.02), // Space between icon and label
                          Text(
                            "Gender",
                            style: TextStyle(
                              fontSize: screenHeight * 0.025,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Male',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value!;
                                });
                              },
                            ),
                            Text('Male'),
                          ],
                        ),
                        SizedBox(width: screenWidth * 0.05), // Space between options
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Female',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value!;
                                });
                              },
                            ),
                            Text('Female'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      labelText: "Owner name",
                      icon: Icons.person,
                      controller: _controller.ownerNameController,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      labelText: "Location",
                      icon: Icons.location_on,
                      controller: _controller.locationController,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Category",
                        prefixIcon: Icon(Icons.category),
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedCategory,
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                          _controller.category = newValue;  // Set the selected category in the controller
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    if (_errorMessage != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    if (_isLoading)
                      CircularProgressIndicator(),
                    if (!_isLoading)
                      CustomButton(
                        text: "Next",
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                            _errorMessage = null;
                          });
                          try {
                            if (_selectedImage == null) {
                              throw Exception("Please select an image.");
                            }
                            await _controller.registerUser(_selectedGender, _selectedImage!);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ResturantPhoneVerificationScreen()),
                            );
                          } catch (e) {
                            setState(() {
                              _errorMessage = e.toString();
                            });
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        height: screenHeight * 0.07,
                        width: screenWidth * 0.8,
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
