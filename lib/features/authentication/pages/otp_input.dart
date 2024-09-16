import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpInput extends StatefulWidget {
  final TextEditingController controller; // Replaced OTPController with TextEditingController

  const OtpInput({super.key, required this.controller});

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: 6,
      defaultPinTheme: PinTheme(
        width: MediaQuery.of(context).size.width * 0.08, // 8% of screen width
        height: MediaQuery.of(context).size.width * 0.08, // Keeping height proportional to width
        textStyle: TextStyle(fontSize: 20, color: Colors.white),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purple),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      focusedPinTheme: PinTheme(
        width: MediaQuery.of(context).size.width * 0.08,
        height: MediaQuery.of(context).size.width * 0.08,
        textStyle: TextStyle(fontSize: 20, color: Colors.purple.shade900),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purple.shade900),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      submittedPinTheme: PinTheme(
        width: MediaQuery.of(context).size.width * 0.08,
        height: MediaQuery.of(context).size.width * 0.08,
        textStyle: TextStyle(fontSize: 20, color: Colors.white),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
          color: Colors.purple.shade900,
        ),
      ),
      onCompleted: (otp) {
        widget.controller.text = otp; // Update the TextEditingController with the entered OTP
      },
      keyboardType: TextInputType.number,
      pinAnimationType: PinAnimationType.scale,
      autofocus: true,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit, // Automatically validate as user types
    );
  }
}

