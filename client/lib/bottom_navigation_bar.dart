//bottom_navigation_bar.dart
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  String _selectedIcon = 'Shop';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconContainer(
            'Shop',
            'pics/shop.png',
            const Color(0xFFFAD776),
          ),
          _buildIconContainer(
            'Wallet',
            'pics/wallet.png',
            Colors.black,
          ),
          _buildIconContainer(
            'Insight',
            'pics/insight.png',
            Colors.black,
          ),
          _buildIconContainer(
            'Profile',
            'pics/profile.png',
            Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer(
    String label,
    String iconPath,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIcon = label;
        });
      },
      child: Container(
        width: _selectedIcon == label ? 42.37 : null,
        height: 44,
        padding:
            const EdgeInsets.symmetric(vertical: 0), // Reduced vertical padding
        child: Column(
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: _selectedIcon == label ? color : null,
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _selectedIcon == label ? color : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
