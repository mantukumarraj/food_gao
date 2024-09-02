import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../views/screen/home_page.dart';

class ProductAdd extends StatefulWidget {
  final String restaurantId;

  const ProductAdd({Key? key, required this.restaurantId}) : super(key: key);

  @override
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _itemsController;
  bool _imageError = false;

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
        _imageError = false;
      }
    });
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _imageError = false;
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null || !_formKey.currentState!.validate() || _selectedCategory == null) {
      if (_imageFile == null) {
        setState(() {
          _imageError = true;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() {
      _isLoading = true;
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
        'partnerId': userId,
      };

      await FirebaseFirestore.instance.collection('products').doc(productId).set(productData);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Product uploaded successfully')));

      await Future.delayed(Duration(seconds: 2));

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
                      border: Border.all(
                        color: _imageError ? Colors.red : Colors.grey,
                        width: 2,
                      ),
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
                if (_imageError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Please select your product image',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _itemsController,
                  decoration: InputDecoration(
                    labelText: 'Items',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of items';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.orange),
                ),
                SizedBox(height: 20),
                MaterialButton(
                  height: 45,
                  onPressed: _isLoading ? null : () async {
                    setState(() {
                      _imageError = _imageFile == null;
                    });
                    if (_formKey.currentState!.validate() && _imageFile != null) {
                      setState(() {
                        _isLoading = true;
                      });
                      await _uploadImage();
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  )
                      : Text(
                    ' Product Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}