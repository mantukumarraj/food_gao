import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodgeo_partner/views/screen/home_page.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/restaurant_registration_controller.dart';
import '../widget/costum_textfeld.dart';
import 'package:flutter/services.dart';

class RestaurantRegistrationPage extends StatefulWidget {
  @override
  _RestaurantRegistrationPageState createState() => _RestaurantRegistrationPageState();
}

class _RestaurantRegistrationPageState extends State<RestaurantRegistrationPage> {
  final RegisterControllers _controller = RegisterControllers();
  File? _selectedImage;
  bool _isLoading = false;
  String? _selectedCategory;
  String? _selectedGender;
  final _formKey = GlobalKey<FormState>();

  final List<String> _categories = [
    'Fast Food',
    'Casual Dining',
    'Fine Dining',
    'Cafe',
    'Buffet',
    'Food Truck',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = _controller.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "Restaurant Registration",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
          },
        ),
      ),

        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
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
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                      image: _selectedImage != null
                          ? DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _selectedImage == null
                        ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Restaurant Name',
                  icon: Icons.restaurant,
                  controller: _controller.nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the restaurant name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Address',
                  icon: Icons.home,
                  controller: _controller.addressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Owner Name',
                  icon: Icons.person,
                  controller: _controller.ownerNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the owner name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Phone Number',
                  icon: Icons.phone,
                  controller: _controller.phonenoController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gender",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text('Male'),
                            leading: Radio<String>(
                              value: 'Male',
                              groupValue: _selectedGender,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('Female'),
                            leading: Radio<String>(
                              value: 'Female',
                              groupValue: _selectedGender,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Location',
                  icon: Icons.location_on,
                  controller: _controller.locationController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Select Restaurant Category",
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  value: _categories.contains(_selectedCategory)
                      ? _selectedCategory
                      : null,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                      _controller.category = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 45,
                      child: MaterialButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Please select an image."),
                                ),
                              );
                              return;
                            }
                            await _registerRestaurant();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please fill all fields."),
                              ),
                            );
                          }
                        },
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'Restaurant Register ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (_isLoading)
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _registerRestaurant() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Call the registration method
      await _controller.registerUser(_selectedGender!, _selectedImage!);

      // Show success message and navigate to HomePage
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Restaurant uploaded successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to HomePage
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
      });

    } catch (e) {
      // Handle registration error (e.g., show error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to upload restaurant: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}