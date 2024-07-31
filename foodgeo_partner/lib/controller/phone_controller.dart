

import '../models/phone_model.dart';

class PhoneVerificationController {
  final UserModel user = UserModel(phoneNumber: '', otp: '');

  void updatePhoneNumber(String phoneNumber) {
    user.phoneNumber = phoneNumber;
  }

  void updateOTP(String otp) {
    user.otp = otp;
  }

  void sendOTP() {
    // Add logic to send OTP to the user's phone number
  }

  void verifyOTP() {
    // Add logic to verify the OTP entered by the user
  }
}
