// import 'package:flutter/material.dart';
// import 'package:foodgeo_partner/views/screen/phone_verification_screen.dart';
// import 'dart:io';
//
// import '../../controller/register_controllers.dart';
// import '../widget/costum_buttom.dart';
// import '../widget/costum_textfeld.dart';
// import '../widget/image_picker_widget.dart';
// import 'login_screen.dart';
// import 'otpverification_screen.dart';
//
// class RegistrationPage extends StatefulWidget {
//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }
//
// class _RegistrationPageState extends State<RegistrationPage> {
//   final RegistrationController _controller = RegistrationController();
//   String _selectedGender = 'Male';
//   File? _selectedImage;
//   bool _isLoading = false;
//   String? _errorMessage;
//
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final screenHeight = mediaQuery.size.height;
//     final screenWidth = mediaQuery.size.width;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: double.infinity,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFFFA726), Color(0xFF424242)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: screenHeight * 0.1),
//             child: Container(
//               height: screenHeight * 0.9,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(40),
//                   topRight: Radius.circular(40),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
//                 child: Column(
//                   children: [
//                     SizedBox(height: screenHeight * 0.02),
//                     Text(
//                       "Register",
//                       style: TextStyle(
//                         fontSize: screenHeight * 0.04,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF424242),
//                       ),
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     ImagePickerWidget(
//                       onImagePicked: (image) {
//                         _selectedImage = image;
//                       },
//                     ),
//                     SizedBox(height: screenHeight * 0.03),
//                     CustomTextField(
//                       labelText: "Name",
//                       icon: Icons.person,
//                       controller: _controller.nameController,
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     CustomTextField(
//                       labelText: "Address",
//                       icon: Icons.location_on,
//                       controller: _controller.addressController,
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Radio<String>(
//                                 value: 'Male',
//                                 groupValue: _selectedGender,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _selectedGender = value!;
//                                   });
//                                 },
//                               ),
//                               Text('Male'),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Radio<String>(
//                                 value: 'Female',
//                                 groupValue: _selectedGender,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _selectedGender = value!;
//                                   });
//                                 },
//                               ),
//                               Text('Female'),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     CustomTextField(
//                       labelText: "Email",
//                       icon: Icons.email,
//                       controller: _controller.emailController,
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     CustomTextField(
//                       labelText: "Password",
//                       icon: Icons.lock,
//                       controller: _controller.passwordController,
//                       obscureText: true,
//                     ),
//                     SizedBox(height: screenHeight * 0.03),
//                     if (_errorMessage != null)
//                       Padding(
//                         padding: EdgeInsets.only(bottom: screenHeight * 0.02),
//                         child: Text(
//                           _errorMessage!,
//                           style: TextStyle(color: Colors.red),
//                         ),
//                       ),
//                     if (_isLoading)
//                       CircularProgressIndicator(),
//                     if (!_isLoading)
//                       CustomButton(
//                         text: "Register",
//                         onPressed: () async {
//                           setState(() {
//                             _isLoading = true;
//                             _errorMessage = null;
//                           });
//                           try {
//                             if (_selectedImage == null) {
//                               throw Exception("Please select an image.");
//                             }
//                             await _controller.registerUser(_selectedGender, _selectedImage!);
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(builder: (context) => PhoneAuthView()),
//                             );
//                           } catch (e) {
//                             setState(() {
//                               _errorMessage = e.toString();
//                             });
//                           } finally {
//                             setState(() {
//                               _isLoading = false;
//                             });
//                           }
//                         },
//                         height: screenHeight * 0.07,
//                         width: screenWidth * 0.8,
//                       ),
//                     SizedBox(height: screenHeight * 0.05),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
//                       },
//                       child: Text(
//                         "Already have an account? Sign in",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgeo_partner/home_page.dart';
import 'package:foodgeo_partner/views/screen/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'colors.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegistrationPage> {
  bool isMale = true;
  String selectedGender = 'Male';
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
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
                  image: AssetImage("assets/Images/img_4.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                padding: EdgeInsets.only(top: 70, left: 20),
                color: Color(0xFF3b5999).withOpacity(.85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Welcome to",
                        style: TextStyle(
                          fontSize: 25,
                          letterSpacing: 2,
                          color: Colors.yellow[700],
                        ),
                        children: [
                          TextSpan(
                            text: " FoodGeo,",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow[700],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Signup to Continue",
                      style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            curve: Curves.bounceInOut,
            top: 200,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              height: 390,
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
            top: 200,
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
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
          buildTextField(
            Icons.account_circle_outlined,
            "User Name",
            userNameController,
            false,
            false,
          ),
          SizedBox(height: 10,),
          buildTextField(
            Icons.email_outlined,
            "Email",
            emailController,
            false,
            true,
          ),
          buildGenderField(),
          SizedBox(height: 20),
          buildTextField(
            Icons.location_on_outlined,
            "Address",
            addressController,
            false,
            false,
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: registerUser,
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
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
              SizedBox(
                width: 30,
              ),
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

  Widget buildTextField(
      IconData icon,
      String hintText,
      TextEditingController controller,
      bool isPassword,
      bool isEmail,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Palette.iconColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _uploadImageToFirebaseStorage(_imageFile!);
      }
    });
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _uploadImageToFirebaseStorage(_imageFile!);
      }
    });
  }

  Future<String> _uploadImageToFirebaseStorage(File imageFile) async {
    try {
      final Reference storageRef = FirebaseStorage.instance.ref();
      final Reference imageRef = storageRef.child('usersimages/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await imageRef.putFile(imageFile);
      final String imageUrl = await imageRef.getDownloadURL();
      print('Uploaded image URL: $imageUrl');
      return imageUrl; // Return the download URL
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return ''; // Return empty string in case of error
    }
  }

  void registerUser() async {
    String userName = userNameController.text.trim();
    String email = emailController.text.trim();
    String address = addressController.text.trim();

    if (userName.isEmpty || email.isEmpty || address.isEmpty) {
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

      String imageUrl = await _uploadImageToFirebaseStorage(_imageFile!);

      await FirebaseFirestore.instance.collection('users1').doc(user.uid).set({
        'userId': user.uid,
        'userName': userName,
        'email': email,
        'gender': selectedGender,
        'address': address,
        'imageUrl': imageUrl, // Use the imageUrl here
      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(title: 'home',)));
    } catch (e) {
      print('Error registering user: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registration failed. Please try again.'),
      ));
    }
  }

}
