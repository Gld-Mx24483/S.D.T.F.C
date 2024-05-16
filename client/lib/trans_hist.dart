//trans-hist.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: 375,
              height: 56,
              padding: const EdgeInsets.fromLTRB(15, 26, 135, 5),
              decoration: const BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.fromLTRB(4.42, 0, 4, 4.42),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  Text(
                    'Transaction History',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF232323),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                width: 231,
                height: 153,
                margin: const EdgeInsets.only(top: 250),
                child: Column(
                  children: [
                    Image.asset(
                      'pics/nothinghere.png',
                      width: 130,
                      height: 111,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'You haven\'t made any transactions yet.',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
