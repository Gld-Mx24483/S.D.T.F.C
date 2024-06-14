//vendor_products.dart
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_my_product.dart';

class VendorProductsScreen extends StatefulWidget {
  const VendorProductsScreen({super.key});

  @override
  State<VendorProductsScreen> createState() => _VendorProductsScreenState();
}

class _VendorProductsScreenState extends State<VendorProductsScreen> {
  int? _selectedIndex;
  final List<bool> _favoriteStatus = List.filled(6, false);
  bool _isFabrics = true;
  bool _isEmbellishments = false;
  bool _isLinings = false;
  bool _isTrimmings = false;
  bool _isColourCode = false;
  bool _isPrice = false;

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

  List<String> myProducts = [];

  void _toggleFavorite(int index) {
    setState(() {
      _favoriteStatus[index] = !_favoriteStatus[index];
    });
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

  void _showAddProductMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 100,
        80,
        10,
        0,
      ),
      items: [
        const PopupMenuItem(
          value: 'my_product',
          child: Text('Add My Product'),
        ),
        PopupMenuItem(
          value: 'suggested_product',
          enabled: _selectedIndex != null,
          child: Text(
            'Add Suggested Product',
            style: TextStyle(
              color: _selectedIndex != null ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'my_product') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddMyProductScreen()),
        );
      } else if (value == 'suggested_product') {
        // Handle adding suggested product
        print('Add Suggested Product clicked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
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
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: _showAddProductMenu,
                      child: Text(
                        'Add',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF232323),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton('Fabrics', _isFabrics),
                    const SizedBox(width: 17),
                    _buildFilterButton('Embellishments', _isEmbellishments),
                    const SizedBox(width: 17),
                    _buildFilterButton('Linings', _isLinings),
                    const SizedBox(width: 17),
                    _buildFilterButton('Trimmings', _isTrimmings),
                    const SizedBox(width: 17),
                    _buildFilterButton('Colour Code', _isColourCode),
                    const SizedBox(width: 17),
                    _buildFilterButton('Price', _isPrice),
                  ],
                ),
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
              Transform.translate(
                offset: const Offset(0, -12),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.95,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return _buildProductItem(index);
                  },
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'My Products',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF621B2B),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: myProducts.isEmpty
                    ? Text(
                        'No Products',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: myProducts.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(myProducts[index]),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () => _handleFilterSelection(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(189, 250, 215, 118)
              : const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = (_selectedIndex == index) ? null : index;
        });
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
                  child: IconButton(
                    onPressed: () => _toggleFavorite(index),
                    icon: Icon(
                      Icons.favorite_border,
                      color:
                          _favoriteStatus[index] ? Colors.white : Colors.black,
                      size: 22,
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                width: 81,
                height: 35,
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
                              color: _colors[index % _colors.length],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _colorCodes[index % _colorCodes.length],
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: const Color(0xFF061023),
                            ),
                          ),
                        ],
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
  }
}
