// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'api_service.dart'; // Import the ApiService class
import 'bottom_navigation_bar.dart';

class FashPasScreen extends StatefulWidget {
  const FashPasScreen({super.key});

  @override
  State<FashPasScreen> createState() => _FashPasScreenState();
}

class _FashPasScreenState extends State<FashPasScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isObscureOld = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _hasNumber(String value) {
    return value.contains(RegExp(r'\d'));
  }

  bool _haslowerLetter(String value) {
    return value.contains(RegExp(r'[a-z]'));
  }

  bool _hasUpperLetter(String value) {
    return value.contains(RegExp(r'[A-Z]'));
  }

  bool _passwordsMatch() {
    return _newPasswordController.text.isNotEmpty &&
        _newPasswordController.text == _confirmPasswordController.text;
  }

  void _changePassword() async {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;

    if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
      final success = await ApiService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      if (success) {
        // Password changed successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully'),
          ),
        );
      } else {
        // Failed to change password
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to change password'),
          ),
        );
      }
    } else {
      // Show an error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter old and new passwords'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: const BoxDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(left: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color.fromARGB(255, 1, 1, 1),
                          ),
                        ),
                      ),
                      Text(
                        'Change Password',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF232323),
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 33),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildPasswordField(
                      label: 'Old Password',
                      controller: _oldPasswordController,
                      hintText: 'Enter your old password',
                      isObscure: _isObscureOld,
                      onObscureToggle: () {
                        setState(() {
                          _isObscureOld = !_isObscureOld;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      label: 'New Password',
                      controller: _newPasswordController,
                      hintText: 'Enter your new password',
                      isObscure: _isObscureNew,
                      onObscureToggle: () {
                        setState(() {
                          _isObscureNew = !_isObscureNew;
                        });
                      },
                      showConstraints: true,
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      label: 'Confirm Password',
                      controller: _confirmPasswordController,
                      hintText: 'Confirm your new password',
                      isObscure: _isObscureConfirm,
                      onObscureToggle: () {
                        setState(() {
                          _isObscureConfirm = !_isObscureConfirm;
                        });
                      },
                      showConstraints: true,
                      constraintText: 'Passwords match',
                      matchesNewPassword: _passwordsMatch(),
                    ),
                    const SizedBox(height: 48),
                    GestureDetector(
                      onTap: _changePassword, // Call the _changePassword method
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBE5AA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Save Changes',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF621B2B),
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
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onItemTapped: (label) {
          // Handle bottom navigation bar item taps
        },
        tutorialStep: 0,
        selectedLabel: '',
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool isObscure,
    required VoidCallback onObscureToggle,
    bool showConstraints = false,
    String? constraintText,
    bool matchesNewPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
          controller: controller,
          obscureText: isObscure,
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            fillColor: const Color.fromARGB(45, 215, 215, 215),
            filled: true,
            hintText: hintText,
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
              onTap: onObscureToggle,
              child: Icon(
                isObscure ? Icons.visibility : Icons.visibility_off,
                color: const Color(0xFFD9D9D9),
                size: 20,
              ),
            ),
          ),
        ),
        if (showConstraints)
          Column(
            children: [
              const SizedBox(height: 16),
              if (label == 'New Password') ...[
                Row(
                  children: [
                    Icon(
                      controller.text.length >= 8
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: controller.text.length >= 8
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
                      _hasNumber(controller.text)
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: _hasNumber(controller.text)
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
                      _haslowerLetter(controller.text)
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: _haslowerLetter(controller.text)
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
                      _hasUpperLetter(controller.text)
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: _hasUpperLetter(controller.text)
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
              ],
              if (constraintText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Row(
                    children: [
                      Icon(
                        matchesNewPassword
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: matchesNewPassword ? Colors.green : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        constraintText,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
