import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isNGNSelected = true;
  bool _isAmountVisible = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 44, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 375,
              height: 56,
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 15),
              decoration: const BoxDecoration(),
              child: Text(
                'Wallet',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF232323),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Currency Slider
            Container(
              width: 334,
              height: 46,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.fromLTRB(4, 4, 3, 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEBEBEB).withOpacity(0.5),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  _buildCurrencyButton(
                    label: 'NGN',
                    isSelected: _isNGNSelected,
                    onTap: () => setState(() => _isNGNSelected = true),
                  ),
                  _buildCurrencyButton(
                    label: 'USD',
                    isSelected: !_isNGNSelected,
                    onTap: () => setState(() => _isNGNSelected = false),
                  ),
                ],
              ),
            ),

            // Wallet Card
            Container(
              width: 334,
              height: 126,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.fromLTRB(11, 32, 0, 0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(100, 251, 229, 170),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                border: Border.all(
                  color: const Color(0xFF621B2B),
                  width: 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 253, 250, 250),
                    offset: Offset(0, 1),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Color.fromARGB(255, 248, 248, 248),
                    offset: Offset(0, -1),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 146,
                        height: 62,
                        padding: const EdgeInsets.only(left: 11),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Naira Wallet',
                                  style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF621B2B),
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => setState(() =>
                                      _isAmountVisible = !_isAmountVisible),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 25.0),
                                    child: Icon(
                                      _isAmountVisible
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: const Color(0xFF621B2B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 34,
                                  padding: const EdgeInsets.all(3),
                                  child: Text(
                                    '₦',
                                    style: GoogleFonts.nunito(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF621B2B),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '0.00',
                                  style: GoogleFonts.nunito(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF621B2B),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Fund Wallet Button
            Container(
              width: 157,
              height: 54,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.fromLTRB(26, 14, 19, 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFBE5AA),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(
                  color: const Color(0xFFE1E3EA),
                  width: 0.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF747A74),
                    offset: Offset(0, 0),
                    blurRadius: 1,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fund Wallet',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF01061C),
                    ),
                  ),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: Color(0xFF621B2B),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Color(0xFFFBE5AA),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Recent Transactions Header
            Container(
              width: 335,
              height: 19,
              margin: const EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4F4F4F),
                    ),
                  ),
                  Text(
                    'See all',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF636A64),
                    ),
                  ),
                ],
              ),
            ),

            // No Transactions
            Center(
              child: Container(
                width: 231,
                height: 153,
                margin: const EdgeInsets.only(top: 40),
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final bgColor = isSelected ? Colors.white : null;
    final textColor = isSelected ? const Color(0xFF232323) : null;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 38,
          margin: const EdgeInsets.only(left: 1),
          padding: const EdgeInsets.symmetric(horizontal: 65, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
