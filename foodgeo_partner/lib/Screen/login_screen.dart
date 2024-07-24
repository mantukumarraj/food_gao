import 'package:flutter/material.dart';
import 'package:foodgeo_partner/Screen/verification_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    final padding = mediaQuery.padding;
    final safeAreaHeight = height - padding.top - padding.bottom;
    TextEditingController phoneText = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://www.strategyboffins.com/wp-content/uploads/2021/06/food-1536x864.jpg',
              ),
              SizedBox(height: safeAreaHeight * 0.03),
              Text(
                "India's #1 Food Delivery ",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: safeAreaHeight * 0.01),
              Text(
                "and Dining App ",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          indent: 15,
                          endIndent: 10,
                          // Adjust endIndent as needed
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Login in or sign up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      Expanded(
                        child: Divider(
                          indent: 10, endIndent: 15, // Adjust indent as needed
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: safeAreaHeight * 0.04),
              Container(
                margin: EdgeInsets.only(left: 18, right: 18),
                child: IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'IN',
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                  controller: phoneText,
                ),
              ),
              SizedBox(height: safeAreaHeight * 0.03),
              Container(
                width: double.infinity,
                height: 45,
                margin: EdgeInsets.only(left: 18, right: 18),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OTPVerificationScreen(
                              phoneNumber: phoneText.text),
                        ));
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          endIndent: 10,
                          indent: 20, // Adjust endIndent as needed
                          color: Colors.grey,
                        ),
                      ),
                      Text('or'),
                      Expanded(
                        child: Divider(
                          indent: 10,
                          endIndent: 20, // Adjust indent as needed
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 50), // Add spacing before the icon buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: TextButton(
                        onPressed: () {},
                        child: Text("G",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 25))),
                  ),
                  SizedBox(width: 20), // Add spacing between the icons
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.more_horiz),
                      iconSize: safeAreaHeight * 0.04,
                      onPressed: () {
                        // Handle other login options
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: safeAreaHeight * 0.02),
              Text(
                'By continuing, you agree to our Terms of Service, Privacy Policy, and Content Policy',
                style: TextStyle(fontSize: safeAreaHeight * 0.015),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: safeAreaHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
