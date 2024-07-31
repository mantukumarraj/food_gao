import 'package:flutter/material.dart';

import '../controller/phone_controller.dart';

class OTPView extends StatelessWidget {
  final PhoneVerificationController controller = PhoneVerificationController();

  OTPView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Verification Code',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Enter the OTP sent to the mobile number ******432',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                controller.updateOTP(value);
              },
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                controller.verifyOTP();
              },
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
