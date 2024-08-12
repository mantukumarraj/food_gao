import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgeo_partner/views/screen/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'colors.dart'; // Make sure this path is correct
import 'home_page.dart'; // Make sure this path is correct

class RegistrationPage extends StatefulWidget {
  final String phoneNumber;

  const RegistrationPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegistrationPage> {
  bool isMale = true;
  String selectedGender = 'Male';
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/your_background_image.jpg"), // Replace with your image path
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                padding: EdgeInsets.only(top: 70, left: 20),
                color: Colors.black.withOpacity(.85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Welcome to",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: Colors.orange[700],
                        ),
                        children: [
                          TextSpan(
                            text: " FoodGeo,",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[700],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: Text(
                        " Seller Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 900),
            curve: Curves.bounceInOut,
            top: 200,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 900),
              curve: Curves.bounceInOut,
              height: 490,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: buildSignupSection(),
              ),
            ),
          ),
          Positioned(
            top: 210,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.photo_library),
                            title: Text('Choose from gallery'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImageFromGallery();
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.photo_camera),
                            title: Text('Take a picture'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImageFromCamera();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null
                    ? Icon(Icons.add_a_photo, size: 50, color: Colors.white)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildSignupSection() {
    return Container(
      margin: EdgeInsets.only(top: 110),
      child: Column(
        children: [
          // User Name field
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.account_circle_outlined),
              hintText: "User Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height: 10),

          // Gender field
          buildGenderField(),
          SizedBox(height: 20),

          // Address field
          TextField(
            controller: addressController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.location_on_outlined),
              hintText: "Address",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height: 30),

          // Submit button
          ElevatedButton(
            onPressed: registerUser,
            child: Text(
              'Submit',
              style: TextStyle(
                color: Colors.white, // Set the text color to white
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildGenderField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gender",
            style: TextStyle(
              color: Palette.textColor1,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isMale = true;
                    selectedGender = 'Male';
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isMale ? Palette.textColor2 : Colors.transparent,
                        border: Border.all(
                          width: 1,
                          color: isMale ? Colors.transparent : Palette.textColor1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.account_circle_outlined,
                        color: isMale ? Colors.white : Palette.iconColor,
                      ),
                    ),
                    Text(
                      "Male",
                      style: TextStyle(
                        color: isMale ? Palette.textColor2 : Palette.textColor1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isMale = false;
                    selectedGender = 'Female';
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isMale ? Colors.transparent : Palette.textColor2,
                        border: Border.all(
                          width: 1,
                          color: isMale ? Palette.textColor1 : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.account_circle_outlined,
                        color: isMale ? Palette.iconColor : Colors.white,
                      ),
                    ),
                    Text(
                      "Female",
                      style: TextStyle(
                        color: isMale ? Palette.textColor1 : Palette.textColor2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImageToFirebaseStorage(_imageFile!);
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImageToFirebaseStorage(_imageFile!);
    }
  }

  Future<String> _uploadImageToFirebaseStorage(File imageFile) async {
    try {
      final Reference storageRef = FirebaseStorage.instance.ref();
      final Reference imageRef = storageRef.child('user_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await imageRef.putFile(imageFile);
      final String imageUrl = await imageRef.getDownloadURL();
      print('Uploaded image URL: $imageUrl');
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  void registerUser() async {
    String name = nameController.text.trim();
    String address = addressController.text.trim();

    if (name.isEmpty || selectedGender.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields.'),
      ));
      return;
    }

    try {
      var user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      // Remove the country code if it exists
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
        'phone': phone, // Store the phone number without +91
        'gender': selectedGender,
        'address': address,
        'imageUrl': imageUrl, // Use the imageUrl here
      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      print('Error registering user: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registration failed. Please try again.'),
      ));
    }
  }
}
