import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodgeo_partner/home_page.dart';
import '../../widget/costum_textfield.dart';
import '../../widget/image_picker.dart';
import '../widget/costum_buttom.dart';
import '../widget/costum_textfeld.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _uploadProduct() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(_selectedImage!);
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'imageUrl': imageUrl,
        'timestamp': Timestamp.now(),
        'userId': user.uid,
      });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully')),
      );

      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      setState(() {
        _selectedImage = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ImagePickerWidget(
              onImagePicked: (image) {
                setState(() {
                  _selectedImage = image;
                });
              },
            ),
            SizedBox(height: 20),
            CustomTextField(
              labelText: 'Product Name',
              icon: Icons.title,
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a product name';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            CustomTextField(
              labelText: 'Product Description',
              icon: Icons.description,
              controller: _descriptionController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a product description';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            CustomTextField(
              labelText: 'Product Price',
              icon: Icons.attach_money,
              controller: _priceController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                final price = double.tryParse(value);
                if (price == null || price <= 0) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            _isUploading
                ? Center(child: CircularProgressIndicator())
                : CustomButton(
              text: 'Add Product',
              onPressed: _uploadProduct,
              height: 50,
              width: double.infinity,
            ),

            CostumTextfield().customTextField(labelText: "Enter your Name", icon: Icons.person, controller: _nameController,keyboardType: TextInputType.text)
          ],
        ),
      ),
    );
  }
}
