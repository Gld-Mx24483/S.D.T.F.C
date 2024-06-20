//log_in.dart
// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'api_service.dart';
import 'designer_main_screen.dart';
import 'fgt.dart';
import 'loading_modal.dart';
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
  final TextEditingController _shopNameController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _showError = false;
  String _errorMessage = '';
  bool _showLoadingModal = false;
  bool _isVendor = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _shopNameController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final shopName = _shopNameController.text;

    setState(() {
      _showLoadingModal = true;
    });

    if (_isVendor) {
      final loginResult =
          await ApiService.loginVendor(email, password, shopName);
      if (loginResult != null) {
        print('Vendor Access Token: ${await ApiService.getAccessToken()}');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const VendorMainScreen(
              isNewDesigner: true,
              initialPage: '',
            ),
          ),
        );
      } else {
        setState(() {
          _showError = true;
          _errorMessage = 'The email, password, or shop name is incorrect';
          _showLoadingModal = false;
        });
      }
    } else {
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFF621B2B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome Back',
                    style: GoogleFonts.nunito(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF621B2B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to your account',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildRoleSlider(),
                  const SizedBox(height: 24),
                  _buildInputField(
                    controller: _emailController,
                    label: 'Email Address',
                    hintText: 'Enter your email address',
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: _passwordController,
                    label: 'Password',
                    hintText: 'Enter your password',
                    isPassword: true,
                  ),
                  if (_isVendor) ...[
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _shopNameController,
                      label: 'Shop Name',
                      hintText: 'Enter your shop name',
                    ),
                  ],
                  if (_showError)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF621B2B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildLoginButton(),
                  const SizedBox(height: 24),
                  _buildSignUpRow(),
                ],
              ),
            ),
          ),
          if (_showLoadingModal)
            LoadingModal(
              showNextModal: () {
                // Handle loading modal dismissal
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRoleSlider() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: _isVendor ? Alignment.centerRight : Alignment.centerLeft,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5 - 24,
              height: 44,
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isVendor = false),
                  child: Center(
                    child: Text(
                      'Fashion Designer',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            !_isVendor ? const Color(0xFF621B2B) : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isVendor = true),
                  child: Center(
                    child: Text(
                      'Vendor',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            _isVendor ? const Color(0xFF621B2B) : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _isPasswordObscured : false,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.nunito(color: Colors.grey),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _isPasswordObscured
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(
                        () => _isPasswordObscured = !_isPasswordObscured),
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF621B2B), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFBE5AA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        'Login',
        style: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF621B2B),
        ),
      ),
    );
  }

  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RoleScreen()),
            );
          },
          child: Text(
            'Sign Up',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF621B2B),
            ),
          ),
        ),
      ],
    );
  }
}
