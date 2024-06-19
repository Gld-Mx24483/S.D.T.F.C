// fash_my_acct.dart
// ignore_for_file: use_build_context_synchronously, avoid_print, unused_field, unused_import, unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'any_loading_modal.dart';
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
  bool _isUploadingImage = false;

  late CloudinaryPublic cloudinary;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();

    cloudinary = CloudinaryPublic('dabq39lbk', 'jb14zkiw', cache: false);
  }

  Future<void> _fetchUserProfile() async {
    final userProfile = await ApiService.getUserProfile();
    if (userProfile != null) {
      setState(() {
        _userProfile = userProfile;
        _firstNameController.text = userProfile['firstName'] ?? '';
        _lastNameController.text = userProfile['lastName'] ?? '';
        _emailController.text = userProfile['email'] ?? '';
        _phoneNumberController.text = userProfile['phoneNumber'] ?? '';
      });
    }
  }

  Future<String?> _uploadImageToCloudinary() async {
    if (_imageFile == null) {
      return null;
    }

    setState(() {
      _isUploadingImage = true;
    });

    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(_imageFile!.path, folder: 'profile_images'),
      );
      return response.secureUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final phoneNumber = _phoneNumberController.text;

    final profileImage = await _uploadImageToCloudinary();
    print('Uploaded image URL: $profileImage');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AnyLoadingModal(),
    );

    try {
      final response = await ApiService.updateUserProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        profileImage: profileImage,
      );

      if (response != null && response['statusCode'] == 200) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Changes Successful'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Update failed
        Navigator.of(context).pop(); // Dismiss the loading modal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Error occurred
      Navigator.of(context).pop(); // Dismiss the loading modal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred'),
          duration: Duration(seconds: 2),
        ),
      );
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
                child: Stack(
                  children: [
                    Container(
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
                          : _userProfile != null &&
                                  _userProfile!['profileImage'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(45),
                                  child: Image.network(
                                    _userProfile!['profileImage'],
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
                    if (_isUploadingImage)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                  ],
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
                      isEmail: true,
                    ),
                    const SizedBox(height: 16),
                    _buildPhoneTextField(),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: _updateUserProfile,
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
        onItemTapped: (label) {},
        tutorialStep: 0,
        selectedLabel: '',
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool isEmail = false, // Add this parameter
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
          enabled: !isEmail, // Disable the field if it's the email input
        ),
      ],
    );
  }

  Map<String, String> countryCodeToExamplePhoneNumber = {
    'NG': '080 1234 567', // Nigeria
    'US': '123 456 7890', // United States
    'GB': '1234 567 890', // United Kingdom
    'CA': '123 456 7890', // Canada
    'AU': '123 456 789', // Australia
    'NZ': '123 456 789', // New Zealand
    'IN': '1234 567 890', // India
    'ZA': '123 456 7890', // South Africa
    'KE': '123 456 789', // Kenya
    'GH': '123 456 789', // Ghana
    'EG': '123 456 7890', // Egypt
    'MA': '123 456 789', // Morocco
    'SG': '1234 5678', // Singapore
    'MY': '123 456 7890', // Malaysia
    'PH': '123 456 7890', // Philippines
    'TH': '123 456 789', // Thailand
    'VN': '123 456 789', // Vietnam
    'ID': '123 456 789', // Indonesia
    'PK': '123 456 789', // Pakistan
    'BD': '123 456 789', // Bangladesh
    'LK': '123 456 789', // Sri Lanka
    'NP': '123 456 789', // Nepal
    'TR': '123 456 7890', // Turkey
    'SA': '123 456 789', // Saudi Arabia
    'AE': '123 456 789', // United Arab Emirates
    'QA': '1234 5678', // Qatar
    'KW': '1234 5678', // Kuwait
    'OM': '123 456 789', // Oman
    'BH': '1234 5678', // Bahrain
    'JO': '123 456 789', // Jordan
    'LB': '123 456 789', // Lebanon
    'IQ': '123 456 789', // Iraq
    'YE': '123 456 789', // Yemen
    'PS': '123 456 789', // Palestine
    'IL': '123 456 789', // Israel
    'IR': '123 456 7890', // Iran
    'RU': '123 456 7890', // Russia
    'UA': '123 456 789', // Ukraine
    'KZ': '123 456 789', // Kazakhstan
    'UZ': '123 456 789', // Uzbekistan
    'TJ': '123 456 789', // Tajikistan
    'KG': '123 456 789', // Kyrgyzstan
    'TM': '123 456 789', // Turkmenistan
    'AZ': '123 456 789', // Azerbaijan
    'AM': '123 456 789', // Armenia
    'GE': '123 456 789', // Georgia
    'BY': '123 456 789', // Belarus
    'MD': '123 456 789', // Moldova
    'RO': '123 456 789', // Romania
    'BG': '123 456 789', // Bulgaria
    'GR': '123 456 789', // Greece
    'CY': '123 456 789', // Cyprus
    'AL': '123 456 789', // Albania
    'MK': '123 456 789', // North Macedonia
    'RS': '123 456 789', // Serbia
    'ME': '123 456 789', // Montenegro
    'BA': '123 456 789', // Bosnia and Herzegovina
    'HR': '123 456 789', // Croatia
    'SI': '123 456 789', // Slovenia
    'HU': '123 456 789', // Hungary
    'SK': '123 456 789', // Slovakia
    'CZ': '123 456 789', // Czech Republic
    'PL': '123 456 789', // Poland
    'LT': '123 456 789', // Lithuania
    'LV': '123 456 789', // Latvia
    'EE': '123 456 789', // Estonia
    'FI': '123 456 789', // Finland
    'SE': '123 456 789', // Sweden
    'NO': '123 456 789', // Norway
    'DK': '123 456 789', // Denmark
    'IS': '123 456 789', // Iceland
    'IE': '123 456 789', // Ireland
    'PT': '123 456 789', // Portugal
    'ES': '123 456 789', // Spain
    'FR': '123 456 789', // France
    'IT': '123 456 789', // Italy
    'CH': '123 456 789', // Switzerland
    'AT': '123 456 789', // Austria
    'DE': '123 456 7890', // Germany
    'NL': '123 456 789', // Netherlands
    'BE': '123 456 789', // Belgium
    'LU': '123 456 789', // Luxembourg
  };

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
          onInputChanged: (PhoneNumber number) {},
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
            hintText: countryCodeToExamplePhoneNumber['NG'] ??
                'Enter your phone number',
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
          onSaved: (PhoneNumber number) {
            // Handle phone number selection
            setState(() {
              _phoneNumberController.text = '';
              _phoneNumberController.value = TextEditingValue(
                text: _phoneNumberController.text,
                selection: TextSelection.collapsed(
                    offset: _phoneNumberController.text.length),
              );
            });
          },
        ),
      ],
    );
  }
}
