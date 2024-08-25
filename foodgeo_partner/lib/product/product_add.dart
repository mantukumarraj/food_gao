import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgeo_partner/views/screen/home_page.dart';
import 'package:uuid/uuid.dart';

class ProductAdd extends StatefulWidget {
  final String restaurantId;

  const ProductAdd({Key? key, required this.restaurantId}) : super(key: key);

  @override
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? _imageFile;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _itemsController;

  final List<String> _categories = [
    'Appetizer',
    'Main Course',
    'Dessert',
    'Beverage',
  ];

  String? _selectedCategory;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _itemsController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _itemsController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null ||
        _nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _itemsController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final String? userId = user?.uid;

      if (userId == null) {
        throw 'User not logged in';
      }

      final ref = _storage.ref().child(
          'productImage/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(_imageFile!);

      final downloadUrl = await ref.getDownloadURL();

      final String name = _nameController.text;
      final String description = _descriptionController.text;
      final String price = _priceController.text;
      final String items = _itemsController.text;

      final String productId = Uuid().v4();

      final Map<String, dynamic> productData = {
        'productId': productId,
        'name': name,
        'description': description,
        'price': price,
        'items': items,
        'category': _selectedCategory,
        'image': downloadUrl.toString(),
        'restaurantId': widget.restaurantId,
        'userId': userId,
      };

      await FirebaseFirestore.instance.collection('products').doc(productId).set(productData);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Product uploaded successfully')));

      await Future.delayed(Duration(seconds: 2)); // Delay for 2 seconds to show the message

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          "Product Add",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                    image: _imageFile != null
                        ? DecorationImage(
                      image: FileImage(File(_imageFile!.path)),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _imageFile == null
                      ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _itemsController,
                decoration: InputDecoration(
                  labelText: 'Items',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: Text('Select food Category'),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                isExpanded: true, // Make dropdown expand to fill available space
                icon: Icon(Icons.arrow_drop_down, color: Colors.orange), // Customize dropdown icon
              ),
              SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 45,
                    child: MaterialButton(
                      onPressed: _isLoading ? null : () async {
                        await _uploadImage();
                      },
                      color: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'Add Product',
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
}
