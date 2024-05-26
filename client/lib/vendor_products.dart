import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorProductsScreen extends StatefulWidget {
  const VendorProductsScreen({super.key});

  @override
  State<VendorProductsScreen> createState() => _VendorProductsScreenState();
}

class _VendorProductsScreenState extends State<VendorProductsScreen> {
  int? _selectedIndex;
  final List<bool> _favoriteStatus = List.filled(6, false);

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

  void _toggleFavorite(int index) {
    setState(() {
      _favoriteStatus[index] = !_favoriteStatus[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Text(
                    'Products',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF232323),
                    ),
                  ),
                ),
                if (_selectedIndex != null)
                  Positioned(
                    right: 0,
                    child: Text(
                      'Add',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF232323),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'Suggestions',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF621B2B),
              ),
            ),
            SizedBox(
              height: 200,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.95,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex =
                            (_selectedIndex == index) ? null : index;
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade400,
                          ),
                          child: Image.asset(
                            'pics/${index + 1}.png',
                            fit: BoxFit.cover,
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
                          top: 108,
                          left: 67,
                          child: Container(
                            width: 81,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color.fromARGB(220, 255, 255, 255),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 2, 2, 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          color: const Color(0xFF061023),
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
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'My Products',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF621B2B),
              ),
            ),
            const SizedBox(height: 145),
            Center(
              child: Container(
                width: 139,
                height: 39,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Add Product',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
