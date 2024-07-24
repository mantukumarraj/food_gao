import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final double radius;
  final File? image;
  final Function(File?) onImagePicked;

  const ImagePickerWidget({
    super.key,
    required this.radius,
    required this.image,
    required this.onImagePicked,
  });

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      File? image = File(pickedFile.path);
      widget.onImagePicked(image);
    } else {
      print('No image selected.');
      widget.onImagePicked(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SafeArea(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('Gallery'),
                        onTap: () async {
                          Navigator.of(context).pop();
                          await _pickImage(ImageSource.gallery);
                        }),
                    ListTile(
                      leading: Icon(Icons.photo_camera),
                      title: Text('Camera'),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await _pickImage(ImageSource.camera);
                      },
                    ),
                  ],
                ),
              );
            });
      },
      child: CircleAvatar(
        radius: widget.radius,
        backgroundImage: widget.image != null ? FileImage(widget.image!) : null,
        child: widget.image == null
            ? Icon(
          Icons.add_a_photo,
          size: widget.radius,
        )
            : null,
      ),
    );
  }
}
