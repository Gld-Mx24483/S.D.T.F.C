import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'bottom_navigation_bar.dart';

class FashLocScreen extends StatefulWidget {
  const FashLocScreen({super.key});

  @override
  State<FashLocScreen> createState() => _FashLocScreenState();
}

class _FashLocScreenState extends State<FashLocScreen> {
  final TextEditingController _storeNameController =
      TextEditingController(text: 'Hemstofit_stores');
  final TextEditingController _storeEmailController =
      TextEditingController(text: 'hemstofit_stores@gmail.com');
  final TextEditingController _storePhoneNumberController =
      TextEditingController(text: '8106775111');
  final TextEditingController _storeAddressController =
      TextEditingController(text: '2 William drive silverbird');

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeEmailController.dispose();
    _storePhoneNumberController.dispose();
    _storeAddressController.dispose();
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
                        'New Location',
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
                      label: 'Store Name',
                      controller: _storeNameController,
                      hintText: 'Enter store name',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Store Email',
                      controller: _storeEmailController,
                      hintText: 'Enter store email',
                    ),
                    const SizedBox(height: 16),
                    _buildPhoneTextField(
                      label: 'Store Phone Number',
                      controller: _storePhoneNumberController,
                      hintText: 'Enter store phone number',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Store Address',
                      controller: _storeAddressController,
                      hintText: 'Enter store address',
                    ),
                    const SizedBox(height: 62),
                    GestureDetector(
                      onTap: () {
                        // Add Location logic
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

  Widget _buildPhoneTextField({
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
          textFieldController: controller,
          formatInput: false,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          inputDecoration: InputDecoration(
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
}
