import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFFFF), // Background color
      child: Center(
        child: Image.asset(
          'pics/Logo.png', // Replace with the actual path to your image
        ),
      ),
    );
  }
}
