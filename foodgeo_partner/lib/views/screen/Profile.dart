import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _genderController = TextEditingController();
  final _imageUrlController = TextEditingController();
  File? _imageFile;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    DocumentSnapshot doc = await docRef.get();
    var data = doc.data() as Map<String, dynamic>;

    setState(() {
      _nameController.text = data['name'] ?? '';
      _addressController.text = data['address'] ?? '';
      _genderController.text = data['gender'] ?? '';
      _imageUrlController.text = data['imageUrl'] ?? '';
    });
  }

  Future<void> _updateProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String imageUrl = _imageUrlController.text; // Existing image URL

    // If a new image is selected, upload it to Firebase Storage
    if (_imageFile != null) {
      final fileName = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child('user_images/$fileName');

      try {
        await storageRef.putFile(_imageFile!);
        imageUrl = await storageRef.getDownloadURL();
      } catch (e) {
        print('Failed to upload image: $e');
        // You can also show an error message to the user
      }
    }

    // Update Firestore with the new profile data
    DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    await docRef.update({
      'name': _nameController.text,
      'address': _addressController.text,
      'gender': _genderController.text,
      'imageUrl': imageUrl, // Update the image URL if it changed
    });

    setState(() {
      _isEditing = false;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageUrlController.text = pickedFile.path; // Update the URL controller
      });
    }
    Navigator.pop(context); // Close the bottom sheet
  }

  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white,),
          textAlign: TextAlign.center,
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the back icon color to white
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (_isEditing) {
            setState(() {
              _isEditing = false;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView( // Added SingleChildScrollView
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : _imageUrlController.text.isNotEmpty
                                ? NetworkImage(_imageUrlController.text)
                                : AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                            backgroundColor: Colors.grey[200],
                          ),
                          Positioned(
                            left: 120,
                            top: 100,
                            child: IconButton(
                              icon: Icon(Icons.add_a_photo,
                                  color: Colors.deepOrange, size: 30),
                              onPressed: _showImagePickerSheet,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _isEditing
                          ? Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(labelText: 'Name'),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(labelText: 'Address'),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _genderController,
                            decoration: InputDecoration(labelText: 'Gender'),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: _updateProfile,
                                child: Text('Save',style: TextStyle(fontSize: 20,color: Colors.deepOrange),),
                              ),
                              SizedBox(width: 16), // Space between the buttons
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditing = false;
                                  });
                                },
                                child: Text('Cancel',style: TextStyle(fontSize: 20,color: Colors.deepOrange),),
                              ),
                            ],
                          ),
                        ],
                      )
                          : Column(
                        children: [
                          Text(
                            'Name: ${_nameController.text}',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Address: ${_addressController.text}',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Gender: ${_genderController.text}',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                            child: Text('Edit Profile',style: TextStyle(color: Colors.deepOrange),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
