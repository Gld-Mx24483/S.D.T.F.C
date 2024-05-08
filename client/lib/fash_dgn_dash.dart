//fash_dgn_dash.dart
import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';

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
  final List<bool> _favoriteStatus = List.filled(6, false);

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

  void _toggleFavorite(int index) {
    setState(() {
      _favoriteStatus[index] = !_favoriteStatus[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                        '$_greeting,',
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
            const SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                width: 324,
                height: 671,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.95,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade400,
                      ),
                      child: Stack(
                        children: [
                          Image.asset(
                            'pics/${index + 1}.png',
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 5,
                            right: 1,
                            child: Container(
                              width: 45,
                              height: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _favoriteStatus[index]
                                    ? const Color.fromARGB(231, 250, 215, 118)
                                    : const Color.fromARGB(220, 255, 255, 255),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 0),
                                  child: IconButton(
                                    onPressed: () => _toggleFavorite(index),
                                    icon: Icon(
                                      Icons.favorite_border,
                                      color: _favoriteStatus[index]
                                          ? Colors.white
                                          : Colors.black,
                                      size: 22,
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 123,
                            left: 67,
                            child: Container(
                              width: 81,
                              height: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: const Color.fromARGB(220, 255, 255, 255),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(6, 2, 2, 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bomber Jackets',
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5,
                                        color: Color(0xFF061023),
                                      ),
                                    ),
                                    Text(
                                      '\$49.99',
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                        color: Color(0xFF061023),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
