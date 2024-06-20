//vendor_trans_hist.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'selected_vendor_trans_hist.dart';
import 'vendor_wallet.dart';

class VendorTransactionHistoryPage extends StatefulWidget {
  final List<VendorTransactionItem> transactions;

  const VendorTransactionHistoryPage({super.key, required this.transactions});

  @override
  _VendorTransactionHistoryPageState createState() =>
      _VendorTransactionHistoryPageState();
}

class _VendorTransactionHistoryPageState
    extends State<VendorTransactionHistoryPage> {
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
            Expanded(
              child: widget.transactions.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: widget.transactions.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SelectedVendorTransactionHistory(
                                  transaction: widget.transactions[index],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              width: 335,
                              height: 72,
                              padding: const EdgeInsets.fromLTRB(8, 16, 20, 16),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(172, 235, 235, 235),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFEEEFF2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              137, 221, 221, 221),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Image.asset(
                                            'pics/coin.png',
                                            width: 24,
                                            height: 24,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget.transactions[index]
                                                .description,
                                            style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF232323),
                                            ),
                                          ),
                                          Text(
                                            widget.transactions[index].date,
                                            style: GoogleFonts.nunito(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF636A64),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'pics/coin.png',
                                        width: 16,
                                        height: 18,
                                      ),
                                      Text(
                                        widget.transactions[index].points,
                                        style: GoogleFonts.nunito(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: widget
                                                  .transactions[index].isCredit
                                              ? const Color(0xFF157F0B)
                                              : const Color(0xFFB51A1B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: SizedBox(
                        width: 231,
                        height: 153,
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
            ),
          ],
        ),
      ),
    );
  }
}
