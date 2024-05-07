import 'package:flutter/material.dart';
import 'dart:async';
import 'rst_pw.dart'; // Import the rst_pw.dart file

class ForgotPasswordOTPScreen extends StatefulWidget {
  final String emailAddress;

  const ForgotPasswordOTPScreen({super.key, required this.emailAddress});

  @override
  State<ForgotPasswordOTPScreen> createState() =>
      _ForgotPasswordOTPScreenState();
}

class _ForgotPasswordOTPScreenState extends State<ForgotPasswordOTPScreen> {
  late final String _emailAddress;
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  late Timer _timer;
  int _countdown = 59;
  bool _isCountdownFinished = false;

  @override
  void initState() {
    super.initState();
    _emailAddress = widget.emailAddress;
    _startCountdown();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _isCountdownFinished = true;
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 60, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text(
                'Forgot Password',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.5,
                  letterSpacing: -0.019,
                  color: Color(0xFF621B2B),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    letterSpacing: -0.019,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(
                        text:
                            'Please provide the OTP sent to your email address '),
                    TextSpan(
                      text: _emailAddress,
                      style: const TextStyle(
                        color: Color(0xFF621B3B),
                      ),
                    ),
                    const TextSpan(text: ' to continue'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Container(
                width: 338,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < 6; i++) _buildOTPBox(i),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: _isCountdownFinished
                  ? GestureDetector(
                      onTap: () {
                        // Add your logic to resend the OTP code here
                      },
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            letterSpacing: -0.019,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(text: "Didn't get the code? "),
                            TextSpan(
                              text: 'Resend code',
                              style: TextStyle(
                                color: Color(0xFF621B2B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          letterSpacing: -0.019,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(text: 'Resend OTP in '),
                          TextSpan(
                            text: _countdown.toString(),
                            style: const TextStyle(
                              color: Color(0xFF621B2B),
                            ),
                          ),
                          const TextSpan(
                            text: 's',
                            style: TextStyle(
                              color: Color(0xFF621B2B),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 40),
            Center(
              child: GestureDetector(
                onTap: () {
                  // Check if the OTP boxes are filled with the correct values
                  bool isOTPCorrect = true;
                  for (var controller in _otpControllers) {
                    if (controller.text != '0') {
                      isOTPCorrect = false;
                      break;
                    }
                  }

                  if (isOTPCorrect) {
                    // Navigate to the ResetPasswordScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPasswordScreen(),
                      ),
                    );
                  } else {
                    ('Incorrect OTP');
                  }
                },
                child: Container(
                  width: 337,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE5AA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                        color: Color(0xFF621B2B),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPBox(int index) {
    return SizedBox(
      width: 46.23,
      height: 48,
      child: TextField(
        controller: _otpControllers[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        obscureText: true, // Hide the digit
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: Color(0xFFD8D7D7),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: Color(0xFF621B2B),
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < _otpControllers.length - 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
