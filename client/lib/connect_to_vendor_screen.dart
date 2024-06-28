// connect_to_vendor_screen.dart
// ignore_for_file: unused_field, avoid_print, use_build_context_synchronously, unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'api_service.dart';
import 'connect_loading_modal.dart';
import 'location_selection_screen.dart';
import 'map_view_screen.dart';
import 'request_sent_modal.dart';

class ConnectingToVendorScreen extends StatefulWidget {
  final Map<String, dynamic> storeDetails;
  final LatLng initialPosition;
  final String? status;

  const ConnectingToVendorScreen({
    super.key,
    required this.storeDetails,
    required this.initialPosition,
    this.status,
  });

  @override
  State<ConnectingToVendorScreen> createState() =>
      _ConnectingToVendorScreenState();
}

class _ConnectingToVendorScreenState extends State<ConnectingToVendorScreen>
    with TickerProviderStateMixin {
  bool _isProcessing = false;
  bool _isRequestSent = false;
  bool _showBottomOptions = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.status != null) {
      _isProcessing = widget.status == 'pending';
      _isRequestSent = widget.status != 'canceled';
      _showBottomOptions = _isRequestSent;

      if (_showBottomOptions) {
        _animationController.forward();
      }
    }

    print('Store Details in ConnectingToVendorScreen: ${widget.storeDetails}');
    print(
        'Initial Position in ConnectingToVendorScreen: ${widget.initialPosition}');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleBottomOptions() {
    setState(() {
      _showBottomOptions = !_showBottomOptions;
    });

    if (_showBottomOptions) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _showLoadingModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingModal(
          showNextModal: _showRequestSentModal,
          fetchDetails: _fetchRequiredDetails,
        );
      },
    );
  }

  Future<void> _fetchRequiredDetails() async {
    print('Store Details: ${widget.storeDetails}');

    final storeId = widget.storeDetails['id'] as String;
    final selectedAddressId =
        widget.storeDetails['selectedAddress']['id'] as String;

    print('Vendor ID: $storeId');
    print('Selected Address ID: $selectedAddressId');

    bool connectRequestSent =
        await ApiService.sendConnectRequest(storeId, selectedAddressId);

    if (connectRequestSent) {
      print('Connect request sent successfully.');
    } else {
      print('Failed to send connect request.');
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to connect to vendor. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isProcessing = false;
      });
    }
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
              _showBottomOptions = true;
            });
            _animationController.forward();
          },
        );
      },
    );
  }

  Widget _buildIconWithText(IconData icon, String text, int color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showBottomOptions ? null : 0,
      child: AnimatedOpacity(
        opacity: _showBottomOptions ? 0.5 : 0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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
      ),
    );
  }

  void _handleConnect() {
    if (widget.status == 'ACCEPTED') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationSelectionScreen(
            shopDetails: widget.storeDetails,
          ),
        ),
      );
    } else {
      setState(() {
        _isProcessing = true;
      });
      _showLoadingModal();
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeName = widget.storeDetails['name'] as String;
    final selectedAddressIndex =
        widget.storeDetails['selectedAddressIndex'] as int?;
    final identifier = selectedAddressIndex != null &&
            widget.storeDetails['addresses'] != null &&
            (widget.storeDetails['addresses'] as List).length > 1
        ? ' (${selectedAddressIndex + 1})'
        : '';
    final logoUrl = widget.storeDetails['logo'] as String;

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
                _isRequestSent ? 'Connecting to Vendor' : 'Connect to Vendor',
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
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.network(
                        logoUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'pics/bigstore.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$storeName$identifier',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '5 Points to connect',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF621B2B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleBottomOptions,
                    child: AnimatedRotation(
                      turns: _showBottomOptions ? 0.25 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                    ),
                  ),
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
                  _isRequestSent ? 0xFF621B2B : 0xFF838384,
                ),
              ],
            ),
          ),
          const Spacer(),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _isRequestSent
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF621B2B)),
                            strokeWidth: 3,
                            backgroundColor:
                                const Color(0xFFFBE5AA).withOpacity(0.3),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Request Sent',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF621B2B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Waiting for vendor...',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF621B2B),
                          ),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: _handleConnect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBE5AA),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        widget.status == 'ACCEPTED'
                            ? 'View Map'
                            : (_isProcessing ? 'Processing...' : 'Connect'),
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF621B2B),
                        ),
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
