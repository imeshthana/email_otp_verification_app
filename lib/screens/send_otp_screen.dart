import 'dart:async';
import 'package:email_otp/email_otp.dart';
import 'package:email_otp_verification_app/screens/verify_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({super.key});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool showOtp = false;
  bool showSendProgress = false;
  bool showResend = false;
  late Timer timer;
  int countdown = 120;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          showOtp = false;
          emailController.clear();
          otpController.clear();
          timer.cancel();
        }
      });
    });
  }

  sendOtp() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text("Email is required"))));
      return;
    }
    if (emailController.text.contains('@') == false ||
        emailController.text.contains('.') == false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text("Enter a valid email"))));
      return;
    }
    setState(() {
      showSendProgress = true;
    });
    if (await EmailOTP.sendOTP(email: emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Center(child: Text("OTP has been sent to your email"))));
      setState(() {
        showSendProgress = false;
        showOtp = true;
        countdown = 120;
      });
      startTimer();
    } else {
      setState(() {
        showSendProgress = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text("OTP sent failed"))));
    }
  }

  verifyOtp() {
    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Center(
              child: Text("Enter the OTP which has been sent to your email"))));
      return;
    }
    bool verify = EmailOTP.verifyOTP(otp: otpController.text);
    if (verify) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const VerifyOtpScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text("OTP failed"))));
    }
  }

  @override
  void dispose() {
    timer.cancel();
    emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Center(
            child: Text(
          'Email Verification',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter Your Email',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.5),
                ),
                hintText: 'Eg: example@gmail.com',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                labelText: '',
                labelStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            showOtp ? const Text('Didn\'t receive the otp code?') : Container(),
            showOtp ? const SizedBox(height: 10) : Container(),
            showSendProgress
                ? const CircularProgressIndicator(
                    color: Colors.blueAccent,
                  )
                : showOtp
                    ? ElevatedButton(
                        style: ButtonStyle(
                          padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 20)),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.blueAccent),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            showSendProgress = true;
                          });
                          sendOtp();
                        },
                        child: const Text('Resend OTP'),
                      )
                    : ElevatedButton(
                        style: ButtonStyle(
                          padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 20)),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.blueAccent),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                        ),
                        onPressed: sendOtp,
                        child: const Text('Send OTP'),
                      ),
            const SizedBox(height: 50),
            showOtp
                ? const Text(
                    'Verification Code',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  )
                : Container(),
            showOtp ? const SizedBox(height: 20) : Container(),
            showOtp
                ? Pinput(
                    controller: otpController,
                    length: 6,
                    defaultPinTheme: PinTheme(
                      textStyle: const TextStyle(fontSize: 30, color: Colors.black),
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        color:const Color.fromARGB(38, 68, 137, 255),
                        border:
                            Border.all(color:const Color(0xFF448AFF), width: 2.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      textStyle: const TextStyle(fontSize: 30, color: Colors.black),
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        color:const Color.fromARGB(38, 68, 137, 255),
                        border:
                            Border.all(color: Colors.blueAccent, width: 2.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                : Container(),
            showOtp ? const SizedBox(height: 20) : Container(),
            showOtp
                ? ElevatedButton(
                    style: ButtonStyle(
                      padding:const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 20)),
                      backgroundColor:
                          WidgetStateProperty.all(Colors.blueAccent),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      verifyOtp();
                    },
                    child: const Text('Verify Email'),
                  )
                : Container(),
            showOtp ? const SizedBox(height: 10) : Container(),
            showOtp
                ? Text(
                    'OTP is expired in $countdown seconds',
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
