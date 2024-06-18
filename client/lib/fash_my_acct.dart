// ignore_for_file: unused_field

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'api_service.dart';
import 'bottom_navigation_bar.dart';

class FashMyAcctScreen extends StatefulWidget {
  const FashMyAcctScreen({super.key});

  @override
  State<FashMyAcctScreen> createState() => _FashMyAcctScreenState();
}

class _FashMyAcctScreenState extends State<FashMyAcctScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  PickedFile? _imageFile;
  Map<String, dynamic>? _userProfile;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final userProfile = await ApiService.getUserProfile();
    if (userProfile != null) {
      setState(() {
        _userProfile = userProfile;
        _firstNameController.text = userProfile['firstName'] ?? '';
        _lastNameController.text = userProfile['lastName'] ?? '';
        _emailController.text = userProfile['email'] ?? '';
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = PickedFile(image.path);
      });
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
                        'My Account',
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
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFDADADA),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: Image.file(
                            File(_imageFile!.path),
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildTextField(
                      label: 'First Name',
                      controller: _firstNameController,
                      hintText: '--',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Last Name',
                      controller: _lastNameController,
                      hintText: '--',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Email Address',
                      controller: _emailController,
                      hintText: '--',
                    ),
                    const SizedBox(height: 16),
                    _buildPhoneTextField(),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {},
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
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
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
            letterSpacing: -0.019,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber number) {
// Handle phone number input changes
          },
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.disabled,
          selectorTextStyle: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
            letterSpacing: -0.019,
            color: Colors.black,
          ),
          initialValue: PhoneNumber(isoCode: 'NG'),
          textFieldController: _phoneNumberController,
          formatInput: false,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          inputDecoration: InputDecoration(
            fillColor: const Color.fromARGB(45, 215, 215, 215),
            filled: true,
            hintText: 'Enter your phone number',
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
      ],
    );
  }
}
