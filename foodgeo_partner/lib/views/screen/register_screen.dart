import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'home_page.dart'; // Adjust the path as needed

class RegistrationPage extends StatefulWidget {
  final String phoneNumber;

  const RegistrationPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _selectedGender;
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a picture'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Photo'),
              onTap: () {
                setState(() {
                  _imageFile = null;
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _uploadImageToFirebaseStorage(File imageFile) async {
    try {
      final Reference storageRef = FirebaseStorage.instance.ref();
      final Reference imageRef = storageRef
          .child('user_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await imageRef.putFile(imageFile);
      final String imageUrl = await imageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  void _submitDetails() async {
    String name = _nameController.text.trim();
    String age = _ageController.text.trim();
    String address = _addressController.text.trim();
    String gender = _selectedGender ?? '';

    if (name.isEmpty || age.isEmpty || gender.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      String phone = widget.phoneNumber.startsWith("+91")
          ? widget.phoneNumber.substring(3)
          : widget.phoneNumber;

      String imageUrl = '';
      if (_imageFile != null) {
        imageUrl = await _uploadImageToFirebaseStorage(_imageFile!);
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'phone': phone,
        'gender': gender,
        'age':age,
        'address': address,
        'imageUrl': imageUrl,
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      print('Error registering user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Please try again.')),
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
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      "Register",
                      style: TextStyle(
                        fontSize: screenHeight * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF424242),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ImagePickerWidget(
                      onImagePicked: (image) {
                        _selectedImage = image;
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
                    CustomTextField(
                      labelText: "Email",
                      icon: Icons.email,
                      controller: _controller.emailController,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      labelText: "Password",
                      icon: Icons.lock,
                      controller: _controller.passwordController,
                      obscureText: true,
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
                        text: "Register",
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
                              MaterialPageRoute(builder: (context) => PhoneVerificationScreen()),
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
                    SizedBox(height: screenHeight * 0.05),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        "Already have an account? Sign in",
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

