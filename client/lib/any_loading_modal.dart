//any_loading_modal.dart
import 'package:flutter/material.dart';

class AnyLoadingModal extends StatelessWidget {
  const AnyLoadingModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 812,
      color: const Color(0xFF000000).withOpacity(0.7),
      child: Center(
        child: Container(
          width: 260,
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            color: Color(0xFFFAF6EB),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFBE5AA)),
              ),
              SizedBox(width: 20),
              Text(
                'Please wait...',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF212121),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
