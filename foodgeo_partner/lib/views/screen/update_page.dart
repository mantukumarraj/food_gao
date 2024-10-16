import 'dart:io';
import 'package:flutter/material.dart';


import 'package:foodgeo_partner/controller/update_controller.dart'; // Ensure this controller handles updates
import '../../widget/image_picker.dart';
import '../widget/costum_textfeld.dart';
import 'home_page.dart';

class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final UpdateController _controller = UpdateController();
  String _selectedGender = 'Male';
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserData();
  }

  Future<void> _fetchCurrentUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var userData = await _controller.getCurrentUserData();
      setState(() {
        _controller.nameController.text = userData['name'] ?? '';
        _controller.addressController.text = userData['address'] ?? '';
        _selectedGender = userData['gender'] ?? 'Male';
        // Use the image URL to create a File object if needed
        if (userData['imageUrl'] != null) {
          _selectedImage = File(userData['imageUrl']);
        }
      });
    } catch (e) {
      // Handle errors if needed
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      "Update Profile",
                      style: TextStyle(
                        fontSize: screenHeight * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF424242),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ImagePickerWidget(
                      initialImage: _selectedImage, // Pass initial image
                      onImagePicked: (image) {
                        setState(() {
                          _selectedImage = image;
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    CustomTextField(
                      labelText: "Name",
                      icon: Icons.person,
                      controller: _controller.nameController,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      labelText: "Address",
                      icon: Icons.location_on,
                      controller: _controller.addressController,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
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
                        ),
                        Expanded(
                          child: Row(
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
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    if (_isLoading)
                      CircularProgressIndicator(),
                    if (!_isLoading)
                      // CustomButton(
                      //   text: "Update",
                      //   onPressed: () async {
                      //     setState(() {
                      //       _isLoading = true;
                      //     });
                      //     try {
                      //       await _controller.updateUserProfile(
                      //         _controller.nameController.text,
                      //         _controller.addressController.text,
                      //         _selectedGender,
                      //         _selectedImage!,
                      //       );
                      //       Navigator.pushReplacement(
                      //         context,
                      //         MaterialPageRoute(builder: (context) => HomePage()),
                      //       );
                      //     } catch (e) {
                      //       // Handle errors if needed
                      //     } finally {
                      //       setState(() {
                      //         _isLoading = false;
                      //       });
                      //     }
                      //   },
                      //   height: screenHeight * 0.07,
                      //   width: screenWidth * 0.8,
                      // ),
                    SizedBox(height: screenHeight * 0.05),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
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
