// log_in.dart
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'api_service.dart';
import 'designer_main_screen.dart';
import 'fgt.dart';
import 'loading_modal.dart'; // Import the loading modal component
import 'role.dart';
import 'vendor_main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _showError = false;
  String _errorMessage = '';
  bool _showLoadingModal = false; // Add this line

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email == 'vendor@gmail.com' && password == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const VendorMainScreen(initialPage: '')),
      );
    } else if (email == 'newvendor@gmail.com' && password == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const VendorMainScreen(isNewDesigner: true, initialPage: '')),
      );
    } else {
      setState(() {
        _showLoadingModal = true; // Show the loading modal
      });

      final loginResult = await ApiService.loginUser(email, password);
      if (loginResult != null) {
        print('Access Token: ${await ApiService.getAccessToken()}');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DesignerMainScreen(
              isNewDesigner: true,
              initialPage: '',
            ),
          ),
        );
      } else {
        setState(() {
          _showError = true;
          _errorMessage = 'The email or password is incorrect';
          _showLoadingModal = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                    'Welcome Back',
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
                    'Sign in to your account',
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
                        'Email Address',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          letterSpacing: -0.019,
                          color: const Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(45, 215, 215, 215),
                          filled: true,
                          hintText: 'Enter your email address',
                          hintStyle: const TextStyle(
                            color: Color(0xFFD9D9D9),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _showError
                                  ? Colors.red
                                  : const Color(0xFFD8D7D7),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _showError
                                  ? Colors.red
                                  : const Color(0xFFD8D7D7),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _showError
                                  ? Colors.red
                                  : const Color(0xFF621B2B),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Password',
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
                        controller: _passwordController,
                        obscureText: _isPasswordObscured,
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(45, 215, 215, 215),
                          filled: true,
                          hintText: 'Enter your password',
                          hintStyle: const TextStyle(
                            color: Color(0xFFD9D9D9),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _showError
                                  ? Colors.red
                                  : const Color(0xFFD8D7D7),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _showError
                                  ? Colors.red
                                  : const Color(0xFFD8D7D7),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _showError
                                  ? Colors.red
                                  : const Color(0xFF621B2B),
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPasswordObscured = !_isPasswordObscured;
                              });
                            },
                            child: Icon(
                              _isPasswordObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color(0xFFD9D9D9),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      if (_showError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  color: const Color(0xFF621B2B),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: GestureDetector(
                    onTap: _handleLogin,
                    child: Container(
                      width: 337,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBE5AA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Login',
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        letterSpacing: -0.019,
                        color: const Color(0xFF8F92A1),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RoleScreen()),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          letterSpacing: -0.019,
                          color: const Color(0xFF621B2B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
// Show the loading modal if _showLoadingModal is true
          if (_showLoadingModal)
            LoadingModal(
              showNextModal: () {
                // This function will be called when the loading modal is dismissed
                // You can perform any additional operations here if needed
              },
            ),
        ],
      ),
    );
  }
}
