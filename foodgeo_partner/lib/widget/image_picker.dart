import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File) onImagePicked;
  final File? initialImage; // Optional parameter

  ImagePickerWidget({required this.onImagePicked, this.initialImage});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialImage != null) {
      _pickedImage = widget.initialImage;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
        widget.onImagePicked(_pickedImage!);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _pickedImage != null
            ? CircleAvatar(
          radius: 60,
          backgroundImage: FileImage(_pickedImage!),
          onBackgroundImageError: (_, __) {
            setState(() {
              _pickedImage = null; // Reset image on error
            });
          },
        )
            : CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade200,
          child: Icon(Icons.person, size: 60, color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ],
    );
  }
}
