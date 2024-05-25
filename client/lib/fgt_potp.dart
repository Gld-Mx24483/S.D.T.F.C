// ignore_for_file: unnecessary_const, avoid_print, unused_element

import 'dart:async';
import 'dart:math';

import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'rst_pw.dart';

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
  String _generatedOTP = '';

  @override
  void initState() {
    super.initState();
    _emailAddress = widget.emailAddress;
    _generatedOTP = _generateAndSendOTP();
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
    _countdown = 59;
    _isCountdownFinished = false;
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

  String _generateAndSendOTP() {
    String generatedOTP = _generateOTP();
    _sendEmailWithOTP(generatedOTP);
    return generatedOTP;
  }

  String _generateOTP() {
    String generatedOTP = (Random().nextInt(900000) + 100000).toString();
    return generatedOTP;
  }

  void _sendEmailWithOTP(String otp) async {
    Map<String, dynamic> templateParams = {
      'email': _emailAddress,
      'otp': otp,
    };

    try {
      await EmailJS.send(
        'service_rgvnw3a',
        'template_puliazp',
        templateParams,
        const Options(
          publicKey: 'Y3vM6rPSqkT_78sNU',
          privateKey: 'FqqqBbPwWL0NYv09OdSuE',
        ),
      );
      print('Email sent successfully');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  void _validateOTPAndProceed() {
    String enteredOTP = '';
    for (var controller in _otpControllers) {
      enteredOTP += controller.text;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingModal(
        showNextModal: enteredOTP == _generatedOTP
            ? _showVerificationSuccessModal
            : _showVerificationFailedModal,
      ),
    );
  }

  void _showVerificationSuccessModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VerificationSuccessModal(
        onContinue: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ResetPasswordScreen(),
            ),
          );
        },
      ),
    );
  }

  void _showVerificationFailedModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const VerificationFailedModal(),
    );
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text(
                'Forgot Password',
                style: GoogleFonts.nunito(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.5,
                  letterSpacing: -0.019,
                  color: const Color(0xFF621B2B),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.nunito(
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
              child: Column(
                children: [
                  Container(
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
                  const SizedBox(height: 16),
                  // Text(
                  //   'Generated OTP: $_generatedOTP',
                  //   style: const TextStyle(
                  //     fontFamily: 'SF Pro Display',
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black,
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: _isCountdownFinished
                  ? GestureDetector(
                      onTap: _handleResendCode,
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            letterSpacing: -0.019,
                            color: Colors.black,
                          ),
                          children: const [
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
                        style: GoogleFonts.nunito(
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
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 30.0),
              child: GestureDetector(
                onTap: _validateOTPAndProceed,
                child: Container(
                  width: 337,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE5AA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                        color: const Color(0xFF621B2B),
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
        obscureText: true,
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
          } else if (value.isEmpty) {
            if (index > 0) {
              FocusScope.of(context).previousFocus();
            }
          }
        },
        onSubmitted: (value) {},
      ),
    );
  }

  // void _handleResendCode() {
  //   _generatedOTP = _generateAndSendOTP();
  //   _startCountdown();
  // }

  void _handleResendCode() {
    _generatedOTP = _generateAndSendOTP();
    _startCountdown();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingModal(
        showNextModal: () {
          // No need to do anything here
        },
      ),
    );
  }
}

class LoadingModal extends StatefulWidget {
  const LoadingModal({super.key, required this.showNextModal});
  final Function showNextModal;
  @override
  LoadingModalState createState() => LoadingModalState();
}

class LoadingModalState extends State<LoadingModal> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pop();
      widget.showNextModal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 812,
      color: const Color(0xFF000000).withOpacity(0.7),
      child: Center(
        child: Container(
          width: 260,
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            color: Color(0xFFFAF6EB),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFBE5AA)),
              ),
              const SizedBox(width: 20),
              Text(
                'Please wait...',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF212121),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerificationSuccessModal extends StatelessWidget {
  const VerificationSuccessModal({super.key, required this.onContinue});
  final VoidCallback onContinue;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 812,
      color: const Color(0xFF000000).withOpacity(0.7),
      child: Center(
        child: Container(
          width: 329,
          height: 287,
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 25),
          decoration: const BoxDecoration(
            color: Color(0xFFFAF6EB),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                width: 222,
                height: 139,
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00AC47),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Verification Successful',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Press continue to proceed",
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF263238),
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onContinue,
                child: Container(
                  width: 265,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE5AA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF621B2B),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerificationFailedModal extends StatelessWidget {
  const VerificationFailedModal({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 812,
      color: const Color(0xFF000000).withOpacity(0.7),
      child: Center(
        child: Container(
          width: 329,
          height: 287,
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 25),
          decoration: const BoxDecoration(
            color: Color(0xFFFAF6EB),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                width: 222,
                height: 139,
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Verification Failed',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Please try again',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF263238),
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
// Add your logic to try again here
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 265,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE5AA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Try Again',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF621B2B),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
