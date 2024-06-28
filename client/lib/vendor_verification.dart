// vendor_verification.dart
// ignore_for_file: avoid_print, unused_import, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import 'address_validator.dart';
import 'api_service.dart';
import 'driver_license_validator.dart';
import 'international_passport_validator.dart';
import 'nin_validator.dart';
import 'vendor_bottom_navigation_bar.dart';
import 'vendor_main_screen.dart';

class VendorVerificationScreen extends StatefulWidget {
  const VendorVerificationScreen({super.key});

  @override
  State<VendorVerificationScreen> createState() =>
      _VendorVerificationScreenState();
}

class _VendorVerificationScreenState extends State<VendorVerificationScreen> {
  final TextEditingController _officialEmailController =
      TextEditingController();
  bool _isLoading = true;
  String _selectedIdType = 'International Passport';
  String? _verificationId;
  String? _verificationType;
  PickedFile? _idFile;
  PickedFile? _addressFile;
  String _idFileError = '';
  String _addressFileError = '';
  bool _isValidatingIdFile = false;
  bool _isIdFileValid = false;
  bool _isValidatingAddressFile = false;
  bool _isAddressFileValid = false;

  bool get _isVerified => _isIdFileValid && _isAddressFileValid;

  Future<void> _pickIdFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? idFile = await picker.pickImage(source: ImageSource.gallery);

    if (idFile != null) {
      setState(() {
        _idFile = PickedFile(idFile.path);
        _idFileError = '';
        _isIdFileValid = false;
        _validateIdFile();
      });
    }
  }

  Future<void> _fetchStoreDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final storeDetails = await ApiService.fetchStoreDetails();
      if (storeDetails != null && storeDetails['email'] != null) {
        setState(() {
          _officialEmailController.text = storeDetails['email'];
        });
      }
    } catch (e) {
      print('Error fetching store details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load official email')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickAddressFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? addressFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (addressFile != null) {
      setState(() {
        _addressFile = PickedFile(addressFile.path);
        _addressFileError = '';
        _isAddressFileValid = false;
        _validateAddressFile();
      });
    }
  }

  Future<void> _validateIdFile() async {
    setState(() {
      _isValidatingIdFile = true;
      _idFileError = '';
    });

    bool isValid;

    if (_selectedIdType == 'National Identification Number') {
      isValid = await NinValidator.validateIdFile(_idFile!.path);
      if (isValid) {
        _verificationId = NinValidator.getVerificationId();
        _verificationType = 'NIN';
      } else {
        _idFileError = 'Not a valid NIN';
      }
    } else if (_selectedIdType == 'International Passport') {
      isValid =
          await InternationalPassportValidator.recognizeAndValidatePassport(
              _idFile!.path);
      if (isValid) {
        _verificationId = InternationalPassportValidator.getVerificationId();
        _verificationType = 'INTERNATIONAL_PASSPORT';
      } else {
        _idFileError = 'Not a valid International Passport';
      }
    } else if (_selectedIdType == "Driver's License") {
      isValid = await DriverLicenseValidator.recognizeAndValidateDriversLicense(
          _idFile!.path);
      if (isValid) {
        _verificationId = DriverLicenseValidator.getVerificationId();
        _verificationType = 'DRIVERS_LICENSE';
      } else {
        _idFileError = 'Not a valid Driver License';
      }
    } else {
      isValid = false;
      _idFileError = 'Please select a valid ID type';
    }

    setState(() {
      _isValidatingIdFile = false;
      _isIdFileValid = isValid;
    });
  }

  // Future<void> _sendVerificationDetails() async {
  //   if (_verificationId != null && _verificationType != null) {
  //     bool success = await ApiService.sendVerificationDetails(
  //         _verificationType!, _verificationId!);
  //     if (success) {
  //       // Navigate to vendor_dash.dart
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const VendorMainScreen(initialPage: 'Shop'),
  //         ),
  //       );
  //     } else {
  //       // Show error message
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content:
  //               Text('Failed to send verification details. Please try again.'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  // }

  Future<void> _sendVerificationDetails() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Send verification details to the database
    bool success = await ApiService.sendVerificationDetails(
        _verificationType!, _verificationId!);

    // Hide loading indicator
    Navigator.of(context).pop();

    if (success) {
      // Navigate to VendorMainScreen if verification was successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const VendorMainScreen(initialPage: 'Shop'),
        ),
      );
    } else {
      // Show error message if verification failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Failed to send verification details. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchStoreDetails();
  }

  Future<void> _validateAddressFile() async {
    setState(() {
      _isValidatingAddressFile = true;
      _addressFileError = '';
    });

    bool isValid =
        await AddressValidator.validateAddressFile(_addressFile!.path);

    setState(() {
      _isValidatingAddressFile = false;
      _isAddressFileValid = isValid;
      if (!isValid) {
        _addressFileError = 'Invalid address proof.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Color.fromARGB(255, 1, 1, 1),
                                ),
                              ),
                            ),
                            Text(
                              'Verification',
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
                          _buildTextField(
                            label: 'Official Email Address',
                            controller: _officialEmailController,
                            hintText: 'Official email address',
                            enabled: false,
                          ),
                          const SizedBox(height: 36),
                          _buildDropdownField(
                            label: 'Proof of Identification',
                            value: _selectedIdType,
                            items: const [
                              DropdownMenuItem(
                                value: 'International Passport',
                                child: Text(
                                  'International Passport',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'National Identification Number',
                                child: Text(
                                  'National Identification Number',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "Driver's License",
                                child: Text(
                                  "Driver's License",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedIdType = newValue!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildUploadButton(
                            onTap: _pickIdFile,
                            file: _idFile,
                            isValidating: _isValidatingIdFile,
                            isValid: _isIdFileValid,
                            errorText: _idFileError,
                          ),
                          const SizedBox(height: 36),
                          _buildUploadButton(
                            label: 'Upload Proof of Address',
                            onTap: _pickAddressFile,
                            file: _addressFile,
                            isValidating: _isValidatingAddressFile,
                            isValid: _isAddressFileValid,
                            errorText: _addressFileError,
                          ),
                          const SizedBox(height: 32),
                          const SizedBox(height: 50),
                          GestureDetector(
                            onTap:
                                _isVerified ? _sendVerificationDetails : null,
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _isVerified
                                    ? const Color(0xFFFBE5AA)
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Center(
                                  child: Text(
                                    'Save',
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: _isVerified
                                          ? const Color(0xFF621B2B)
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
//                     GestureDetector(
//   onTap: _isVerified
//       ? () async {
//           // Show loading indicator
//           showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return const Center(child: CircularProgressIndicator());
//             },
//           );

//           // Send verification details to the database
//           bool success = await ApiService.sendVerificationDetails(_verificationType!, _verificationId!);

//           // Hide loading indicator
//           Navigator.of(context).pop();

//           if (success) {
//             // Navigate to VendorMainScreen if verification was successful
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const VendorMainScreen(initialPage: 'Shop'),
//               ),
//             );
//           } else {
//             // Show error message if verification failed
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Failed to send verification details. Please try again.'),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         }
//       : null,
//   child: Container(
//     width: double.infinity,
//     height: 50,
//     decoration: BoxDecoration(
//       color: _isVerified ? const Color(0xFFFBE5AA) : Colors.grey,
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Padding(
//       padding: const EdgeInsets.only(top: 10.0),
//       child: Center(
//         child: Text(
//           'Save',
//           style: GoogleFonts.nunito(
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//             color: _isVerified ? const Color(0xFF621B2B) : Colors.white,
//           ),
//         ),
//       ),
//     ),
//   ),
// ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: VendorBottomNavigationBar(
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
    bool enabled = true,
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
          enabled: enabled,
          decoration: InputDecoration(
            fillColor: enabled
                ? const Color.fromARGB(45, 215, 215, 215)
                : Colors.grey[200],
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey[400]!,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(45, 215, 215, 215),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFD8D7D7)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF621B2B)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              dropdownColor: Colors.white,
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton({
    String? label,
    required VoidCallback onTap,
    required PickedFile? file,
    bool isValidating = false,
    bool isValid = false,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        if (label != null) const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isValidating
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF621B2B)),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isValid)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 24,
                        ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          file != null
                              ? 'File selected: ${file.path.split('/').last}'
                              : 'Upload',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF000000),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (errorText != null && errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
