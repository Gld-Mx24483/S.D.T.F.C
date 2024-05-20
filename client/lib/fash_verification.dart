// fash_verification.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'bottom_navigation_bar.dart';

class FashVerificationScreen extends StatefulWidget {
  const FashVerificationScreen({super.key});

  @override
  State<FashVerificationScreen> createState() => _FashVerificationScreenState();
}

class _FashVerificationScreenState extends State<FashVerificationScreen> {
  final TextEditingController _officialEmailController =
      TextEditingController(text: 'hemstofit_stores_official@gmail.com');
  String _selectedIdType = 'International Passport';
  PickedFile? _idFile;
  PickedFile? _addressFile;

  Future<void> _pickIdFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? idFile = await picker.pickImage(source: ImageSource.gallery);

    if (idFile != null) {
      setState(() {
        _idFile = PickedFile(idFile.path);
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
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: 'Proof of Identification',
                      value: _selectedIdType,
                      items: [
                        'International Passport',
                        'National Identification Number'
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedIdType = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildUploadButton(
                      label: 'Upload Proof of Identification',
                      onTap: _pickIdFile,
                      file: _idFile,
                    ),
                    const SizedBox(height: 16),
                    _buildUploadButton(
                      label: 'Upload Proof of Address',
                      onTap: _pickAddressFile,
                      file: _addressFile,
                    ),
                    const SizedBox(height: 32),
                    const SizedBox(height: 20),
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
                        child: Center(
                          child: Text(
                            'Add Location',
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
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
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: items.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF621B2B)),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton({
    required String label,
    required VoidCallback onTap,
    required PickedFile? file,
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
      ],
    );
  }
}
