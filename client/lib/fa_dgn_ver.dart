// fa_dgn_ver.dart

// ignore_for_file: avoid_print, unused_element, use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'api_service.dart';
import 'log_in.dart';

class FashVerScreen extends StatefulWidget {
  final String emailAddress;
  final String password;
  final String otp;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const FashVerScreen({
    super.key,
    required this.emailAddress,
    required this.otp,
    required this.firstNameController,
    required this.lastNameController,
    required this.password,
  });

  @override
  State<FashVerScreen> createState() => _FashVerScreenState();
}

class _FashVerScreenState extends State<FashVerScreen> {
  late final String _emailAddress;
  late final String _otp;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final String _password;
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
    _otp = widget.otp;
    _firstNameController = widget.firstNameController;
    _lastNameController = widget.lastNameController;
    _password = widget.password;
    String generatedOTP = _generateOTP();
    _sendEmailWithOTP(generatedOTP);
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

  String _generateAndSendOTP() {
    String generatedOTP = _generateOTP();
    _sendEmailWithOTP(generatedOTP);
    return generatedOTP;
  }

  String _generateOTP() {
    _generatedOTP = (Random().nextInt(900000) + 100000).toString();
    return _generatedOTP;
  }

  void _sendEmailWithOTP(String otp) async {
    print('Generated OTP: $otp');
    Map<String, dynamic> templateParams = {
      'email': _emailAddress,
      'otp': otp,
      'message': 'Hi ${_firstNameController.text} ${_lastNameController.text},',
    };

    try {
      await EmailJS.send(
        'service_rgvnw3a',
        'template_8nihdqb',
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
        otp: _otp,
        firstNameController: _firstNameController,
        lastNameController: _lastNameController,
        email: _emailAddress,
        password: _password,
        handleSignUp: _handleSignUp,
      ),
    );
  }

  void _showVerificationFailedModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const VerificationFailedModal(
        otp: '',
      ),
    );
  }

  void _handleSignUp() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoadingModal(
        showNextModal: null,
      ),
    );

    final bool signUpSuccess = await ApiService.signUpUser(
      _firstNameController.text,
      _lastNameController.text,
      _emailAddress,
      _password,
    );

    Navigator.of(context).pop(); // Dismiss the loading modal

    if (signUpSuccess) {
      // Handle successful signup
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => VerificationSuccessModal(
          otp: _otp,
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          email: _emailAddress,
          password: _password,
          handleSignUp: _navigateToLogin,
        ),
      );
    } else {
      // Handle signup failure
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const VerificationFailedModal(
          otp: '',
        ),
      );
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                'Verify Email',
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
                  Text(
                    'Generated OTP:  $_generatedOTP',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(0, 158, 158, 158),
                    ),
                  ),
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
            const SizedBox(height: 40),
            Center(
              child: GestureDetector(
                onTap: () {
                  _validateOTPAndProceed();
                },
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
          }
        },
      ),
    );
  }

  void _handleResendCode() {
    _generatedOTP = _generateAndSendOTP();
    _startCountdown();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingModal(
        showNextModal: () {},
      ),
    );
  }
}

class LoadingModal extends StatefulWidget {
  const LoadingModal({super.key, required this.showNextModal});
  final Function? showNextModal;
  @override
  LoadingModalState createState() => LoadingModalState();
}

class LoadingModalState extends State<LoadingModal> {
  @override
  void initState() {
    super.initState();
    if (widget.showNextModal != null) {
      _startTimer();
    }
  }

  void _startTimer() {
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pop();
      widget.showNextModal!();
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
  final String otp;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final String email;
  final String password;
  final VoidCallback handleSignUp;

  const VerificationSuccessModal({
    super.key,
    required this.otp,
    required this.firstNameController,
    required this.lastNameController,
    required this.email,
    required this.password,
    required this.handleSignUp,
  });

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
                      'Continue to login',
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
                onTap: handleSignUp,
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
  final String otp;

  const VerificationFailedModal({super.key, required this.otp});

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
                    Text(
                      'Verification Failed',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Please try again',
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
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 265,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE5AA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Try Again',
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





// // fa_dgn_ver.dart

// // ignore_for_file: avoid_print

// import 'dart:async';
// import 'dart:math';

// import 'package:emailjs/emailjs.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'log_in.dart';

// class FashVerScreen extends StatefulWidget {
//   final String emailAddress;
//   final String otp;
//   final TextEditingController firstNameController;
//   final TextEditingController lastNameController;

//   const FashVerScreen({
//     super.key,
//     required this.emailAddress,
//     required this.otp,
//     required this.firstNameController,
//     required this.lastNameController,
//   });

//   @override
//   State<FashVerScreen> createState() => _FashVerScreenState();
// }

// class _FashVerScreenState extends State<FashVerScreen> {
//   late final String _emailAddress;
//   late final String _otp;
//   late final TextEditingController _firstNameController;
//   late final TextEditingController _lastNameController;
//   final List<TextEditingController> _otpControllers =
//       List.generate(6, (_) => TextEditingController());
//   late Timer _timer;
//   int _countdown = 59;
//   bool _isCountdownFinished = false;
//   String _generatedOTP = '';

//   @override
//   void initState() {
//     super.initState();
//     _emailAddress = widget.emailAddress;
//     _otp = widget.otp;
//     _firstNameController = widget.firstNameController;
//     _lastNameController = widget.lastNameController;
//     String generatedOTP = _generateOTP();
//     _sendEmailWithOTP(generatedOTP);
//     _startCountdown();
//   }

//   @override
//   void dispose() {
//     for (var controller in _otpControllers) {
//       controller.dispose();
//     }
//     _timer.cancel();
//     super.dispose();
//   }

//   void _startCountdown() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_countdown > 0) {
//           _countdown--;
//         } else {
//           _isCountdownFinished = true;
//           _timer.cancel();
//         }
//       });
//     });
//   }

//   String _generateAndSendOTP() {
//     String generatedOTP = _generateOTP();
//     _sendEmailWithOTP(generatedOTP);
//     return generatedOTP;
//   }

//   String _generateOTP() {
//     _generatedOTP = (Random().nextInt(900000) + 100000).toString();
//     return _generatedOTP;
//   }

//   void _sendEmailWithOTP(String otp) async {
//     print('Generated OTP: $otp');
//     Map<String, dynamic> templateParams = {
//       'email': _emailAddress,
//       'otp': otp,
//       'message': 'Hi ${_firstNameController.text} ${_lastNameController.text},',
//     };

//     try {
//       await EmailJS.send(
//         'service_rgvnw3a',
//         'template_8nihdqb',
//         templateParams,
//         const Options(
//           publicKey: 'Y3vM6rPSqkT_78sNU',
//           privateKey: 'FqqqBbPwWL0NYv09OdSuE',
//         ),
//       );
//       print('Email sent successfully');
//     } catch (e) {
//       print('Error sending email: $e');
//     }
//   }

//   void _validateOTPAndProceed() {
//     String enteredOTP = '';
//     for (var controller in _otpControllers) {
//       enteredOTP += controller.text;
//     }

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => LoadingModal(
//         showNextModal: enteredOTP == _generatedOTP
//             ? _showVerificationSuccessModal
//             : _showVerificationFailedModal,
//       ),
//     );
//   }

//   void _showVerificationSuccessModal() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => VerificationSuccessModal(otp: _otp),
//     ).then((value) {
//       if (value != null && value) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginScreen()),
//         );
//       }
//     });
//   }

//   void _showVerificationFailedModal() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const VerificationFailedModal(
//         otp: '',
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFFFFF),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(15, 60, 0, 0),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(4),
//                   child: const Icon(
//                     Icons.arrow_back,
//                     color: Colors.black,
//                     size: 24,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
//               child: Text(
//                 'Verify Email',
//                 style: GoogleFonts.nunito(
//                   fontSize: 26,
//                   fontWeight: FontWeight.w800,
//                   height: 1.5,
//                   letterSpacing: -0.019,
//                   color: const Color(0xFF621B2B),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
//               child: RichText(
//                 text: TextSpan(
//                   style: GoogleFonts.nunito(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     height: 1.5,
//                     letterSpacing: -0.019,
//                     color: Colors.black,
//                   ),
//                   children: [
//                     const TextSpan(
//                         text:
//                             'Please provide the OTP sent to your email address '),
//                     TextSpan(
//                       text: _emailAddress,
//                       style: const TextStyle(
//                         color: Color(0xFF621B3B),
//                       ),
//                     ),
//                     const TextSpan(text: ' to continue'),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),
//             Center(
//               child: Column(
//                 children: [
//                   Container(
//                     width: 338,
//                     height: 48,
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         for (int i = 0; i < 6; i++) _buildOTPBox(i),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Generated OTP:  $_generatedOTP',
//                     style: GoogleFonts.nunito(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: const Color.fromARGB(0, 158, 158, 158),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 40),
//             Center(
//               child: _isCountdownFinished
//                   ? GestureDetector(
//                       onTap: _handleResendCode,
//                       child: RichText(
//                         text: TextSpan(
//                           style: GoogleFonts.nunito(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                             height: 1.2,
//                             letterSpacing: -0.019,
//                             color: Colors.black,
//                           ),
//                           children: const [
//                             TextSpan(text: "Didn't get the code? "),
//                             TextSpan(
//                               text: 'Resend code',
//                               style: TextStyle(
//                                 color: Color(0xFF621B2B),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : RichText(
//                       text: TextSpan(
//                         style: GoogleFonts.nunito(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500,
//                           height: 1.2,
//                           letterSpacing: -0.019,
//                           color: Colors.black,
//                         ),
//                         children: [
//                           const TextSpan(text: 'Resend OTP in '),
//                           TextSpan(
//                             text: _countdown.toString(),
//                             style: const TextStyle(
//                               color: Color(0xFF621B2B),
//                             ),
//                           ),
//                           const TextSpan(
//                             text: 's',
//                             style: TextStyle(
//                               color: Color(0xFF621B2B),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//             ),
//             const SizedBox(height: 40),
//             Center(
//               child: GestureDetector(
//                 onTap: _validateOTPAndProceed,
//                 child: Container(
//                   width: 337,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFBE5AA),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Continue',
//                       style: GoogleFonts.nunito(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         height: 1.5,
//                         color: const Color(0xFF621B2B),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOTPBox(int index) {
//     return SizedBox(
//       width: 46.23,
//       height: 48,
//       child: TextField(
//         controller: _otpControllers[index],
//         maxLength: 1,
//         textAlign: TextAlign.center,
//         obscureText: true,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 20,
//         ),
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(
//           counterText: '',
//           filled: true,
//           fillColor: Colors.transparent,
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(4),
//             borderSide: const BorderSide(
//               color: Color(0xFFD8D7D7),
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(4),
//             borderSide: const BorderSide(
//               color: Color(0xFF621B2B),
//             ),
//           ),
//         ),
//         onChanged: (value) {
//           if (value.isNotEmpty && index < _otpControllers.length - 1) {
//             FocusScope.of(context).nextFocus();
//           }
//         },
//       ),
//     );
//   }

//   void _handleResendCode() {
//     _generatedOTP = _generateAndSendOTP();
//     _startCountdown();
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => LoadingModal(
//         showNextModal: () {},
//       ),
//     );
//   }
// }

// class LoadingModal extends StatefulWidget {
//   const LoadingModal({super.key, required this.showNextModal});

//   final Function showNextModal;

//   @override
//   LoadingModalState createState() => LoadingModalState();
// }

// class LoadingModalState extends State<LoadingModal> {
//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     Timer(const Duration(seconds: 5), () {
//       Navigator.of(context).pop();
//       widget.showNextModal();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 375,
//       height: 812,
//       color: const Color(0xFF000000).withOpacity(0.7),
//       child: Center(
//         child: Container(
//           width: 260,
//           height: 72,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: const BoxDecoration(
//             color: Color(0xFFFAF6EB),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(4),
//               bottomRight: Radius.circular(4),
//               bottomLeft: Radius.circular(4),
//               topRight: Radius.circular(4),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFBE5AA)),
//               ),
//               const SizedBox(width: 20),
//               Text(
//                 'Please wait...',
//                 style: GoogleFonts.nunito(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: const Color(0xFF212121),
//                   decoration: TextDecoration.none,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class VerificationSuccessModal extends StatelessWidget {
//   final String otp;
//   const VerificationSuccessModal({super.key, required this.otp});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 375,
//       height: 812,
//       color: const Color(0xFF000000).withOpacity(0.7),
//       child: Center(
//         child: Container(
//           width: 329,
//           height: 287,
//           padding: const EdgeInsets.fromLTRB(32, 32, 32, 25),
//           decoration: const BoxDecoration(
//             color: Color(0xFFFAF6EB),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(24),
//               topRight: Radius.circular(24),
//               bottomLeft: Radius.circular(24),
//               bottomRight: Radius.circular(24),
//             ),
//           ),
//           child: Column(
//             children: [
//               SizedBox(
//                 width: 222,
//                 height: 139,
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 70,
//                       height: 70,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFF00AC47),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.check,
//                         color: Colors.white,
//                         size: 48,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Text(
//                       'Verification Successful',
//                       style: GoogleFonts.nunito(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       "Continue to login",
//                       style: GoogleFonts.nunito(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         color: const Color(0xFF263238),
//                         decoration: TextDecoration.none,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pop(true);
//                 },
//                 child: Container(
//                   width: 265,
//                   height: 44,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFBE5AA),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Continue',
//                       style: GoogleFonts.nunito(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         color: const Color(0xFF621B2B),
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class VerificationFailedModal extends StatelessWidget {
//   final String otp;
//   const VerificationFailedModal({super.key, required this.otp});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 375,
//       height: 812,
//       color: const Color(0xFF000000).withOpacity(0.7),
//       child: Center(
//         child: Container(
//           width: 329,
//           height: 287,
//           padding: const EdgeInsets.fromLTRB(32, 32, 32, 25),
//           decoration: const BoxDecoration(
//             color: Color(0xFFFAF6EB),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(24),
//               topRight: Radius.circular(24),
//               bottomLeft: Radius.circular(24),
//               bottomRight: Radius.circular(24),
//             ),
//           ),
//           child: Column(
//             children: [
//               SizedBox(
//                 width: 222,
//                 height: 139,
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 70,
//                       height: 70,
//                       decoration: const BoxDecoration(
//                         color: Colors.red,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.cancel,
//                         color: Colors.white,
//                         size: 48,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Text(
//                       'Verification Failed',
//                       style: GoogleFonts.nunito(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Please try again',
//                       style: GoogleFonts.nunito(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         color: const Color(0xFF263238),
//                         decoration: TextDecoration.none,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Container(
//                   width: 265,
//                   height: 44,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFBE5AA),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Try Again',
//                       style: GoogleFonts.nunito(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         color: const Color(0xFF621B2B),
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }