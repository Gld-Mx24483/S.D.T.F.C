import 'dart:async';

import 'package:flutter/material.dart';

import 'fgt.dart';
import 'fgt_potp.dart';
import 'role.dart';
import 'splash_screen.dart';
import 'splash_screen2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: isFirstLaunch
          ? const Duration(milliseconds: 1000)
          : const Duration(milliseconds: 200000),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 5)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return FadeTransition(
              opacity: _animation,
              child: SplashScreen2(
                onGetStartedPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RoleScreen()),
                  );
                },
              ),
            );
          } else {
            return FadeTransition(
              opacity: _animation,
              child: const SplashScreen(),
            );
          }
        },
      ),
      routes: {
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/forgot-password-otp': (context) => ForgotPasswordOTPScreen(
              emailAddress:
                  ModalRoute.of(context)?.settings.arguments as String,
            ),
      },
    );
  }
}
