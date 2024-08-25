import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../controller/restaurant_registration_controller.dart'; // Ensure this path is correct
import '../widget/costum_buttom.dart';
import '../widget/costum_textfeld.dart';
import 'RestaurantListScreen.dart';

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
  int? _longPressedIndex;

  final List<String> _categories = [
    'Fast Food',
    'Casual Dining',
    'Fine Dining',
    'Cafe',
    'Buffet',
    'Food Truck',
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _longPressedIndex = null;
    });
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
                    GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: CircleAvatar(
                        radius: screenWidth * 0.15,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : AssetImage('assets/placeholder_image.png') as ImageProvider,
                        child: _selectedImage == null
                            ? Icon(Icons.add_a_photo, color: Colors.white, size: screenWidth * 0.1)
                            : null,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _selectedImage != null
                        ? Container(
                      height: screenHeight * 0.1,
                      child: GestureDetector(
                        onLongPress: () {
                          setState(() {
                            _longPressedIndex = 0; // Since only one image is present
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: screenWidth * 0.02),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  _selectedImage!,
                                  width: screenWidth * 0.2,
                                  height: screenHeight * 0.1,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            if (_longPressedIndex == 0)
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: _removeImage,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.close, size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                        : SizedBox.shrink(),
                    SizedBox(height: screenHeight * 0.02),
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
                          SizedBox(width: screenWidth * 0.02),
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
                        Radio<String>(
                          value: 'Male',
                          groupValue: _selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                        Text('Male'),
                        Radio<String>(
                          value: 'Female',
                          groupValue: _selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                        Text('Female'),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                        icon: Icon(Icons.category, color: Colors.orange),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      items: _categories.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      labelText: "Location",
                      icon: Icons.location_on,
                      controller: _controller.locationController,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      labelText: "Owner Name",
                      icon: Icons.person,
                      controller: _controller.ownerNameController,
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    CustomButton(
                      text: "Register",
                      onPressed: () async {
                        if (_controller.nameController.text.isEmpty ||
                            _controller.addressController.text.isEmpty ||
                            _controller.ownerNameController.text.isEmpty ||
                            _controller.locationController.text.isEmpty ||
                            _selectedImage == null) {
                          setState(() {
                            _errorMessage = 'Please fill in all fields and select an image';
                          });
                          return;
                        }
                        setState(() {
                          _isLoading = true;
                          _errorMessage = null;
                        });
                        try {
                          await _controller.registerUser(_selectedGender, _selectedImage! );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => RestaurantListScreen()),
                          );
                        } catch (e) {
                          setState(() {
                            _errorMessage = 'Error: ${e.toString()}';
                          });
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }, height: 40, width: 120,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
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
