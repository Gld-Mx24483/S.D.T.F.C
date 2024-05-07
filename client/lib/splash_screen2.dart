//splash_screen2.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'log_in.dart'; // Import the log_in.dart file

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key, required this.onGetStartedPressed});

  final VoidCallback onGetStartedPressed;

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late Timer _timer;
  int _currentSlide = 0;
  bool _isAnimating = false;

  final List<String> _slideImages = [
    'pics/slide1.png',
    'pics/slide2.png',
    'pics/slide3.png',
  ];

  final List<String> _headerTexts = [
    'Your Ultimate Fashion Marketplace',
    'Bringing Creativity to E-Commerce',
    'Transforming Ideas into Trends',
  ];

  final String _paragraphText = 'Discover, Connect, Create';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_currentSlide == _slideImages.length - 1) {
        setState(() {
          _isAnimating = true;
        });
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            _currentSlide = 0;
            _isAnimating = false;
            _pageController.jumpToPage(_currentSlide);
            _handlePageChanged(_currentSlide);
          });
        });
      } else {
        setState(() {
          _currentSlide = (_currentSlide + 1) % _slideImages.length;
        });
        _pageController
            .animateToPage(
              _currentSlide,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            )
            .then((_) => _handlePageChanged(_currentSlide));
      }
    });
  }

  void _handlePageChanged(int page) {
    setState(() {
      _currentSlide = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: AnimatedOpacity(
              opacity: _isAnimating ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slideImages.length,
                onPageChanged: _handlePageChanged,
                itemBuilder: (context, index) {
                  return Image.asset(
                    _slideImages[index],
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.4,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width *
                0.6, // Adjust this value as needed
            child: Text(
              _headerTexts[_currentSlide],
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                height: 1.5,
                letterSpacing: -0.019,
                color: Color(0xFF621B2B),
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: MediaQuery.of(context).size.width *
                0.8, // Adjust this value as needed
            child: Text(
              _paragraphText,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.5,
                letterSpacing: -0.019,
                color: Color(0xFF000000),
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slideImages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentSlide == index
                      ? const Color(0xFF621B2B)
                      : const Color(0xFFA6A6A6),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: widget.onGetStartedPressed, // Call the callback function
            child: Container(
              width: 337,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFBE5AA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Get started',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                    color: Color(0xFF621B2B),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: Container(
              width: 337,
              height: 44,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFFBE5AA),
                  width: 1,
                ),
                color: const Color(0xFFFAF6EB),
              ),
              child: const Center(
                child: Text(
                  'Sign in',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    color: Color(0xFF621B2B),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
