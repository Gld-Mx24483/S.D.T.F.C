// vendor_main_screen.dart
// ignore_for_file: deprecated_member_use, unused_element

import 'dart:async';

import 'package:client/sign_out.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'vendor_bottom_navigation_bar.dart';
import 'vendor_dash.dart';
import 'vendor_no_record_screen.dart';
import 'vendor_products.dart';
import 'vendor_profile.dart';
import 'vendor_wallet.dart';

class VendorMainScreen extends StatefulWidget {
  final bool isNewDesigner;
  final String initialPage;

  const VendorMainScreen({
    super.key,
    this.isNewDesigner = false,
    this.initialPage = 'Shop',
  });

  @override
  State<VendorMainScreen> createState() => _VendorMainScreenState();
}

class _VendorMainScreenState extends State<VendorMainScreen>
    with TickerProviderStateMixin {
  late Widget _currentScreen;
  bool _showTutorial = false;
  int _tutorialStep = 0;
  Timer? _tutorialTimer;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  String _selectedLabel = '';

  @override
  void initState() {
    super.initState();
    _selectedLabel = widget.initialPage;
    _currentScreen = _getInitialScreen();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isNewDesigner) {
      _tutorialTimer = Timer(const Duration(seconds: 2), () {
        setState(() {
          _showTutorial = true;
          _controller.forward();
        });
      });
    }
  }

  Widget _getInitialScreen() {
    switch (widget.initialPage) {
      case 'Wallet':
      // return const WalletScreen();
      case 'Shop':
      default:
        return widget.isNewDesigner
            ? const VendorNoRecordScreen(key: ValueKey('VendorNoRecordScreen'))
            : const VendorDashboard();
    }
  }

  @override
  void dispose() {
    _tutorialTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onVendorBottomNavigationBarItemTapped(String label) {
    setState(() {
      _selectedLabel = label;
      switch (label) {
        case 'Shop':
          _currentScreen = const VendorDashboard();
          break;
        case 'Wallet':
          _currentScreen = const VendorWalletScreen();
          break;
        case 'Products':
          _currentScreen = const VendorProductsScreen();
          break;
        case 'Profile':
          _currentScreen = const VendorProfileScreen();
          break;
      }
    });
  }

  void _nextTutorialStep() {
    setState(() {
      if (_tutorialStep == 5) {
        _currentScreen = const VendorDashboard();
        _showTutorial = false;
      } else {
        _tutorialStep++;
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return const SignOutModal();
          },
        );
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            body: _currentScreen,
            bottomNavigationBar: VendorBottomNavigationBar(
              onItemTapped: _onVendorBottomNavigationBarItemTapped,
              tutorialStep: _tutorialStep,
              selectedLabel: _selectedLabel,
            ),
          ),
          if (_showTutorial)
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Positioned.fill(
                  child: Container(
                    color: const Color(0xFF000000).withOpacity(0.7),
                    child: Stack(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            Offset beginOffset;
                            switch (_tutorialStep) {
                              case 0:
                                beginOffset = const Offset(0.0, 1.0);
                                break;
                              case 1:
                                beginOffset = const Offset(-1.0, 0.0);
                                break;
                              case 2:
                                beginOffset = const Offset(1.0, 0.0);
                                break;
                              case 3:
                                beginOffset = const Offset(0.0, -1.0);
                                break;
                              case 4:
                                beginOffset = const Offset(0.0, 1.0);
                                break;
                              case 5:
                                beginOffset = const Offset(0.0, 1.0);
                                break;
                              default:
                                beginOffset = const Offset(0.0, 1.0);
                            }
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: beginOffset,
                                end: Offset.zero,
                              ).animate(animation),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: _buildCurrentTutorialBubble(),
                        ),
                        Positioned(
                          top: 541,
                          left: 278,
                          child: GestureDetector(
                            onTap: _nextTutorialStep,
                            child: Container(
                              width: 57,
                              height: 16,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('pics/NB.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _tutorialStep == 5 ? 'Begin' : 'Next',
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (_tutorialStep == 5)
                          Positioned(
                            top: 85,
                            left: 320,
                            child: Image.asset(
                              'pics/bell.png',
                              color: const Color.fromARGB(174, 250, 215, 118),
                              width: 20,
                              height: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentTutorialBubble() {
    switch (_tutorialStep) {
      case 0:
        return _buildTutorialBubble(
          key: const ValueKey('tutorialStep0'),
          top: 673,
          left: 5,
          text: 'View Shop Info',
          triangleOffset: -12,
        );
      case 1:
        return _buildTutorialBubble(
          key: const ValueKey('tutorialStep1'),
          top: 673,
          left: 53,
          text: 'For funding and buying points',
        );
      case 2:
        return _buildTutorialBubble(
          key: const ValueKey('tutorialStep2'),
          top: 633,
          left: 105,
          text: 'Connect with your Fashion Designer',
          width: 150,
        );
      case 3:
        return _buildTutorialBubble(
          key: const ValueKey('tutorialStep3'),
          top: 673,
          left: 203,
          text: 'My added Products',
        );
      case 4:
        return _buildTutorialBubble(
          key: const ValueKey('tutorialStep4'),
          top: 673,
          left: 255,
          text: 'My Profile and settings',
          triangleOffset: 17,
        );
      case 5:
        return _buildTutorialBubble(
          key: const ValueKey('tutorialStep5'),
          top: 95,
          left: 245,
          text: 'Notifications',
          triangleOffset: 34.5,
          isAbove: true,
        );
      default:
        return Container();
    }
  }

  Widget _buildTutorialBubble({
    required Key key,
    required double top,
    required double left,
    required String text,
    double triangleOffset = 0,
    bool isAbove = false,
    double width = 100,
    double height = 50,
  }) {
    return Stack(
      key: key,
      children: [
        Positioned(
          top: isAbove ? top + 30 : top,
          left: left,
          child: Container(
            width: width, // Use width parameter
            height: height, // Use height parameter
            decoration: BoxDecoration(
              color: const Color(0xFF621B2B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Positioned(
          top: isAbove ? top : top + 45,
          left: left + (width / 2) - 10 + triangleOffset, // Use width parameter
          child: CustomPaint(
            size: const Size(20, 15),
            painter: isAbove
                ? TrianglePainterUpright(color: const Color(0xFF621B2B))
                : TrianglePainter(color: const Color(0xFF621B2B)),
          ),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 - 10, 0);
    path.lineTo(size.width / 2 + 10, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class TrianglePainterUpright extends CustomPainter {
  final Color color;
  final double offset;
  TrianglePainterUpright({required this.color, this.offset = 22.0});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(size.width / 2, 0 + offset);
    path.lineTo(size.width / 2 - 10, size.height + offset);
    path.lineTo(size.width / 2 + 10, size.height + offset);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
