// vendor_profile.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'sign_out.dart';
import 'vendor_acct.dart';
import 'vendor_buss.dart';
import 'vendor_loc.dart';
import 'vendor_nots.dart';
import 'vendor_pas.dart';
import 'vendor_verification.dart';

class VendorProfileScreen extends StatelessWidget {
  const VendorProfileScreen({super.key});

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
                        'Profile',
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
              Container(
                width: 345,
                height: 88,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFF4F4F6),
                    ),
                    bottom: BorderSide(
                      color: Color(0xFFF4F4F6),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFEBEBEB).withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Container(
                            width: 50.03,
                            height: 56,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFC4C4C4),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 14.43),
                          Container(
                            width: 200,
                            height: 46,
                            padding: const EdgeInsets.only(right: 4.67),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SellDome Tech Vendor',
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '0123-4567-890',
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFA6A6A6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildFrameButton(
                icon: Icons.person,
                iconColor: const Color(0xFFA6A6A6),
                text: 'My Account',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VendorMyAcctScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildFrameButton(
                icon: Icons.business_outlined,
                iconColor: const Color(0xFFA6A6A6),
                text: 'Business Details',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VendorBussScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildFrameButton(
                icon: Icons.verified_user_outlined,
                iconColor: const Color(0xFFA6A6A6),
                text: 'Verification',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VendorVerificationScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildFrameButton(
                icon: Icons.lock,
                iconColor: const Color(0xFFA6A6A6),
                text: 'Change Password',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VendorPasScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildFrameButton(
                icon: Icons.inventory_2_outlined,
                iconColor: const Color(0xFFA6A6A6),
                text: 'Inventory',
                onTap: () {
                  // Add navigation or other logic here if needed
                },
              ),
              const SizedBox(height: 20),
              _buildFrameButton(
                icon: Icons.notifications_outlined,
                iconColor: const Color(0xFFA6A6A6),
                text: 'Notifications',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VendorNotsScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildFrameButton(
                icon: Icons.location_on_outlined,
                iconColor: const Color(0xFFA6A6A6),
                text: 'Add New Location',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VendorLocScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildFrameButton(
                icon: Icons.exit_to_app,
                iconColor: const Color(0xFFE53935),
                text: 'Sign Out',
                textColor: const Color(0xFFE53935),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const SignOutModal();
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrameButton({
    required IconData icon,
    required Color iconColor,
    required String text,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 326,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFEBEBEB).withOpacity(0.3),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFF0F5FF),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 20.73),
              Text(
                text,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? const Color(0xFF111827),
                ),
              ),
              const Spacer(),
              Container(
                width: 21.5,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: textColor ?? const Color(0xFF111827),
                  size: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}