import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'home_page.dart';

class EditProfile extends StatefulWidget {
  final String initialName;
  final String initialphoneNumber;
  final String initialgender;
  final String initialaddress;
  final String initialImageUrl;

  const EditProfile({
    Key? key,
    required this.initialName,
    required this.initialphoneNumber,
    required this.initialgender,
    required this.initialaddress,
    required this.initialImageUrl,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  late TextEditingController genderController;
  late TextEditingController addressController;
  PickedFile? _image;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    phoneNumberController = TextEditingController(text: widget.initialphoneNumber);
    genderController = TextEditingController(text: widget.initialgender);
    addressController = TextEditingController(text: widget.initialaddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 20.0,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showImagePicker(context);
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null
                            ? FileImage(File(_image!.path)) as ImageProvider<Object>
                            : NetworkImage(widget.initialImageUrl),
                        child: _image == null
                            ? Icon(Icons.add_a_photo, size: 50, color: Colors.white)
                            : SizedBox.shrink(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(nameController, 'Name'),
                  SizedBox(height: 20.0),
                  _buildTextField(phoneNumberController, 'Phone No'),
                  SizedBox(height: 20.0),
                  _buildTextField(genderController, 'Gender'),
                  SizedBox(height: 20.0),
                  _buildTextField(addressController, 'Address'),
                  SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: Text('Save', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(160.0, 60.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 40.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }

  void _showImagePicker(BuildContext context) {
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
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = PickedFile(pickedFile.path);
      }
    });
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = PickedFile(pickedFile.path);
      }
    });
  }

  Future<void> _saveProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        String imageUrl = widget.initialImageUrl;

        // Upload image to Firebase Storage if a new image is selected
        if (_image != null) {
          imageUrl = await _updateImageInFirebaseStorage(_image!.path);
        }

        // Update user data in Firestore
        await FirebaseFirestore.instance.collection('users1').doc(user.uid).update({
          'userName': nameController.text,
          'phoneNumber': phoneNumberController.text,
          'gender': genderController.text,
          'address': addressController.text,
          'imageUrl': imageUrl, // Update image URL
        });

        // Navigate to home page after successful update
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (error) {
        print('Error updating user data: $error');
        // Handle error (e.g., show a message to the user)
        _showErrorDialog('Failed to update profile. Please try again.');
      }
    }
  }

  Future<String> _updateImageInFirebaseStorage(String newFilePath) async {
    try {
      final File newImageFile = File(newFilePath);
      final Reference storageRef = FirebaseStorage.instance.ref();

      // Delete existing image from storage if not default image
      if (widget.initialImageUrl.isNotEmpty) {
        await FirebaseStorage.instance.refFromURL(widget.initialImageUrl).delete();
      }

      // Upload new image to storage
      final Reference imageRef = storageRef.child('usersimages/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await imageRef.putFile(newImageFile);

      // Get the updated image URL
      final String newImageUrl = await imageRef.getDownloadURL();
      print('Updated image URL: $newImageUrl');

      // Return the new image URL
      return newImageUrl;
    } catch (e) {
      print('Error updating image in Firebase Storage: $e');
      _showErrorDialog('Failed to upload image. Please try again.');
      return widget.initialImageUrl; // Fallback to the initial image URL in case of error
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
