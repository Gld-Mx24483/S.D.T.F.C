import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _showError = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendCodeAndNavigate(BuildContext context) {
    final String emailAddress = _emailController.text.trim();
    const String hardcodedEmail = 'selldometech@gmail.com'; // Hardcoded email

    if (emailAddress == hardcodedEmail) {
      // Email matches the hardcoded email
      _showError = false;
      Navigator.pushNamed(
        context,
        '/forgot-password-otp',
        arguments: emailAddress,
      );
    } else {
      // Email does not match the hardcoded email
      setState(() {
        _showError = true;
      });
    }
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
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Text(
                'Enter your email, we will send a verification code to email',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
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
                  const Text(
                    'Email Address',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      letterSpacing: -0.019,
                      color: Colors.black,
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
                          color:
                              _showError ? Colors.red : const Color(0xFFD8D7D7),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color:
                              _showError ? Colors.red : const Color(0xFFD8D7D7),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color:
                              _showError ? Colors.red : const Color(0xFF621B2B),
                        ),
                      ),
                    ),
                  ),
                  if (_showError)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Account does not exist',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: GestureDetector(
                onTap: () {
                  _sendCodeAndNavigate(context);
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
                      'Send Code',
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
}
