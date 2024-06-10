// connect_to_vendor_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'loading_modal.dart';
import 'map_view_screen.dart';
import 'request_sent_modal.dart';

class ConnectingToVendorScreen extends StatefulWidget {
  final Map<String, dynamic> shopDetails;
  final LatLng initialPosition;

  const ConnectingToVendorScreen({
    super.key,
    required this.shopDetails,
    required this.initialPosition,
  });

  @override
  State<ConnectingToVendorScreen> createState() =>
      _ConnectingToVendorScreenState();
}

class _ConnectingToVendorScreenState extends State<ConnectingToVendorScreen> {
  bool _isProcessing = false;
  bool _isRequestSent = false;
  Timer? _autoNavigationTimer;

  @override
  void dispose() {
    _autoNavigationTimer?.cancel();
    super.dispose();
  }

  void _showLoadingModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingModal(
          showNextModal: _showRequestSentModal,
        );
      },
    );
  }

  void _showRequestSentModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return RequestSentModal(
          onComplete: () {
            setState(() {
              _isProcessing = false;
              _isRequestSent = true;
            });
            _startAutoNavigationTimer();
          },
        );
      },
    );
  }

  void _startAutoNavigationTimer() {
    _autoNavigationTimer = Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: MapViewScreen(
                selectedLocation: widget.shopDetails['position'],
                initialPosition: widget.initialPosition,
                shopDetails: widget.shopDetails,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 20),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                _isRequestSent ? 'Connected to Vendor' : 'Connecting to Vendor',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 336,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'pics/store.png',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.shopDetails['name'],
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.black),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconWithText(
                  Icons.call_outlined,
                  'Call',
                  _isRequestSent ? 0xFF621B2B : 0xFF838384,
                ),
                _buildIconWithText(
                  Icons.chat_outlined,
                  'Chat',
                  _isRequestSent ? 0xFF621B2B : 0xFF838384,
                ),
                _buildIconWithText(
                  Icons.cancel_outlined,
                  'Cancel',
                  0xFF621B2B,
                ),
              ],
            ),
          ),
          const Spacer(),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  if (_isRequestSent) {
                    // Do nothing, as we'll automatically navigate after 3 seconds
                  } else {
                    setState(() {
                      _isProcessing = true;
                    });
                    _showLoadingModal();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFBE5AA),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _isProcessing
                      ? 'Processing...'
                      : (_isRequestSent ? 'Sent' : 'Process'),
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
    );
  }

  Widget _buildIconWithText(IconData icon, String text, int color) {
    return Column(
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
    );
  }
}
