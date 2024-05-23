//vendor_payment_receipt.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class VendorPaymentReceiptPage extends StatelessWidget {
  final String referenceNumber;
  final double amount;
  final String customerEmail;
  final DateTime paidOn;
  final String accountNumber;

  const VendorPaymentReceiptPage({
    super.key,
    required this.referenceNumber,
    required this.amount,
    required this.customerEmail,
    required this.paidOn,
    required this.accountNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 80,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Payment Successful',
                    style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 331,
              height: 283,
              margin: const EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reference Number',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF646464),
                          ),
                        ),
                        Text(
                          referenceNumber,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF212121),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF646464),
                          ),
                        ),
                        Text(
                          '₦${amount.toStringAsFixed(2)}',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF212121),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Customer Email',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF646464),
                          ),
                        ),
                        Text(
                          customerEmail,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF212121),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Paid On',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF646464),
                          ),
                        ),
                        Text(
                          paidOn.toString().split(' ')[0],
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF212121),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Account Number',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF646464),
                          ),
                        ),
                        Text(
                          accountNumber,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF212121),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 140.0),
              child: Positioned(
                child: Column(
                  children: [
                    Container(
                      width: 337,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFFBE5AA),
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            // Handle 'Done' button press
                            Navigator.pop(context);
                          },
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
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 337,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFFBE5AA),
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            // Handle 'Print' button press
                            Printing.layoutPdf(
                              onLayout: (PdfPageFormat format) async =>
                                  await _printReceipt(format),
                            );
                          },
                          child: Text(
                            'Print',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF621B2B),
                            ),
                          ),
                        ),
                      ),
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

  Future<Uint8List> _printReceipt(PdfPageFormat format) async {
    // Create a PDF document
    final doc = await Printing.convertHtml(
      format: format,
      html: _generateReceiptHtml(),
    );

    // Return the PDF document as bytes
    return doc;
  }

  String _generateReceiptHtml() {
    return '''
<!DOCTYPE html>
<html>
  <head>
    <style>
      body {
        font-family: 'Nunito', sans-serif;font-size: 14px;
        color: #212121;
      }
      .row {
        display: flex;
        justify-content: space-between;
        margin-bottom: 10px;
      }
      .label {
        color: #646464;
        font-weight: 500;
      }
      .value {
        font-weight: 600;
      }
    </style>
  </head>
  <body>
    <div style="text-align: center; margin-bottom: 20px;">
      <img src="pics/check.png" alt="Payment Successful" width="80" height="80">
      <h1 style="color: green; font-weight: bold;">Payment Successful</h1>
    </div>
    <div class="row">
      <span class="label">Reference Number</span>
      <span class="value">$referenceNumber</span>
    </div>
    <div class="row">
      <span class="label">Amount</span>
      <span class="value">₦${amount.toStringAsFixed(2)}</span>
    </div>
    <div class="row">
      <span class="label">Customer Email</span>
      <span class="value">$customerEmail</span>
    </div>
    <div class="row">
      <span class="label">Paid On</span>
      <span class="value">${paidOn.toString().split(' ')[0]}</span>
    </div>
    <div class="row">
      <span class="label">Account Number</span>
      <span class="value">$accountNumber</span>
    </div>
  </body>
</html>
''';
  }
}
