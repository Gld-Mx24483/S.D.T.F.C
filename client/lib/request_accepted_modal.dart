// request_accepted_modal.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestAcceptedModal extends StatefulWidget {
  final VoidCallback onComplete;
  final VoidCallback onDismissed;

  const RequestAcceptedModal({
    super.key,
    required this.onComplete,
    required this.onDismissed,
  });

  @override
  RequestAcceptedModalState createState() => RequestAcceptedModalState();
}

class RequestAcceptedModalState extends State<RequestAcceptedModal> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
      widget.onComplete();
      widget.onDismissed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 812,
      color: const Color(0xFF000000).withOpacity(0.7),
      child: Center(
        child: Container(
          width: 260,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: const BoxDecoration(
            color: Color(0xFFFAF6EB),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF00AC47),
                size: 70,
              ),
              const SizedBox(height: 16),
              Text(
                'Request Accepted',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
