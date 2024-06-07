// fash_dgn_dash.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cart.dart';
import 'notification.dart';
import 'product_info.dart';

class DesignerDashboard extends StatefulWidget {
  const DesignerDashboard({super.key});

  @override
  State<DesignerDashboard> createState() => _DesignerDashboardState();
}

class _DesignerDashboardState extends State<DesignerDashboard> {
  String _greeting = '';
  bool _isFabrics = true;
  bool _isEmbellishments = false;
  bool _isLinings = false;
  bool _isTrimmings = false;
  bool _isColourCode = false;
  bool _isPrice = false;
  final List<bool> _favoriteStatus = List.filled(6, false);
  int? _selectedIndex;
  bool _isSearchBarEnabled = true;

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
      _isFabrics = false;
      _isEmbellishments = false;
      _isLinings = false;
      _isTrimmings = false;
      _isColourCode = false;
      _isPrice = false;

      switch (filter) {
        case 'Fabrics':
          _isFabrics = true;
          break;
        case 'Embellishments':
          _isEmbellishments = true;
          break;
        case 'Linings':
          _isLinings = true;
          break;
        case 'Trimmings':
          _isTrimmings = true;
          break;
        case 'Colour Code':
          _isColourCode = true;
          break;
        case 'Price':
          _isPrice = true;
          break;
      }
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      _favoriteStatus[index] = !_favoriteStatus[index];
    });
  }

  final List<Color> _colors = [
    const Color(0xFFFF6B6B), // Red
    const Color(0xFFFFD93D), // Yellow
    const Color(0xFF6BCB77), // Green
    const Color(0xFF4D96FF), // Blue
    const Color(0xFFB197FC), // Purple
    const Color(0xFFFF9B71), // Orange
  ];

  final List<String> _colorCodes = [
    '#FF6B6B',
    '#FFD93D',
    '#6BCB77',
    '#4D96FF',
    '#B197FC',
    '#FF9B71',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            _isSearchBarEnabled = true;
          });
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 2),
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
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              color: const Color.fromARGB(75, 0, 0, 0),
                            ),
                          ),
                        ),
                        Text(
                          'Designer',
                          style: GoogleFonts.nunito(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                            color: const Color(0xFF621B2B),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationScreen(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 85.0),
                            child: Image.asset(
                              'pics/bell.png',
                              color: const Color(0xFF621B2B),
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartScreen(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 85.0),
                            child: Image.asset(
                              'pics/shopping-bag.png',
                              color: const Color(0xFF621B2B),
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: 335,
                    height: 35.27,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      enabled: _isSearchBarEnabled,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFD9D9D9),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFFD9D9D9),
                          size: 25,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      onTap: () {
                        setState(() {
                          _isSearchBarEnabled = true;
                        });
                      },
                      textInputAction: TextInputAction.search,
                      onEditingComplete: () {
                        setState(() {
                          _isSearchBarEnabled = false;
                        });
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _handleFilterSelection('Fabrics'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isFabrics
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
                            'Fabrics',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: _isFabrics ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 17),
                      GestureDetector(
                        onTap: () => _handleFilterSelection('Embellishments'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isEmbellishments
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
                            'Embellishments',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: _isEmbellishments
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 17),
                      GestureDetector(
                        onTap: () => _handleFilterSelection('Linings'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isLinings
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
                            'Linings',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: _isLinings ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 17),
                      GestureDetector(
                        onTap: () => _handleFilterSelection('Trimmings'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isTrimmings
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
                            'Trimmings',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: _isTrimmings ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 17),
                      GestureDetector(
                        onTap: () => _handleFilterSelection('Colour Code'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isColourCode
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
                            'Colour Code',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color:
                                  _isColourCode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 17),
                      GestureDetector(
                        onTap: () => _handleFilterSelection('Price'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isPrice
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
                            'Price',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: _isPrice ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SizedBox(
                    width: 324,
                    height: 671,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.95,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex =
                                  (_selectedIndex == index) ? null : index;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductInfoScreen(selectedIndex: index),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade400,
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'pics/${index + 1}.png',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                if (_selectedIndex == index)
                                  Positioned.fill(
                                    child: Container(
                                      width: 155,
                                      height: 162,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color.fromARGB(130, 255, 221, 129),
                                            Color.fromARGB(130, 255, 221, 129),
                                          ],
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(36, 0, 0, 0),
                                            blurRadius: 4,
                                            offset: Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                          ? const Color.fromARGB(
                                              231, 250, 215, 118)
                                          : const Color.fromARGB(
                                              220, 255, 255, 255),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 0),
                                        child: IconButton(
                                          onPressed: () =>
                                              _toggleFavorite(index),
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
                                  top: 108,
                                  left: 67,
                                  child: Container(
                                    width: 81,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: const Color.fromARGB(
                                          220, 255, 255, 255),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(6, 2, 2, 2),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Bomber Jackets',
                                            style: GoogleFonts.nunito(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              height: 1.5,
                                              color: const Color(0xFF061023),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 9,
                                                decoration: BoxDecoration(
                                                  color: _colors[index],
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                _colorCodes[index],
                                                style: GoogleFonts.nunito(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.5,
                                                  color:
                                                      const Color(0xFF061023),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '\$49.99',
                                            style: GoogleFonts.nunito(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              height: 1.5,
                                              color: const Color(0xFF061023),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
