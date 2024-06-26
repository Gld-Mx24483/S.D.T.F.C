//vendor.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ven_ver.dart';

class VendorScreen extends StatefulWidget {
  const VendorScreen({super.key});

  @override
  VendorScreenState createState() => VendorScreenState();
}

class VendorScreenState extends State<VendorScreen> {
  bool _isChecked = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController shopController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    shopController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isObscure = true;
  bool emailErrorVisible = false;
  String emailErrorMessage = '';

  bool _isFormValid() {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        shopController.text.isEmpty ||
        passwordController.text.isEmpty) {
      return false;
    }

    if (!_isEmailValid(emailController.text)) {
      return false;
    }

    if (!emailController.text.contains('@')) {
      return false;
    }

    bool haslowerLetter = false;
    bool hasupperLetter = false;
    bool hasNumber = false;
    bool isLengthValid = passwordController.text.length >= 8;
    for (int i = 0; i < passwordController.text.length; i++) {
      if (_islowerLetter(passwordController.text[i])) {
        haslowerLetter = true;
      } else if (_isupperLetter(passwordController.text[i])) {
        hasupperLetter = true;
      } else if (_isDigit(passwordController.text[i])) {
        hasNumber = true;
      }
    }
    if (!haslowerLetter || !hasupperLetter || !hasNumber || !isLengthValid) {
      return false;
    }

    if (!_isChecked) {
      return false;
    }

    return true;
  }

  bool _islowerLetter(String char) {
    return char.codeUnitAt(0) >= 'a'.codeUnitAt(0) &&
        char.codeUnitAt(0) <= 'z'.codeUnitAt(0);
  }

  bool _isupperLetter(String char) {
    return char.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
        char.codeUnitAt(0) <= 'Z'.codeUnitAt(0);
  }

  bool _isDigit(String char) {
    return char.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
        char.codeUnitAt(0) <= '9'.codeUnitAt(0);
  }

  bool _isEmailValid(String email) {
    bool hasAtSign = email.contains('@');
    bool hasDomainExtension =
        RegExp(r'^.+\.[a-zA-Z]+$').hasMatch(email.split('@').last);

    if (!hasAtSign) {
      return false;
    } else if (!hasDomainExtension) {
      return false;
    }

    return true;
  }

  String _getEmailErrorText(String email) {
    if (!email.contains('@')) {
      return 'Email should contain @';
    } else if (!RegExp(r'^.+\.[a-zA-Z]+$').hasMatch(email.split('@').last)) {
      return 'Email should have a valid domain .extension';
    }
    return '';
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
                'Create Account',
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
                'Fill in the form',
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
                    'First Name',
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
                    controller: firstNameController,
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(45, 215, 215, 215),
                      filled: true,
                      hintText: 'Enter your first name',
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Last Name',
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
                    controller: lastNameController,
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(45, 215, 215, 215),
                      filled: true,
                      hintText: 'Enter your last name',
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Email Address',
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
                    controller: emailController,
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          emailErrorVisible = false;
                        } else {
                          emailErrorVisible = !_isEmailValid(value);
                          emailErrorMessage = _getEmailErrorText(value);
                        }
                      });
                    },
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(45, 215, 215, 215),
                      filled: true,
                      hintText: 'Enter your email address',
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
                      errorText: emailErrorVisible ? emailErrorMessage : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Shop Name',
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
                    controller: shopController,
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(45, 215, 215, 215),
                      filled: true,
                      hintText: 'Enter your shop name',
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
                    controller: passwordController,
                    obscureText: isObscure,
                    onChanged: (value) {
                      setState(() {
                        isObscure = true;
                      });
                    },
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(45, 215, 215, 215),
                      filled: true,
                      hintText: 'Enter your password',
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
                            isObscure = !isObscure;
                          });
                        },
                        child: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                          color: const Color(0xFFD9D9D9),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        passwordController.text.length >= 8
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: passwordController.text.length >= 8
                            ? Colors.green
                            : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'At least 8 characters',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        _hasNumber(passwordController.text)
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: _hasNumber(passwordController.text)
                            ? Colors.green
                            : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Contains a number',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        _haslowerLetter(passwordController.text)
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: _haslowerLetter(passwordController.text)
                            ? Colors.green
                            : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Contains at least a lowercase letter',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        _hasupperLetter(passwordController.text)
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: _hasupperLetter(passwordController.text)
                            ? Colors.green
                            : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Contains at least an Uppercase letter',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 10, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isChecked = !_isChecked;
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 200, 198, 198),
                            ),
                            borderRadius: BorderRadius.circular(4),
                            color: _isChecked ? const Color(0xFF621B3B) : null,
                          ),
                          child: _isChecked
                              ? const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Color(0xFFEBEBEB),
                                    size: 16,
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'By creating an account, you agree to our ',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: Color(0xFF8F92A1),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 34),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Terms and Conditions',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: Color(0xFF621B2B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 40, 0, 16),
              child: GestureDetector(
                onTap: () {
                  if (_isFormValid()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VenVerScreen(
                          emailAddress: emailController.text,
                          firstNameController: firstNameController,
                          lastNameController: lastNameController,
                          shopController: shopController,
                          password: passwordController.text,
                          otp: '',
                        ),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Incomplete Information'),
                        content: const Text(
                            'Please fill out all fields correctly and accept the Terms and Conditions.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Container(
                  width: 337,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 20),
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

  bool _hasNumber(String text) {
    return text.contains(RegExp(r'\d'));
  }

  bool _haslowerLetter(String text) {
    return text.contains(RegExp(r'[A-Z]'));
  }

  bool _hasupperLetter(String text) {
    return text.contains(RegExp(r'[A-Z]'));
  }
}
