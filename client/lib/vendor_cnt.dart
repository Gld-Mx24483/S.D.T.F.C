//ven_cnt.dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'incoming_request.dart';

class VenCnt extends StatefulWidget {
  const VenCnt({super.key});

  @override
  VenCntState createState() => VenCntState();
}

class VenCntState extends State<VenCnt> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dotAnimation;
  late Future<void> _delayedFuture;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _dotAnimation = IntTween(begin: 0, end: 5).animate(_controller);

    _delayedFuture = Future.delayed(const Duration(seconds: 5));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _delayedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const IncomingRequest();
        } else {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 1.0,
                    child: Container(
                      width: 281,
                      height: 157,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('pics/Logo.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Transform.translate(
                    offset: const Offset(45, -75),
                    child: Opacity(
                      opacity: 1.0,
                      child: AnimatedBuilder(
                        animation: _dotAnimation,
                        builder: (context, child) {
                          String dots = '.' * _dotAnimation.value;
                          return Text.rich(
                            TextSpan(
                              text: 'Connect',
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF621B2B),
                              ),
                              children: [
                                TextSpan(
                                  text: dots,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF621B2B),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: VenCnt(),
  ));
}
