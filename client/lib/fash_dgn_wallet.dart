// fash_dgn_wallet.dart
// ignore_for_file: unused_import, unused_field, use_build_context_synchronously, avoid_print, unused_element
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'any_loading_modal.dart';
import 'api_service.dart';
import 'loading_modal.dart';
import 'selected_trans_hist.dart';
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
  int _walletPoints = 0;
  List<TransactionItem> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchUserProfile().then((_) {
      _fetchData();
      fetchWalletBalance();
    });
  }

  void _navigateToTransactionDetails(TransactionItem transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SelectedTransactionHistory(transaction: transaction),
      ),
    );
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    await fetchUserProfile().then((_) {
      fetchWalletBalance();
      fetchRecentTransactions();
    });

    setState(() {
      _isLoading = false;
    });
  }

  String? userEmail;

  Future<void> fetchUserProfile() async {
    final userProfile = await ApiService.getUserProfile();
    if (userProfile != null) {
      userEmail = userProfile['email'];
      if (userEmail == null) {
        print('User email is null');
      }
    } else {
      print('Failed to fetch user profile');
    }
  }

  Future<void> fetchWalletBalance() async {
    final url = Uri.parse('${ApiService.baseUrl}/connects/wallet/balance');
    final accessToken = await ApiService.getAccessToken();

    if (accessToken == null) {
      print('No access token found');
      return;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['data'] != null && responseData['data'] is Map) {
          final walletBalance = responseData['data']['balance'] ?? '***';
          print('Fetched wallet balance: $walletBalance');
          setState(() {
            _walletPoints = walletBalance.toInt();
          });
        } else {
          print('Failed to fetch wallet balance: ${response.body}');
        }
      } else {
        print('Failed to fetch wallet balance: ${response.body}');
      }
    } catch (e) {
      print('Error fetching wallet balance: $e');
    }
  }

  Future<void> fetchRecentTransactions() async {
    final transactions = await ApiService.fetchRecentTransactions();
    if (transactions != null) {
      print('Received transactions:');
      for (var transaction in transactions) {
        print('Transaction Details:');
        print('Id: ${transaction['id']}');
        print('Amount: ${transaction['amount']}');
        print('Reference: ${transaction['reference']}');
        print('Points: ${transaction['point']}');
        print('Created At: ${transaction['createdAt']}');

        final createdAt = transaction['createdAt'] as List<dynamic>;
        final year = createdAt[0];
        final month = createdAt[1];
        final day = createdAt[2];
        final hour = createdAt[3];
        final minute = createdAt[4];
        final second = createdAt[5];

        final filteredCreatedAt =
            DateTime(year, month, day, hour, minute, second);
        final formattedDate =
            DateFormat('yyyy/MM/dd hh:mm a').format(filteredCreatedAt);
        print('Filtered Created At: $formattedDate');

        print('---');
      }

      // Sort transactions by createdAt in descending order
      transactions.sort((a, b) {
        final createdAtA = a['createdAt'] as List<dynamic>;
        final createdAtB = b['createdAt'] as List<dynamic>;

        final dateA = DateTime(createdAtA[0], createdAtA[1], createdAtA[2],
            createdAtA[3], createdAtA[4], createdAtA[5]);
        final dateB = DateTime(createdAtB[0], createdAtB[1], createdAtB[2],
            createdAtB[3], createdAtB[4], createdAtB[5]);

        return dateB.compareTo(dateA); // Sort in descending order
      });

      setState(() {
        _transactions = transactions.map((transaction) {
          final isCredit = transaction['point'] > 0;
          final createdAt = transaction['createdAt'] as List<dynamic>;
          final year = createdAt[0];
          final month = createdAt[1];
          final day = createdAt[2];
          final hour = createdAt[3];
          final minute = createdAt[4];
          final second = createdAt[5];

          final filteredCreatedAt =
              DateTime(year, month, day, hour, minute, second);
          final formattedDate =
              DateFormat('yyyy/MM/dd hh:mm a').format(filteredCreatedAt);

          return TransactionItem(
            description: 'Top Up from NGN Wallet',
            date: formattedDate,
            points: '${isCredit ? '' : ''}${transaction['point'].round()}',
            isCredit: isCredit,
            createdAt: transaction['createdAt'], // Add this line
            amount: transaction['amount'].toString(), // Add this line
            reference: transaction['reference'], // Add this line
          );
        }).toList();
      });
    } else {
      print('Failed to fetch recent transactions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      if (_isLoading)
        const AnyLoadingModal() // Show the loading modal if _isLoading is true
      else
        SingleChildScrollView(
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
                                        padding:
                                            const EdgeInsets.only(right: 55),
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
                                            _walletPoints.toString(),
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
                              builder: (context) => TransactionHistoryPage(
                                  transactions: _transactions),
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
                const SizedBox(height: 1),
                _transactions.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _transactions.length > 3
                            ? 3
                            : _transactions.length, // Limit to 3 items
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SelectedTransactionHistory(
                                    transaction: _transactions[index],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                width: 335,
                                height: 72,
                                padding:
                                    const EdgeInsets.fromLTRB(8, 16, 20, 16),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(172, 235, 235, 235),
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
                                              _transactions[index].description,
                                              style: GoogleFonts.nunito(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF232323),
                                              ),
                                            ),
                                            Text(
                                              _transactions[index].date,
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
                                        const SizedBox(width: 4),
                                        Text(
                                          _transactions[index].points,
                                          style: GoogleFonts.nunito(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: _transactions[index].isCredit
                                                ? const Color(0xFF157F0B)
                                                : const Color(0xFFB51A1B),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
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
        ),
    ]);
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
                              '₦',
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
                          showPointsConversionModal(context);
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

  void showPointsConversionModal(BuildContext context) {
    final nairaAmount = double.parse(_amountController.text);
    final pointsAmount = (nairaAmount / 100) * 20;
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
                    Center(
                      child: Container(
                        width: 350,
                        height: 29,
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Points to be received:',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF232323),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 16,
                      margin: const EdgeInsets.only(top: 31),
                      child: Text(
                        'Points',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF49454F),
                        ),
                      ),
                    ),
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
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Image.asset(
                              'pics/coin.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            pointsAmount.toInt().toString(),
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF49454F),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 263,
                      height: 20,
                      margin: const EdgeInsets.only(top: 5, left: 2),
                      child: Text(
                        '100 Naira = 20 Points',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF49454F),
                        ),
                      ),
                    ),
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
    if (userEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to fetch user email'),
        ),
      );
      return;
    }
    // const secretKey = 'sk_live_4063dacfcbf43aca67b282187d4c81cb0113e224';
    const secretKey = 'sk_test_17b7c77bf4e8f219d2dd44cc4f9a5c3f0b87db7a';
    final amount = double.parse(_amountController.text) * 100;
    final nairaAmount = double.parse(_amountController.text);
    const currency = PaystackCurrency.ngn;
    final request = PaystackTransactionRequest(
      reference: 'ps_${DateTime.now().microsecondsSinceEpoch}',
      secretKey: secretKey,
      email: userEmail ?? '',
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(initializedTransaction.message),
      ));

      return;
    }

    await PaymentService.showPaymentModal(
      context,
      transaction: initializedTransaction,
      callbackUrl: '',
    );

    final response = await PaymentService.verifyTransaction(
      paystackSecretKey: secretKey,
      initializedTransaction.data?.reference ?? request.reference,
    );

    print(response);

    if (response.status &&
        response.data.status == PaystackTransactionStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Payment successful!'),
        ),
      );

      // Print payment details to the console
      final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      final dateTime = DateTime.now();
      print('Reference: ${response.data.reference}');
      print('Id: ${response.data.id}');
      print('Email: ${request.email}');
      print('Amount: $nairaAmount');
      print('Points: ${(nairaAmount / 100) * 20}');
      print('Date: ${formatter.format(dateTime)}');

      // Update wallet points
      final pointsReceived = (nairaAmount / 100) * 20;
      setState(() {
        _walletPoints += pointsReceived.toInt();
        _transactions.insert(
          0,
          TransactionItem(
            description: 'Top Up from NGN Wallet',
            date: formatter.format(dateTime),
            points: '+${pointsReceived.toInt()}',
            isCredit: true,
            reference: '',
            amount: '',
            createdAt: [],
          ),
        );
      });

      // Send transaction details to the server
      final transactionDetails = {
        'reference': response.data.reference,
        'id': response.data.id,
        'email': request.email,
        'amount': nairaAmount,
        'points': pointsReceived.toInt(),
      };

      final apiResponse =
          await ApiService.sendTransactionDetails(transactionDetails);
      if (apiResponse != null) {
        print('Transaction details sent successfully');
      } else {
        print('Failed to send transaction details');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Payment Verification Failed'),
        ),
      );
    }
  }
}

class TransactionItem {
  final String description;
  final String date;
  final String points;
  final bool isCredit;
  final List<dynamic> createdAt;
  final String amount;
  final String reference;

  TransactionItem({
    required this.description,
    required this.date,
    required this.points,
    required this.isCredit,
    required this.createdAt,
    required this.amount,
    required this.reference,
  });
}
