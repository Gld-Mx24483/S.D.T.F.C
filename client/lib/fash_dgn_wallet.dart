// fash_dgn_wallet.dart
// ignore_for_file: unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:google_fonts/google_fonts.dart';

import 'loading_modal.dart';
import 'trans_hist.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final bool _isPointsSelected = true;
  bool _isAmountVisible = true;
  final TextEditingController _amountController = TextEditingController();

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

            // Points Slider
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
              child: Container(
                height: 38,
                margin: const EdgeInsets.only(left: 1),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    'POINTS',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF232323),
                    ),
                  ),
                ),
              ),
            ),

            // Wallet Card
            Container(
              width: 334,
              height: 130,
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
                    color: Color.fromARGB(48, 255, 255, 255),
                    offset: Offset(0, -10),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Color.fromARGB(47, 152, 152, 152),
                    offset: Offset(0, 10),
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
                        width: 176,
                        height: 62,
                        padding: const EdgeInsets.only(left: 11),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Points Wallet',
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
                                    padding: const EdgeInsets.only(right: 55),
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
                                  width: 34,
                                  height: 34,
                                  padding: const EdgeInsets.all(3),
                                  child: Image.asset('pics/coin.png'),
                                ),
                                const SizedBox(width: 4),
                                _isAmountVisible
                                    ? Text(
                                        '2000',
                                        style: GoogleFonts.nunito(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF621B2B),
                                        ),
                                      )
                                    : Transform.translate(
                                        offset: const Offset(0, 5),
                                        child: Text(
                                          '***',
                                          style: GoogleFonts.nunito(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF621B2B),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: const Offset(180, -10),
                    child: Container(
                      width: 115,
                      height: 31,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(83, 255, 218, 116),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '100 Naira = 20 Points',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF621B2B),
                          ),
                        ),
                      ),
                    ),
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
                color: const Color.fromARGB(255, 255, 236, 184),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                border: Border.all(
                  color: const Color(0xFFE1E3EA),
                  width: 0.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 160, 162, 160),
                    offset: Offset(0, 0),
                    blurRadius: 1,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () => showFundWalletModal(context),
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
                    Image.asset(
                      'pics/coin.png',
                      width: 26,
                      height: 26,
                    ),
                  ],
                ),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TransactionHistoryPage(),
                        ),
                      );
                    },
                    child: Text(
                      'See all',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF636A64),
                      ),
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

  void showFundWalletModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                width: 400,
                height: 280,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Text
                    Center(
                      child: Container(
                        width: 350,
                        height: 29,
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          'How much do you want to fund your wallet?',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF232323),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    // Amount Label
                    Container(
                      width: 48,
                      height: 16,
                      margin: const EdgeInsets.only(top: 31),
                      child: Text(
                        'Amount',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF49454F),
                        ),
                      ),
                    ),

                    // Amount Input Field
                    Container(
                      width: 263,
                      height: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: const Color(0xFFFBE5AA),
                          width: 1.0,
                        ),
                      ),
                      child: TextField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(top: 12, left: 16.0),
                            child: Text(
                              '₦', // Always display ₦ symbol
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF49454F),
                              ),
                            ),
                          ),
                          hintText: '0.00',
                          hintStyle: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF49454F),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10.0,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF49454F),
                        ),
                      ),
                    ),

                    // Continue Button
                    Container(
                      width: 265,
                      height: 44,
                      margin: const EdgeInsets.only(top: 38),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBE5AA),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          initiatePaystackPayment(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFBE5AA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Continue',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF621B2B),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void initiatePaystackPayment(BuildContext context) async {
    const secretKey = 'sk_live_4063dacfcbf43aca67b282187d4c81cb0113e224';
    final amount = double.parse(_amountController.text) * 100;
    const currency = PaystackCurrency.ngn;

    final request = PaystackTransactionRequest(
      reference: 'ps_${DateTime.now().microsecondsSinceEpoch}',
      secretKey: secretKey,
      email: 'selldometech@gmail.com',
      amount: amount,
      currency: currency,
      channel: [
        PaystackPaymentChannel.card,
        PaystackPaymentChannel.mobileMoney,
        PaystackPaymentChannel.ussd,
        PaystackPaymentChannel.bankTransfer,
        PaystackPaymentChannel.bank,
        PaystackPaymentChannel.qr,
        PaystackPaymentChannel.eft,
      ],
    );
    final initializedTransaction =
        await PaymentService.initializeTransaction(request);

    if (!mounted) return;

    if (!initializedTransaction.status) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(initializedTransaction.message),
      ));

      return;
    }

    await PaymentService.showPaymentModal(
      // ignore: use_build_context_synchronously
      context,
      transaction: initializedTransaction, callbackUrl: '',
    );

    final response = await PaymentService.verifyTransaction(
      paystackSecretKey: secretKey,
      initializedTransaction.data?.reference ?? request.reference,
    );

    if (response.status) {
      // Payment successful, handle the response
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Payment successful!'),
        ),
      );
    } else {
      // Payment failed, handle the error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(response.message),
        ),
      );
    }
  }
}
