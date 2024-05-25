//rst_pw.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'log_in.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _passwordsDoNotMatch = false;
  bool _isLoading = false;
  bool _isSuccessful = false;
  bool _isConfirmButtonPressed = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirmPassword() async {
    setState(() {
      _passwordsDoNotMatch =
          _newPasswordController.text != _confirmPasswordController.text;
    });

    if (!_passwordsDoNotMatch) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 5));

      setState(() {
        _isLoading = false;
        _isSuccessful = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                          'Reset Password',
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
                        child: Text(
                          'Create a new password that is safe and easy to remember',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            letterSpacing: -0.019,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Password',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                letterSpacing: -0.019,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _newPasswordController,
                              obscureText: _isNewPasswordObscured,
                              decoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(45, 215, 215, 215),
                                filled: true,
                                hintText: 'Enter password',
                                hintStyle: const TextStyle(
                                  color: Color(0xFFD9D9D9),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD8D7D7),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD8D7D7),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF621B2B),
                                  ),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isNewPasswordObscured =
                                          !_isNewPasswordObscured;
                                    });
                                  },
                                  child: Icon(
                                    _isNewPasswordObscured
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: const Color(0xFFD9D9D9),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Confirm Password',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                letterSpacing: -0.019,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _confirmPasswordController,
                              obscureText: _isConfirmPasswordObscured,
                              decoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(45, 215, 215, 215),
                                filled: true,
                                hintText: 'Confirm password',
                                hintStyle: const TextStyle(
                                  color: Color(0xFFD9D9D9),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD8D7D7),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: _passwordsDoNotMatch
                                        ? Colors.red
                                        : const Color(0xFFD8D7D7),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: _passwordsDoNotMatch
                                        ? Colors.red
                                        : const Color(0xFF621B2B),
                                  ),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isConfirmPasswordObscured =
                                          !_isConfirmPasswordObscured;
                                    });
                                  },
                                  child: Icon(
                                    _isConfirmPasswordObscured
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: const Color(0xFFD9D9D9),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            if (_passwordsDoNotMatch)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Passwords do not match',
                                  style: GoogleFonts.nunito(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTapDown: (details) {
                        setState(() {
                          _isConfirmButtonPressed =
                              true; // Add a state variable to track button press
                        });
                      },
                      onTapUp: (details) {
                        setState(() {
                          _isConfirmButtonPressed = false;
                        });
                      },
                      onTapCancel: () {
                        setState(() {
                          _isConfirmButtonPressed = false;
                        });
                      },
                      onTap: _handleConfirmPassword,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          width: 337,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _isConfirmButtonPressed
                                ? const Color(0xFFE5C389)
                                : const Color(0xFFFBE5AA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Confirm New Password',
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                                color: _isConfirmButtonPressed
                                    ? const Color(0xFF8E4B2D)
                                    : const Color(0xFF621B2B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    width: 260,
                    height: 72,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF6EB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFFBE5AA)),
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
              ),
            ),
          if (_isSuccessful)
            Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    width: 300,
                    height: 350,
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      color: const Color(0xFFFAF6EB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 80,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Password Changed',
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Password changed successfully, you can login again with your new password.',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF263238),
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFBE5AA),
                            foregroundColor: const Color(0xFF621B2B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 16),
                          ),
                          child: Text(
                            'Login',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
