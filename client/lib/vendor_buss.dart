// //vendor_buss.dart
// // ignore_for_file: use_build_context_synchronously, avoid_print

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';

// import 'any_loading_modal.dart';
// import 'api_service.dart';
// import 'vendor_bottom_navigation_bar.dart';

// class VendorBussScreen extends StatefulWidget {
//   const VendorBussScreen({super.key});

//   @override
//   State<VendorBussScreen> createState() => _VendorBussScreenState();
// }

// class _VendorBussScreenState extends State<VendorBussScreen> {
//   final TextEditingController _businessNameController = TextEditingController();
//   final TextEditingController _businessAddressController =
//       TextEditingController();
//   final TextEditingController _businessEmailController =
//       TextEditingController();
//   final TextEditingController _businessDescriptionController =
//       TextEditingController();
//   final TextEditingController _businessPhoneNumberController =
//       TextEditingController();

//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchBusinessDetails();
//   }

//   Future<void> _fetchBusinessDetails() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final storeDetails = await ApiService.fetchStoreDetails();
//       if (storeDetails != null) {
//         setState(() {
//           _businessNameController.text = storeDetails['name'] ?? '';
//           _businessAddressController.text = storeDetails['address'] ?? '';
//           _businessEmailController.text = storeDetails['email'] ?? '';
//           _businessDescriptionController.text =
//               storeDetails['description'] ?? '';
//           _businessPhoneNumberController.text = storeDetails['phone'] ?? '';
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to fetch business details')),
//         );
//       }
//     } catch (e) {
//       print('Error fetching business details: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('An error occurred while fetching details')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _businessNameController.dispose();
//     _businessAddressController.dispose();
//     _businessEmailController.dispose();
//     _businessDescriptionController.dispose();
//     _businessPhoneNumberController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveChanges() async {
//     setState(() {
//       _isLoading = true;
//     });

//     final Map<String, dynamic> updateData = {
//       "name": _businessNameController.text,
//       "description": _businessDescriptionController.text,
//       "address": _businessAddressController.text,
//       "phone": _businessPhoneNumberController.text,
//       "email": _businessEmailController.text,
//     };

//     try {
//       final result = await ApiService.updateStore(updateData);
//       if (result != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('Business details updated successfully')),
//         );
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to update business details')),
//         );
//       }
//     } catch (e) {
//       print('Error updating business details: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('An error occurred while updating')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(
//           body: _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(
//                   child: Container(
//                     width: double.infinity,
//                     color: Colors.white,
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 35),
//                           child: Container(
//                             width: double.infinity,
//                             height: 56,
//                             decoration: const BoxDecoration(),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     Navigator.pop(context);
//                                   },
//                                   child: Container(
//                                     width: 24,
//                                     height: 24,
//                                     margin: const EdgeInsets.only(left: 20),
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 4.0),
//                                     child: const Icon(
//                                       Icons.arrow_back,
//                                       color: Color.fromARGB(255, 1, 1, 1),
//                                     ),
//                                   ),
//                                 ),
//                                 Text(
//                                   'Business Details',
//                                   style: GoogleFonts.nunito(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w700,
//                                     color: const Color(0xFF232323),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 44),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 33),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Column(
//                             children: [
//                               _buildTextField(
//                                 label: 'Business Name',
//                                 controller: _businessNameController,
//                                 hintText: 'Enter your business name',
//                               ),
//                               const SizedBox(height: 16),
//                               _buildTextField(
//                                 label: 'Business Address',
//                                 controller: _businessAddressController,
//                                 hintText: 'Enter your business address',
//                               ),
//                               const SizedBox(height: 16),
//                               _buildTextField(
//                                 label: 'Business Email',
//                                 controller: _businessEmailController,
//                                 hintText: 'Enter your business email',
//                               ),
//                               const SizedBox(height: 16),
//                               _buildTextField(
//                                 label: 'Business Description',
//                                 controller: _businessDescriptionController,
//                                 hintText: 'Enter your business description',
//                               ),
//                               const SizedBox(height: 16),
//                               _buildPhoneTextField(),
//                               const SizedBox(height: 32),
//                               GestureDetector(
//                                 onTap: _saveChanges,
//                                 child: Container(
//                                   width: double.infinity,
//                                   height: 50,
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFFFBE5AA),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       'Save Changes',
//                                       style: GoogleFonts.nunito(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w700,
//                                         color: const Color(0xFF621B2B),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//           bottomNavigationBar: VendorBottomNavigationBar(
//             onItemTapped: (label) {
//               // Handle bottom navigation bar item taps
//             },
//             tutorialStep: 0,
//             selectedLabel: '',
//           ),
//         ),
//         if (_isLoading) const AnyLoadingModal(),
//       ],
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     required TextEditingController controller,
//     required String hintText,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.nunito(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             height: 1.5,
//             letterSpacing: -0.019,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 10),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             fillColor: const Color.fromARGB(45, 215, 215, 215),
//             filled: true,
//             hintText: hintText,
//             hintStyle: const TextStyle(
//               color: Color(0xFFD9D9D9),
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(
//                 color: Color(0xFFD8D7D7),
//               ),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(
//                 color: Color(0xFFD8D7D7),
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(
//                 color: Color(0xFF621B2B),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPhoneTextField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Business Phone Number',
//           style: GoogleFonts.nunito(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             height: 1.5,
//             letterSpacing: -0.019,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 10),
//         InternationalPhoneNumberInput(
//           onInputChanged: (PhoneNumber number) {
//             // Handle phone number input changes
//           },
//           selectorConfig: const SelectorConfig(
//             selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//           ),
//           ignoreBlank: false,
//           autoValidateMode: AutovalidateMode.disabled,
//           selectorTextStyle: GoogleFonts.nunito(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             height: 1.5,
//             letterSpacing: -0.019,
//             color: Colors.black,
//           ),
//           initialValue: PhoneNumber(isoCode: 'NG'),
//           textFieldController: _businessPhoneNumberController,
//           formatInput: false,
//           keyboardType: const TextInputType.numberWithOptions(
//               signed: true, decimal: true),
//           inputDecoration: InputDecoration(
//             fillColor: const Color.fromARGB(45, 215, 215, 215),
//             filled: true,
//             hintText: 'Enter your business phone number',
//             hintStyle: const TextStyle(
//               color: Color(0xFFD9D9D9),
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(
//                 color: Color(0xFFD8D7D7),
//               ),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(
//                 color: Color(0xFFD8D7D7),
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(
//                 color: Color(0xFF621B2B),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

//vendor_buss.dart
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'any_loading_modal.dart';
import 'api_service.dart';
import 'vendor_bottom_navigation_bar.dart';

class VendorBussScreen extends StatefulWidget {
  const VendorBussScreen({super.key});

  @override
  State<VendorBussScreen> createState() => _VendorBussScreenState();
}

class _VendorBussScreenState extends State<VendorBussScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessAddressController =
      TextEditingController();
  final TextEditingController _businessEmailController =
      TextEditingController();
  final TextEditingController _businessDescriptionController =
      TextEditingController();
  final TextEditingController _businessPhoneNumberController =
      TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBusinessDetails();
  }

  Future<void> _fetchBusinessDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final storeDetails = await ApiService.fetchStoreDetails();
      if (storeDetails != null) {
        setState(() {
          _businessNameController.text = storeDetails['name'] ?? '';
          _businessDescriptionController.text =
              storeDetails['description'] ?? '';
          _businessEmailController.text = storeDetails['email'] ?? '';
          _businessPhoneNumberController.text = storeDetails['phone'] ?? '';

          if (storeDetails['addresses'] != null &&
              storeDetails['addresses'].isNotEmpty) {
            final address = storeDetails['addresses'][0];
            _businessAddressController.text =
                '${address['street']}, ${address['city']}, ${address['state']}, ${address['country']}';
          }
        });
      }
    } catch (e) {
      print('Error fetching business details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load business details')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _businessEmailController.dispose();
    _businessDescriptionController.dispose();
    _businessPhoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, dynamic> updateData = {
      "name": _businessNameController.text,
      "description": _businessDescriptionController.text,
      "address": _businessAddressController.text,
      "phone": _businessPhoneNumberController.text,
      "email": _businessEmailController.text,
    };

    try {
      final result = await ApiService.updateStore(updateData);
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Business details updated successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update business details')),
        );
      }
    } catch (e) {
      print('Error updating business details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while updating')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Color.fromARGB(255, 1, 1, 1),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Business Details',
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
                                label: 'Business Name',
                                controller: _businessNameController,
                                hintText: 'Enter your business name',
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                label: 'Business Address',
                                controller: _businessAddressController,
                                hintText: 'Enter your business address',
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                label: 'Business Email',
                                controller: _businessEmailController,
                                hintText: 'Enter your business email',
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                label: 'Business Description',
                                controller: _businessDescriptionController,
                                hintText: 'Enter your business description',
                              ),
                              const SizedBox(height: 16),
                              _buildPhoneTextField(),
                              const SizedBox(height: 32),
                              GestureDetector(
                                onTap: _saveChanges,
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
          bottomNavigationBar: VendorBottomNavigationBar(
            onItemTapped: (label) {
              // Handle bottom navigation bar item taps
            },
            tutorialStep: 0,
            selectedLabel: '',
          ),
        ),
        if (_isLoading) const AnyLoadingModal(),
      ],
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
          'Business Phone Number',
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
          textFieldController: _businessPhoneNumberController,
          formatInput: false,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          inputDecoration: InputDecoration(
            fillColor: const Color.fromARGB(45, 215, 215, 215),
            filled: true,
            hintText: 'Enter your business phone number',
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
