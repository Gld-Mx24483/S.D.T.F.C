//designer_main_screen.dart
import 'package:flutter/material.dart';
import 'fash_dgn_dash.dart';
import 'bottom_navigation_bar.dart';
import 'fash_dgn_wallet.dart';

class DesignerMainScreen extends StatefulWidget {
  const DesignerMainScreen({super.key});

  @override
  State<DesignerMainScreen> createState() => _DesignerMainScreenState();
}

class _DesignerMainScreenState extends State<DesignerMainScreen> {
  Widget _currentScreen = const DesignerDashboard();

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
