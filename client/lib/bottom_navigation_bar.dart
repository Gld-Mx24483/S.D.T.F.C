//bottom_navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(String) onItemTapped;
  final int tutorialStep;
  final String selectedLabel;

  const CustomBottomNavigationBar({
    super.key,
    required this.onItemTapped,
    required this.tutorialStep,
    required this.selectedLabel,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
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
          left: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIconContainer(
              'Market Place',
              'pics/shop.png',
            ),
            _buildIconContainer(
              'Wallet',
              'pics/wallet.png',
              padding: const EdgeInsets.only(right: 5),
            ),
            _buildNewIconButton(),
            _buildIconContainer(
              'Shop',
              'pics/insight.png',
              padding: const EdgeInsets.only(right: 21),
            ),
            _buildIconContainer(
              'Profile',
              'pics/profile.png',
              padding: const EdgeInsets.only(right: 10),
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
    final isSelectedLabel = label == widget.selectedLabel;
    final isDescribed =
        widget.tutorialStep == _getDescriptionStepForLabel(label);
    Color color;

    if (widget.selectedLabel.isEmpty) {
      color = isDescribed ? const Color(0xFFFAD776) : const Color(0xFF000000);
    } else {
      color =
          isSelectedLabel ? const Color(0xFFFAD776) : const Color(0xFF000000);
    }

    return GestureDetector(
      onTap: () {
        setState(() {});
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

  int _getDescriptionStepForLabel(String label) {
    switch (label) {
      case 'Market Place':
        return 0;
      case 'Wallet':
        return 1;
      case 'Shop':
        return 3;
      case 'Profile':
        return 4;
      default:
        return -1;
    }
  }

  Widget _buildNewIconButton() {
    final isDescribed = widget.tutorialStep == 2;
    final color = isDescribed ? const Color(0xFFFAD776) : Colors.black;

    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Center(
        child: Transform.translate(
          offset: const Offset(-6, -24),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.transparent,
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
