// vendor_snd_pts.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'designer_main_screen.dart';

class VendorSendPointsSuccessPage extends StatelessWidget {
  final int pointsTransferred;

  const VendorSendPointsSuccessPage(
      {super.key, required this.pointsTransferred});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: 279,
            height: 148,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00AC47),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Successful',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF232323),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$pointsTransferred Points has been transferred successfully',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF363636),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const DesignerMainScreen(
                  isNewDesigner: false,
                  initialPage: 'Wallet',
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFBE5AA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            'Done',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF621B2B),
            ),
          ),
        ),
      ),
    );
  }
}
