//role.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fash_dgn.dart';
import 'vendor.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  RoleScreenState createState() => RoleScreenState();
}

class RoleScreenState extends State<RoleScreen> {
  bool isDesignerSelected = false;
  bool isVendorSelected = false;

  void _navigateToFashionDesignerScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FashionDesignerScreen()),
    );
  }

  void _navigateToVendorScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VendorScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          Positioned(
            top: 60,
            left: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ),
          Positioned(
            width: 255,
            height: 36,
            top: 114,
            left: 5,
            child: Text(
              'Select your Preference',
              style: GoogleFonts.nunito(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                height: 1.5,
                letterSpacing: -0.019,
                color: const Color(0xFF621B2B),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            width: 278,
            height: 29,
            top: 152,
            left: 20,
            child: Text(
              'Sign up as a Fashion Designer or Vendor',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.5,
                letterSpacing: -0.019,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: 234,
            left: 13,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDesignerSelected = true;
                      isVendorSelected = false;
                    });
                  },
                  child: Container(
                    width: 160,
                    height: 174,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDesignerSelected
                            ? const Color(0xFF621B2B)
                            : const Color(0xFFD8D7D7),
                      ),
                      color: isDesignerSelected
                          ? const Color.fromARGB(255, 255, 246, 224)
                              .withOpacity(0.9)
                          : null,
                      boxShadow: isDesignerSelected
                          ? [
                              const BoxShadow(
                                color: Color(0x33621B2B),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                              ),
                              const BoxShadow(
                                color: Color(0x4D621B2B),
                                offset: Offset(0, -2),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDesignerSelected
                                  ? const Color(0xFF621B2B)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isDesignerSelected
                                    ? const Color(0xFF621B2B)
                                    : const Color(0xFFD8D7D7),
                              ),
                            ),
                            child: isDesignerSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12,
                                  )
                                : const SizedBox(),
                          ),
                        ),
                        Positioned(
                          width: 48,
                          height: 46,
                          top: 42,
                          left: 56,
                          child: Center(
                            child: Image.asset(
                              'pics/fd.png',
                              color: isDesignerSelected
                                  ? const Color(0xFF621B2B)
                                  : null,
                            ),
                          ),
                        ),
                        Positioned(
                          width: 108,
                          height: 29,
                          top: 104,
                          left: 26,
                          child: Text(
                            'Fashion Designer',
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              letterSpacing: -0.019,
                              color: isDesignerSelected
                                  ? const Color(0xFF621B2B)
                                  : const Color(0xFFA6A6A6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDesignerSelected = false;
                      isVendorSelected = true;
                    });
                  },
                  child: Container(
                    width: 160,
                    height: 174,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isVendorSelected
                            ? const Color(0xFF621B2B)
                            : const Color(0xFFD8D7D7),
                      ),
                      color: isVendorSelected
                          ? const Color.fromARGB(255, 255, 246, 224)
                              .withOpacity(0.9)
                          : null,
                      boxShadow: isVendorSelected
                          ? [
                              const BoxShadow(
                                color: Color(0x33621B2B),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                              ),
                              const BoxShadow(
                                color: Color(0x4D621B2B),
                                offset: Offset(0, -2),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isVendorSelected
                                  ? const Color(0xFF621B2B)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isVendorSelected
                                    ? const Color(0xFF621B2B)
                                    : const Color(0xFFD8D7D7),
                              ),
                            ),
                            child: isVendorSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12,
                                  )
                                : const SizedBox(),
                          ),
                        ),
                        Positioned(
                          width: 47,
                          height: 45,
                          top: 42,
                          left: 56,
                          child: Center(
                            child: Image.asset(
                              'pics/vd.png',
                              color: isVendorSelected
                                  ? const Color(0xFF621B2B)
                                  : null,
                            ),
                          ),
                        ),
                        Positioned(
                          width: 46,
                          height: 29,
                          top: 102,
                          left: 57,
                          child: Text(
                            'Vendor',
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              letterSpacing: -0.019,
                              color: isVendorSelected
                                  ? const Color(0xFF621B2B)
                                  : const Color(0xFFA6A6A6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 715,
            left: 13,
            child: GestureDetector(
              onTap: isDesignerSelected
                  ? () {
                      _navigateToFashionDesignerScreen();
                    }
                  : isVendorSelected
                      ? () {
                          _navigateToVendorScreen();
                        }
                      : null,
              child: Container(
                width: 337,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBE5AA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Continue',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      color: isDesignerSelected || isVendorSelected
                          ? const Color(0xFF621B2B)
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
