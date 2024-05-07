// fash_dgn_dash.dart
import 'package:flutter/material.dart';

class DesignerDashboard extends StatefulWidget {
  const DesignerDashboard({super.key});

  @override
  State<DesignerDashboard> createState() => _DesignerDashboardState();
}

class _DesignerDashboardState extends State<DesignerDashboard> {
  String _greeting = '';
  bool _isAllItemsSelected = true;
  bool _isLatestSelected = false;
  bool _isNewSelected = false;

  @override
  void initState() {
    super.initState();
    _determineGreeting();
  }

  void _determineGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      _greeting = 'Good morning';
    } else if (hour < 17) {
      _greeting = 'Good afternoon';
    } else {
      _greeting = 'Good evening';
    }
  }

  void _handleFilterSelection(String filter) {
    setState(() {
      _isAllItemsSelected = false;
      _isLatestSelected = false;
      _isNewSelected = false;

      switch (filter) {
        case 'All Items':
          _isAllItemsSelected = true;
          break;
        case 'Latest':
          _isLatestSelected = true;
          break;
        case 'New':
          _isNewSelected = true;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Text(
                        '$_greeting,', // Add a comma here after the _greeting variable
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: Color.fromARGB(75, 0, 0, 0),
                        ),
                      ),
                    ),
                    const Text(
                      'Designer',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                        color: Color(0xFF621B2B),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 85.0),
                      child: Image.asset(
                        'pics/bell.png',
                        color: const Color(0xFF621B2B),
                        width: 20,
                        height: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 85.0),
                      child: Image.asset(
                        'pics/shopping-bag.png',
                        color: const Color(0xFF621B2B),
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                width: 335,
                height: 35.27,
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Color(0xFFD9D9D9),
                      size: 25,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Search',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFD9D9D9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _handleFilterSelection('All Items'),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    decoration: BoxDecoration(
                      color: _isAllItemsSelected
                          ? const Color.fromARGB(189, 250, 215, 118)
                          : const Color(0xFFD9D9D9),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      'All Items(15400)',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color:
                            _isAllItemsSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 17),
                GestureDetector(
                  onTap: () => _handleFilterSelection('Latest'),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    decoration: BoxDecoration(
                      color: _isLatestSelected
                          ? const Color.fromARGB(189, 250, 215, 118)
                          : const Color(0xFFD9D9D9),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Latest(5000)',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: _isLatestSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 17),
                GestureDetector(
                  onTap: () => _handleFilterSelection('New'),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    decoration: BoxDecoration(
                      color: _isNewSelected
                          ? const Color.fromARGB(189, 250, 215, 118)
                          : const Color(0xFFD9D9D9),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      'New(500)',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: _isNewSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
