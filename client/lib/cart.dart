import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 375,
        height: 812,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Container(
                width: 375,
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
                        margin: const EdgeInsets.only(
                          left: 20,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color.fromARGB(255, 1, 1, 1),
                        ),
                      ),
                    ),
                    Text(
                      'Cart',
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
            const SizedBox(height: 371),
            Text(
              'No Cart',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFA6A6A6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
