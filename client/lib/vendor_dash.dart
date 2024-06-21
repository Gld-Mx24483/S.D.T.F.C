// vendor_dash.dart
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'any_loading_modal.dart';
import 'api_service.dart';
import 'vendor_notification.dart';
import 'vendor_verification.dart';

class VendorDashboard extends StatefulWidget {
  const VendorDashboard({super.key});

  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  String _greeting = '';
  String _fullName = '';
  XFile? _selectedImage;
  Map<String, TimeOfDay?> openHours = {};
  Map<String, TimeOfDay?> closeHours = {};
  bool _isVerified = false;

  String _shopName = '';
  String _businessDescription = '';
  String _phoneNumber = '';
  String _emailAddress = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _determineGreeting();
    _initializeBusinessHours();
    _checkVerificationStatus();
    _fetchUserProfile();
    _fetchStoreDetails();
  }

  void _determineGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      _greeting = 'Good morning';
    } else if (hour < 17) {
      _greeting = 'Good afternoon';
    } else {
      _greeting = 'Good evening';
    }
  }

  void _fetchUserProfile() async {
    final userProfile = await ApiService.getUserProfile();
    if (userProfile != null) {
      setState(() {
        _fullName = '${userProfile['lastName']} ${userProfile['firstName']}';
      });
    }
  }

  Future<void> _fetchStoreDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final storeDetails = await ApiService.fetchStoreDetails();
      if (storeDetails != null) {
        setState(() {
          _shopName = storeDetails['name'] ?? '';
          _businessDescription = storeDetails['description'] ?? '';
          _phoneNumber = storeDetails['phone'] ?? '';
          _emailAddress = storeDetails['email'] ?? '';
        });
      } else {
        // Handle error
        print('Failed to fetch store details');
      }
    } catch (e) {
      print('Error fetching store details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initializeBusinessHours() {
    List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    for (String day in days) {
      openHours[day] = null;
      closeHours[day] = null;
    }
  }

  void _checkVerificationStatus() async {
    setState(() {
      _isVerified = false;
    });
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  void _showLogoOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logo Options',
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'What would you like to do with the logo?',
          style: GoogleFonts.nunito(
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _selectedImage = null;
              });
            },
            child: Text(
              'Delete Logo',
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: _selectImage,
            child: Text(
              'Change Logo',
              style: GoogleFonts.nunito(
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.nunito(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(
      BuildContext context, String day, bool isOpenHour) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isOpenHour) {
          openHours[day] = picked;
        } else {
          closeHours[day] = picked;
        }
      });
    }
  }

  Widget _buildDisabledTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.5,
            letterSpacing: -0.019,
            color: const Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 335.01,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEBEBEB).withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: TextEditingController(text: value),
            enabled: false,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.black54,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              hintStyle: GoogleFonts.nunito(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInputRow(String day) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              day,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectTime(context, day, true),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBEBEB).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          openHours[day] != null
                              ? openHours[day]!.format(context)
                              : '--',
                          style: GoogleFonts.nunito(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectTime(context, day, false),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBEBEB).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          closeHours[day] != null
                              ? closeHours[day]!.format(context)
                              : '--',
                          style: GoogleFonts.nunito(fontSize: 14),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const AnyLoadingModal()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 60.0),
                              child: Text(
                                '$_greeting,',
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  color: const Color.fromARGB(75, 0, 0, 0),
                                ),
                              ),
                            ),
                            Text(
                              _fullName,
                              style: GoogleFonts.nunito(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                height: 1.35,
                                color: const Color(0xFF621B2B),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const VendorNotificationScreen(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 85.0),
                                child: Image.asset(
                                  'pics/bell.png',
                                  color: const Color(0xFF621B2B),
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Logo',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        letterSpacing: -0.019,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_selectedImage == null)
                      GestureDetector(
                        onTap: _selectImage,
                        child: Container(
                          width: 335.01,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBEBEB).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Upload',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                letterSpacing: -0.019,
                                color: const Color(0xFF621B2B),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () => _showLogoOptions(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(_selectedImage!.path)),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    _buildDisabledTextField('Shop Name', _shopName),
                    const SizedBox(height: 16),
                    _buildDisabledTextField(
                        'Business Description', _businessDescription),
                    const SizedBox(height: 16),
                    Text(
                      'Verification Status',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        letterSpacing: -0.019,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _isVerified
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const VendorVerificationScreen(),
                                ),
                              );
                            },
                      child: Container(
                        width: 335.01,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBEBEB).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  if (_isVerified)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF621B2B),
                                      size: 18,
                                    ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isVerified ? 'Verified' : 'Get Verified',
                                    style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                      letterSpacing: -0.019,
                                      color: const Color(0xFF621B2B),
                                    ),
                                  ),
                                ],
                              ),
                              if (!_isVerified)
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF621B2B),
                                  size: 18,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Official Contact Information',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        letterSpacing: -0.019,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 335,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBEBEB).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDisabledTextField(
                                'Phone Number', _phoneNumber),
                            const SizedBox(height: 18),
                            _buildDisabledTextField(
                                'Email Address', _emailAddress),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Shop Location',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        letterSpacing: -0.019,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 335,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBEBEB).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDisabledTextField('Address', 'Enter address'),
                            const SizedBox(height: 18),
                            _buildDisabledTextField('City', 'Enter city'),
                            const SizedBox(height: 18),
                            _buildDisabledTextField('Country', 'Enter country'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Business Hours',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        letterSpacing: -0.019,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 335,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBEBEB).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Days                          Open Hours - Close Hours',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildTimeInputRow('Monday'),
                            _buildTimeInputRow('Tuesday'),
                            _buildTimeInputRow('Wednesday'),
                            _buildTimeInputRow('Thursday'),
                            _buildTimeInputRow('Friday'),
                            _buildTimeInputRow('Saturday'),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Save the business hours
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF621B2B),
                                ),
                                child: Text(
                                  'Save',
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Additional Information',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        letterSpacing: -0.019,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 335,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBEBEB).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          hintStyle: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
