

import 'package:flutter/material.dart';
import 'otp_input.dart'; // Assuming you have the OtpInput widget from the previous code.

class OTPView extends StatefulWidget {
  final String? email;


  OTPView({Key? key, required this.email}) : super(key: key);

  @override
  _OTPViewState createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  bool _isLoading = false;
  String _errorMessage = '';
  final TextEditingController otpDigitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: otpBodySection(screenHeight, screenWidth),
        ),
      ),
    );
  }

  SingleChildScrollView otpBodySection(double screenHeight, double screenWidth) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          color: Color(0xD8BFD8),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              otpPageHeader(),
              SizedBox(height: screenHeight * 0.02),
              imageSection(),
              const Text(
                'We have sent you an OTP to verify your account.', // Replaced constant
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              SizedBox(height: screenHeight * 0.03),
              otpInputSectionText(),
              SizedBox(height: screenHeight * 0.04),
              OtpInput(controller: otpDigitController), // Pass the TextEditingController
              SizedBox(height: screenHeight * 0.02),
              didntReceivedCodeSection(),
              SizedBox(height: screenHeight * 0.02),
              VerifyButton(screenHeight: screenHeight, screenWidth: screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget VerifyButton({required double screenHeight, required double screenWidth}) {
    return ElevatedButton(
      onPressed: () {
        // Fetch the OTP from otpDigitController and simulate verification
        String otpCode = otpDigitController.text; // Fetch the entered OTP
        print('OTP Code entered: $otpCode'); // Print OTP for debugging
        print('Email: ${widget.email ?? ''}'); // Print email for debugging

        if (otpCode.isNotEmpty) {
          setState(() {
            _isLoading = true;
          });

          // Simulate OTP verification process
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _isLoading = false;
              _errorMessage = ''; // Set this to empty if OTP is valid
            });

            // Handle success scenario
            print('OTP verification successful');
          });
        } else {
          setState(() {
            _errorMessage = 'Invalid OTP';
          });

          // Display a snackbar if there's an error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Text("Verify"),
    );
  }

  Widget otpPageHeader() {
    return const Text(
      'Verify Account',
      style: TextStyle(
          color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 30),
    );
  }

  Widget didntReceivedCodeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Didn\'t receive the code?',
          style: TextStyle(color: Colors.grey, fontSize: 20),
        ),
        TextButton(
          onPressed: () {
            // Logic for resending OTP
            print('Resend OTP');
          },
          child: Text(
            'Resend',
            style: TextStyle(color: Colors.purple, fontSize: 20),
          ),
        ),
      ],
    );
  }

  Widget imageSection() {
    return Image.asset(
      'assets/app_image.png', // Replace with your actual image asset
      height: 200,
      width: 200,
      fit: BoxFit.fill,
    );
  }

  Widget otpInputSectionText() {
    return Text(
      'We have sent an OTP to your email: ${widget.email.toString()}. Please enter it below to complete the verification.',
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.grey, fontSize: 20),
    );
  }
}



// Create a new file: lib/Constants/assets_constants.dart
class AssetConstants {
  static const String appImage = 'assets/images/otp_image.webp';
// Replace with your actual image path
}

class StringConstants {
  static const String verifyAccount = "Verify Your Account";
  static const String didntReceivedCode = "Didn't receive the code?";
  static const String resendBtnLabel = " Resend";
  static const String mobileVerifySuccess = "OTP sent successfully!";
  static const String sentOtpOn1 = "We have sent an OTP to your mobile number: ";
  static const String enterToCompleteVerification = "\nEnter it to complete verification.";
}

