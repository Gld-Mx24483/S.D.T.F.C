// ven_prof_dets.dart
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'fashven_chat.dart';
import 'ven_proof_dets_bottom_navigation_bar.dart';

class VendorProfileDetails extends StatefulWidget {
  final String selectedLocationName;
  final String address;
  final String phoneNumber;
  final String logo;

  const VendorProfileDetails({
    super.key,
    required this.selectedLocationName,
    required this.address,
    required this.phoneNumber,
    required this.logo,
  });

  @override
  State<VendorProfileDetails> createState() => _VendorProfileDetailsState();
}

class _VendorProfileDetailsState extends State<VendorProfileDetails> {
  String _selectedLabel = 'Profile';
  int _selectedStarIndex = 0; // Track the selected star index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.network(
                    widget.logo,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'pics/bigstore.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 250,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.selectedLocationName,
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF621B2B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.address,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildIconWithText(
                            Icons.call_outlined, 'Call', 0xFF621B2B, () {
                          _makePhoneCall(widget.phoneNumber);
                        }),
                        _buildIconWithText(
                            Icons.chat_outlined, 'Chat', 0xFF621B2B, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FashvenChat(
                                selectedLocationName:
                                    widget.selectedLocationName,
                                phoneNumber: widget.phoneNumber,
                                address: widget.address,
                                logo: widget.logo,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedStarIndex = index;
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        index <= _selectedStarIndex
                            ? Icons.star
                            : Icons.star_border,
                        color: const Color(0xFFFAD776),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 333,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildColumn('Products', '500'),
                    _buildColumn('Shops', '10'),
                    _buildColumn('Good Reviews', '100'),
                    _buildColumn('Bad Reviews', '2'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onItemTapped: _onBottomNavigationBarItemTapped,
        tutorialStep: 0,
        selectedLabel: _selectedLabel,
      ),
    );
  }

  void _onBottomNavigationBarItemTapped(String label) {
    setState(() {
      _selectedLabel = label;
      // Perform any additional actions based on the selected label
    });
  }

  Widget _buildIconWithText(IconData icon, String text, int color,
      [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: Color(color),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(color),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String header, String data) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Text(
            header,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF621B2B),
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            data,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      print('Could not launch $launchUri');
    }
  }
}
