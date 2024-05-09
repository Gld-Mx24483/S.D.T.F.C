import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(String) onItemTapped;

  const CustomBottomNavigationBar({super.key, required this.onItemTapped});

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
          ),
          _buildIconContainer(
            'Wallet',
            'pics/wallet.png',
          ),
          _buildIconContainer(
            'Insight',
            'pics/insight.png',
          ),
          _buildIconContainer(
            'Profile',
            'pics/profile.png',
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer(
    String label,
    String iconPath,
  ) {
    final isSelected = _selectedIcon == label;
    final color =
        isSelected ? const Color(0xFFFAD776) : const Color(0xFF000000);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIcon = label;
        });
        widget.onItemTapped(label);
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Column(
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: color,
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
