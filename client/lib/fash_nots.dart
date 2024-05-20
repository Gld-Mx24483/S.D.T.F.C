// fash_nots.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bottom_navigation_bar.dart';

class FashNotsScreen extends StatefulWidget {
  const FashNotsScreen({super.key});

  @override
  State<FashNotsScreen> createState() => _FashNotsScreenState();
}

class _FashNotsScreenState extends State<FashNotsScreen> {
  bool _repeatedNotifications = false;
  bool _requestNotifications = false;
  bool _newNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: const BoxDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(left: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color.fromARGB(255, 1, 1, 1),
                          ),
                        ),
                      ),
                      Text(
                        'Notifications',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF232323),
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 33),
              _buildNotificationToggle(
                text: 'Turn on repeated notifications',
                value: _repeatedNotifications,
                onChanged: (value) {
                  setState(() {
                    _repeatedNotifications = value;
                  });
                },
              ),
              _buildNotificationToggle(
                text: 'Turn on request notifications',
                value: _requestNotifications,
                onChanged: (value) {
                  setState(() {
                    _requestNotifications = value;
                  });
                },
              ),
              _buildNotificationToggle(
                text: 'Turn on new notifications',
                value: _newNotifications,
                onChanged: (value) {
                  setState(() {
                    _newNotifications = value;
                  });
                },
              ),
              const SizedBox(height: 300),
              GestureDetector(
                onTap: () {
                  // Save changes logic
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE5AA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF621B2B),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onItemTapped: (label) {
          // Handle bottom navigation bar item taps
        },
        tutorialStep: 0,
        selectedLabel: '',
      ),
    );
  }

  Widget _buildNotificationToggle({
    required String text,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: 326,
      height: 72,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            SizedBox(
              width: 216,
              height: 29,
              child: Text(
                text,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
            const Spacer(),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: const Color(0xFFFBE5AA),
                activeTrackColor: const Color(0xFFFBE5AA),
                inactiveTrackColor: const Color.fromARGB(255, 222, 222, 222),
                inactiveThumbColor: Colors.white,
                thumbColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.white;
                  }
                  return Colors.white;
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
