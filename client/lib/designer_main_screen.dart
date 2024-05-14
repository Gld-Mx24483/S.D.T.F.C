//designer_main_screen.dart
import 'package:flutter/material.dart';
import 'fash_dgn_dash.dart';
import 'bottom_navigation_bar.dart';
import 'fash_dgn_wallet.dart';
import 'no_record_screen.dart';

class DesignerMainScreen extends StatefulWidget {
  final bool isNewDesigner;

  const DesignerMainScreen({super.key, this.isNewDesigner = false});

  @override
  State<DesignerMainScreen> createState() => _DesignerMainScreenState();
}

class _DesignerMainScreenState extends State<DesignerMainScreen> {
  late Widget _currentScreen;

  @override
  void initState() {
    super.initState();
    _currentScreen = widget.isNewDesigner
        ? const NoRecordScreen()
        : const DesignerDashboard();
  }

  void _onBottomNavigationBarItemTapped(String label) {
    setState(() {
      switch (label) {
        case 'Shop':
          _currentScreen = const DesignerDashboard();
          break;
        case 'Wallet':
          _currentScreen = const WalletScreen();
          break;
        case 'Insight':
          // _currentScreen = const InsightScreen();
          break;
        case 'Profile':
          // _currentScreen = const ProfileScreen();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentScreen,
      bottomNavigationBar: CustomBottomNavigationBar(
        onItemTapped: _onBottomNavigationBarItemTapped,
      ),
    );
  }
}
