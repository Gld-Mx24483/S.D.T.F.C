import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'fash_pay_pts.dart';

class BuyPointsPage extends StatelessWidget {
  const BuyPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: 375,
              height: 56,
              margin: const EdgeInsets.only(right: 80),
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
                    'Buy Points',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF232323),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 275,
              height: 18,
              margin: const EdgeInsets.only(top: 30, bottom: 10, right: 30),
              child: const Text(
                'Enjoy 1 Points bonus on your first transaction',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF621B2B),
                ),
              ),
            ),
            ..._buildFundingOptions(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFundingOptions(BuildContext context) {
    const options = [
      {'points': 200, 'nairaValue': 10},
      {'points': 400, 'nairaValue': 20},
      {'points': 600, 'nairaValue': 30},
      {'points': 800, 'nairaValue': 40},
    ];

    return options.map((option) {
      return Container(
        width: 325,
        height: 72,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          border: Border.all(color: const Color(0xFFEEEFF2)),
          color: const Color.fromARGB(255, 248, 247, 247),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Image.asset(
                  'pics/coin.png',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${option['points']} Points',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF232323),
                      ),
                    ),
                    Text(
                      '₦${option['nairaValue']} = 20 Points',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF383838),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PayPointsPage(
                      points: option['points'] ?? 0, // Default to 0 if null
                      nairaValue:
                          option['nairaValue'] ?? 0, // Default to 0 if null
                    ),
                  ),
                );
              },
              child: Container(
                width: 57,
                height: 20,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  color: Color(0xFFFBE5AA),
                ),
                child: Center(
                  child: Text(
                    'Buy Now',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF621B2B),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
