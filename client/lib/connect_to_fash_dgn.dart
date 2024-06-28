// connect_to_fash_dgn.dart
// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api_service.dart';
import 'loading_modal.dart';
import 'request_accepted_modal.dart';
import 'vendor_cnt.dart';
import 'venfash_chat.dart';

class ConnectToFashDgn extends StatefulWidget {
  final String designerName;
  final String? userImage;
  final Map<String, dynamic> connectionDetails;
  final bool isAlreadyConnected;

  const ConnectToFashDgn({
    super.key,
    required this.designerName,
    this.userImage,
    required this.connectionDetails,
    this.isAlreadyConnected = false,
  });

  @override
  State<ConnectToFashDgn> createState() => _ConnectToFashDgnState();
}

class _ConnectToFashDgnState extends State<ConnectToFashDgn> {
  bool _showBottomOptions = false;
  bool _isProcessing = false;
  late bool _isRequestAccepted;

  @override
  void initState() {
    super.initState();
    _isRequestAccepted = widget.isAlreadyConnected;
    _printConnectionDetails();
  }

  void _printConnectionDetails() {
    print('Selected Connection Details:');
    print(widget.connectionDetails);
  }

  Future<void> _acceptRequest() async {
    setState(() {
      _isProcessing = true;
    });

    final connectId = widget.connectionDetails['id'];
    final success = await ApiService.acceptConnectRequest(connectId);

    setState(() {
      _isProcessing = false;
    });

    if (success) {
      _showLoadingModal();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to accept request. Please try again.')),
      );
    }
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _isRequestAccepted
                    ? 'Connected to Fashion Designer'
                    : 'Connecting to Fashion Designer',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: widget.userImage != null
                      ? DecorationImage(
                          image: NetworkImage(widget.userImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: widget.userImage == null
                    ? Icon(Icons.person, size: 30, color: Colors.grey[600])
                    : null,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.designerName,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '5 Points to connect',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF621B2B),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showBottomOptions = !_showBottomOptions;
                  });
                },
                child: AnimatedRotation(
                  turns: _showBottomOptions ? 0.25 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFA6A6A6),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (_showBottomOptions)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconWithText(
                    Icons.call_outlined,
                    'Call',
                    _isRequestAccepted ? 0xFF621B2B : 0xFFA6A6A6,
                    _isRequestAccepted ? _makePhoneCall : null,
                  ),
                  _buildIconWithText(
                    Icons.chat_outlined,
                    'Chat',
                    _isRequestAccepted ? 0xFF621B2B : 0xFFA6A6A6,
                    _isRequestAccepted ? _navigateToChat : null,
                  ),
                  _buildIconWithText(
                    Icons.cancel_outlined,
                    'Cancel',
                    0xFF621B2B,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 2),
                    image: const DecorationImage(
                      image: AssetImage('pics/3.png'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Product Category : Fabrics',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Product Type : Silk',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Colour Code : 0xFFAD43T2',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Quantity : 5 Yards',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              if (_isRequestAccepted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VenCnt(),
                  ),
                );
              } else {
                _acceptRequest();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFBE5AA),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              _isProcessing
                  ? 'Processing...'
                  : (_isRequestAccepted ? 'Back to Connect' : 'Accept Request'),
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF621B2B),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconWithText(IconData icon, String text, int color,
      [Function? onTap]) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap() : null,
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: Color(color),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(color),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  void _showLoadingModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingModal(
          showNextModal: _showRequestAcceptedModal,
        );
      },
    );
  }

  void _showRequestAcceptedModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return RequestAcceptedModal(
          onComplete: () {
            setState(() {
              _isProcessing = false;
              _isRequestAccepted = true;
            });
          },
          onDismissed: () {},
        );
      },
    );
  }

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '08155757196',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      print('Could not launch $launchUri');
    }
  }

  void _navigateToChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VenfashChat(
          selectedLocationName: widget.designerName,
          phoneNumber: '08106775111',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildContent(),
      ),
    );
  }
}
