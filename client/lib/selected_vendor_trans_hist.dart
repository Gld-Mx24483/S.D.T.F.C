//selected_vendor_trans_hist.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'vendor_wallet.dart';

class SelectedVendorTransactionHistory extends StatelessWidget {
  final VendorTransactionItem transaction;

  const SelectedVendorTransactionHistory(
      {super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final createdAt = transaction.createdAt;
    final year = createdAt[0];
    final month = createdAt[1];
    final day = createdAt[2];
    final hour = createdAt[3];
    final minute = createdAt[4];
    final second = createdAt[5];

    final filteredCreatedAt = DateTime(year, month, day, hour, minute, second);
    final formatter = DateFormat('MMMM d, yyyy hh:mm a');
    final formattedDate = formatter.format(filteredCreatedAt);
    final datePart =
        '${formattedDate.split(' ')[0]} ${formattedDate.split(' ')[1]} ${formattedDate.split(' ')[2]}'; // e.g., August 5, 2023
    final timePart =
        '${formattedDate.split(' ')[3]} ${formattedDate.split(' ')[4]}';

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
                ],
              ),
            ),
            Center(
              child: Text(
                'Wallet Top Up',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF646464),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'pics/coin.png',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    transaction.points,
                    style: GoogleFonts.nunito(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF363636),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: 331,
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      _buildTableRow('Date', datePart),
                      _buildTableRow('Time', timePart),
                      _buildTableRow(
                          'Amount Tendered NGN', '₦${transaction.amount}0'),
                      _buildTableRow(
                          'Amount of Points Received', transaction.points,
                          isPoints: true),
                      _buildTableRow('Type', 'DEPOSIT'),
                      _buildTableRow('Reference', transaction.reference),
                      _buildTableRow('Status', 'Successful', isStatus: true),
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

  TableRow _buildTableRow(String label, String value,
      {bool isPoints = false, bool isStatus = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: TableCell(
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF212121),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: TableCell(
            child: Align(
              alignment: Alignment.centerRight,
              child: isPoints
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'pics/coin.png',
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          value,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF212121),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      value,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isStatus
                            ? const Color(0xFF149607)
                            : const Color(0xFF212121),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
