// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import 'vendor_bottom_navigation_bar.dart';

class VendorVerificationScreen extends StatefulWidget {
  const VendorVerificationScreen({super.key});

  @override
  State<VendorVerificationScreen> createState() =>
      _VendorVerificationScreenState();
}

class _VendorVerificationScreenState extends State<VendorVerificationScreen> {
  final TextEditingController _officialEmailController =
      TextEditingController(text: 'hemstofit_stores_official@gmail.com');
  String _selectedIdType = 'International Passport';
  PickedFile? _idFile;
  PickedFile? _addressFile;
  String _idFileError = '';

  Future<void> _pickIdFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? idFile = await picker.pickImage(source: ImageSource.gallery);

    if (idFile != null) {
      setState(() {
        _idFile = PickedFile(idFile.path);
        _validateIdFile();
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
      });
    }
  }

  Future<void> _validateIdFile() async {
    final TextRecognizer textRecognizer =
        TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer
        .processImage(InputImage.fromFilePath(_idFile!.path));

    String recognizedTextStr = '';

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        recognizedTextStr += '${line.text}\n';
      }
    }

    print(recognizedTextStr);

    // Key phrases to check for
    const keyPhrases = [
      'NIN',
      "(0700-2255-646)",
      '0700-CALL-NIMC',
      "National ldentity Management Commission",
      'helpdesk@nimc.gov.ng',
      'Federal Republic of Nigeria',
      'www.nimc.gov.ng',
    ];

    // Regular expressions to capture dynamic values for NIN
    final RegExp ninRegExp = RegExp(r'\b\d{11}\b');
    final RegExp trackingIdRegExp = RegExp(r'Tracking ID:\s*([A-Z0-9]+)');
    final RegExp surnameRegExp = RegExp(r'Gender:\s*([A-Za-z ]+)');
    final RegExp firstNameRegExp = RegExp(r'First Name:\s*([A-Za-z ]+)');
    final RegExp middleNameRegExp =
        RegExp(r'Middle Name:\s*([A-Za-z ]+)\s*([MF])');
    final RegExp sexRegExp = RegExp(r'Gender:\s*([A-Za-z ]+)\s*([MF])');

    // Initialize error message
    String errorMessage = '';

    // Check for key phrases
    for (var phrase in keyPhrases) {
      if (!recognizedTextStr.contains(phrase)) {
        print('Not a valid NIN');
      }
    }

    // Check for dynamic values
    if (!ninRegExp.hasMatch(recognizedTextStr)) {
      errorMessage = 'Not a valid NIN';
    } else if (!trackingIdRegExp.hasMatch(recognizedTextStr)) {
      errorMessage = 'Not a valid NIN';
    } else if (!surnameRegExp.hasMatch(recognizedTextStr)) {
      errorMessage = 'Not a valid NIN';
    } else if (!firstNameRegExp.hasMatch(recognizedTextStr)) {
      errorMessage = 'Not a valid NIN';
    } else if (!middleNameRegExp.hasMatch(recognizedTextStr)) {
      errorMessage = 'Not a valid NIN';
    } else if (!sexRegExp.hasMatch(recognizedTextStr)) {
      errorMessage = 'Not a valid NIN';
    }

    // Log the error message
    if (errorMessage.isNotEmpty) {
      print(errorMessage);
    }

    // Update the error message state
    setState(() {
      _idFileError = errorMessage;
    });
  }

  @override
  void dispose() {
    _officialEmailController.dispose();
    super.dispose();
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
                      hintText: 'Enter your official email address',
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
                      errorText: _idFileError,
                    ),
                    const SizedBox(height: 36),
                    _buildUploadButton(
                      label: 'Upload Proof of Address',
                      onTap: _pickAddressFile,
                      file: _addressFile,
                    ),
                    const SizedBox(height: 32),
                    const SizedBox(height: 50),
                    GestureDetector(
                      onTap: () {
                        // Add new location logic
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBE5AA),
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
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
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
        if (label != null) const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(45, 215, 215, 215),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD8D7D7)),
            ),
            child: Center(
              child: file != null
                  ? Text(
                      'File selected: ${file.path.split('/').last}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    )
                  : Text(
                      'Upload',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF000000),
                      ),
                    ),
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
