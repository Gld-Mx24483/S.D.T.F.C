import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
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
              padding: const EdgeInsets.only(left: 6),
            ),
            _buildNewIconButton(),
            _buildIconContainer(
              'Products',
              'pics/insight.png',
              padding: const EdgeInsets.only(right: 4),
            ),
            _buildIconContainer(
              'Profile',
              'pics/profile.png',
              padding: const EdgeInsets.only(right: 4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer(
    String label,
    String iconPath, {
    EdgeInsets? padding,
  }) {
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
        padding: padding ?? EdgeInsets.zero,
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
              style: GoogleFonts.nunito(
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

  Widget _buildNewIconButton() {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Center(
        child: Transform.translate(
          offset: const Offset(2, -24),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0),
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: CustomBottomNavigationBar(
          onItemTapped: (String label) {
            // Handle item tapped
          },
        ),
      ),
    ),
  ));
}
