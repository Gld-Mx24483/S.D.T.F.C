// verification_success_modal.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class VerificationSuccessModal extends StatelessWidget {
  final VoidCallback onContinue;

  const VerificationSuccessModal({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'animations/verification_success.json',
              width: 150,
              height: 150,
              repeat: false,
            ),
            const SizedBox(height: 20),
            Text(
              'Verification Successful!',
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF621B2B),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your account has been successfully verified.',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFBE5AA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'Continue',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF621B2B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
