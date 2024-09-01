import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/restaurant_registration_controller.dart';
import '../widget/costum_textfeld.dart';

class RestaurantEditScreen extends StatefulWidget {
  final String restaurantId;
  final Map<String, dynamic> restaurantData;

  RestaurantEditScreen({required this.restaurantId, required this.restaurantData});

  @override
  _RestaurantEditScreenState createState() => _RestaurantEditScreenState();
  }

  class _RestaurantEditScreenState extends State<RestaurantEditScreen> {
  final RegisterControllers _controller = RegisterControllers();
  File? _selectedImage;
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedCategory;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _controller.nameController.text = widget.restaurantData['name'] ?? '';
    _controller.addressController.text = widget.restaurantData['address'] ?? '';
    _controller.ownerNameController.text = widget.restaurantData['ownerName'] ?? '';
    _controller.locationController.text = widget.restaurantData['location'] ?? '';
    _controller.phonenoController.text = widget.restaurantData['phoneNo'] ?? '';
    _selectedCategory = widget.restaurantData['category'] ?? '';
    _selectedGender = widget.restaurantData['gender'] ?? '';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Restaurant"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
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
                  ),
                  child: _selectedImage != null
                      ? Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                      : widget.restaurantData['imageUrl'] != null
                      ? Image.network(
                    widget.restaurantData['imageUrl'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                      : Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'Restaurant Name',
                icon: Icons.restaurant,
                controller: _controller.nameController,
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'Address',
                icon: Icons.home,
                controller: _controller.addressController,
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'Owner Name',
                icon: Icons.person,
                controller: _controller.ownerNameController,
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'Location',
                icon: Icons.location_on,
                controller: _controller.locationController,
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
                labelText: 'Phone Number',
                icon: Icons.phone,
                controller: _controller.phonenoController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Select Restaurant Category",
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: ['Fast Food', 'Casual Dining', 'Fine Dining', 'Cafe', 'Buffet', 'Food Truck'].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
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
                        if (_controller.nameController.text.isNotEmpty &&
                            _controller.addressController.text.isNotEmpty &&
                            _controller.ownerNameController.text.isNotEmpty &&
                            _controller.locationController.text.isNotEmpty &&
                            _controller.phonenoController.text.isNotEmpty &&
                            _selectedCategory != null &&
                            _selectedGender != null) {
                          await _updateRestaurant();
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
                        'Save',
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

  Future<void> _updateRestaurant() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _controller.updateRestaurant(
        restaurantId: widget.restaurantId,
        name: _controller.nameController.text,
        address: _controller.addressController.text,
        ownerName: _controller.ownerNameController.text,
        phoneNo: _controller.phonenoController.text,
        location: _controller.locationController.text,
        gender: _selectedGender!,
        category: _selectedCategory!,
        image: _selectedImage,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Restaurant updated successfully."),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update restaurant: ${_errorMessage}"),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
