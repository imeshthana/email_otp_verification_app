import 'package:email_otp/email_otp.dart';
import 'package:email_otp_verification_app/screens/send_otp_screen.dart';
import 'package:flutter/material.dart';

void main() {
  EmailOTP.config(
    appName: 'EmailOtpVerify',
    expiry: 1000*60*2, // 2 minutes
    otpLength: 6,
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v4,
  );
  runApp(
   const EmailOtpVerify(),
  );
}

class EmailOtpVerify extends StatelessWidget {
  const EmailOtpVerify({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Email Verification',
      home: SendOtpScreen(),
    );
  }
}
