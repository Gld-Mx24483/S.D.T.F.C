// vendor_products.dart
// ignore_for_file: unused_field, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_my_product.dart';
import 'add_suggested_product.dart';
import 'my_product_info.dart';

class VendorProductsScreen extends StatefulWidget {
  const VendorProductsScreen({super.key});

  @override
  State<VendorProductsScreen> createState() => _VendorProductsScreenState();
}

class _VendorProductsScreenState extends State<VendorProductsScreen> {
  int? _selectedIndex;
  List<Map<String, dynamic>> myaddProducts = [];
  bool _isFabrics = true;
  bool _isEmbellishments = false;
  bool _isLinings = false;
  bool _isSewingToolsEquipment = false;
  bool _isFusibles = false;
  bool _isSewingAccessories = false;
  bool _isSearchBarEnabled = true;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredProducts = [];
  List<Map<String, dynamic>> _filteredSuggestions = [];

  final List<Color> _colors = [
    const Color(0xFFFF6B6B), // Red
    const Color(0xFFFFD93D), // Yellow
    const Color(0xFF6BCB77), // Green
    const Color(0xFF4D96FF), // Blue
  ];

  final List<String> _colorCodes = [
    '#FF6B6B',
    '#FFD93D',
    '#6BCB77',
    '#4D96FF',
  ];

  final List<Map<String, dynamic>> _suggestions = [
    {'productType': 'Tulle', 'colorCode': '#FF6B6B'},
    {'productType': 'Jacquard', 'colorCode': '#FFD93D'},
    {'productType': 'Angora', 'colorCode': '#6BCB77'},
    {'productType': 'Linen', 'colorCode': '#4D96FF'},
  ];

  @override
  void initState() {
    super.initState();
    _filteredProducts = myaddProducts;
    _filteredSuggestions = _suggestions;
  }

  void _navigateToMyProductInfo(Map<String, dynamic> product, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyProductInfoScreen(
          product: product,
          onDelete: () {
            setState(() {
              myaddProducts.removeAt(index);
              _filteredProducts = myaddProducts;
            });
          },
        ),
      ),
    );
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = myaddProducts;
        _filteredSuggestions = _suggestions;
      } else {
        _filteredProducts = myaddProducts
            .where((product) =>
                product['productType']
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                product['colorCode']
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
        _filteredSuggestions = _suggestions
            .where((product) =>
                product['productType']
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                product['colorCode']
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _handleFilterSelection(String filter) {
    setState(() {
      _isFabrics = false;
      _isEmbellishments = false;
      _isLinings = false;
      _isSewingToolsEquipment = false;
      _isFusibles = false;
      _isSewingAccessories = false;

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
        case 'Sewing Tools/Equipment':
          _isSewingToolsEquipment = true;
          break;
        case 'Fusibles':
          _isFusibles = true;
          break;
        case 'Sewing Accessories':
          _isSewingAccessories = true;
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
        ).then((result) {
          if (result != null) {
            setState(() {
              myaddProducts.add(result as Map<String, dynamic>);
              _filteredProducts = myaddProducts;
            });
          }
        });
      } else if (value == 'suggested_product' && _selectedIndex != null) {
        String selectedProductType =
            _filteredSuggestions[_selectedIndex!]['productType'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddSuggestedProductScreen(
              imagePath: 'pics/${_selectedIndex! + 1}.png',
              productType: selectedProductType,
            ),
          ),
        ).then((result) {
          if (result != null) {
            setState(() {
              myaddProducts.add(result as Map<String, dynamic>);
              _filteredProducts = myaddProducts;
            });
          }
        });
      }
    });
  }

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
                Container(
                  width: 335,
                  height: 35.27,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _searchController,
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
                    onChanged: _filterProducts,
                    textInputAction: TextInputAction.search,
                    onEditingComplete: () {
                      setState(() {
                        _isSearchBarEnabled = false;
                      });
                      FocusScope.of(context).unfocus();
                    },
                  ),
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
                      _buildFilterButton(
                          'Sewing Tools/Equipment', _isSewingToolsEquipment),
                      const SizedBox(width: 17),
                      _buildFilterButton('Fusibles', _isFusibles),
                      const SizedBox(width: 17),
                      _buildFilterButton(
                          'Sewing Accessories', _isSewingAccessories),
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
                  child: _filteredSuggestions.isEmpty
                      ? Center(
                          child: Text(
                            'No Suggestions',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.95,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredSuggestions.length,
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
                const SizedBox(height: 1),
                Transform.translate(
                  offset: const Offset(0, -12),
                  child: _filteredProducts.isEmpty
                      ? Center(
                          child: Text(
                            'No Products',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.95,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            return _buildMyProductItem(
                                _filteredProducts[index], index);
                          },
                        ),
                ),
                const SizedBox(height: 20),
              ],
            ),
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
                      Flexible(
                        child: Text(
                          _filteredSuggestions[index]['productType'],
                          style: GoogleFonts.nunito(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: const Color(0xFF061023),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 9,
                            decoration: BoxDecoration(
                              color: Color(int.parse(
                                  '0xFF${_filteredSuggestions[index]['colorCode'].substring(1)}')),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              _filteredSuggestions[index]['colorCode'],
                              style: GoogleFonts.nunito(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                color: const Color(0xFF061023),
                              ),
                              overflow: TextOverflow.ellipsis,
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

  Widget _buildMyProductItem(Map<String, dynamic> product, int index) {
    return GestureDetector(
      onTap: () => _navigateToMyProductInfo(product, index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade400,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildProductImage(product['imagePath']),
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
                      Flexible(
                        child: Text(
                          product['productType'],
                          style: GoogleFonts.nunito(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: const Color(0xFF061023),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 9,
                            decoration: BoxDecoration(
                              color: Color(int.parse(
                                  '0xFF${product['colorCode'].substring(1)}')),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              product['colorCode'],
                              style: GoogleFonts.nunito(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                color: const Color(0xFF061023),
                              ),
                              overflow: TextOverflow.ellipsis,
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

  // Widget _buildProductImage(String imagePath) {
  //   if (imagePath.startsWith('pics/')) {
  //     return Image.asset(
  //       imagePath,
  //       fit: BoxFit.cover,
  //       width: double.infinity,
  //       height: double.infinity,
  //     );
  //   } else {
  //     return Image.file(
  //       File(imagePath),
  //       fit: BoxFit.cover,
  //       width: double.infinity,
  //       height: double.infinity,
  //       errorBuilder: (context, error, stackTrace) {
  //         print('Error loading image: $error');
  //         return Container(
  //           color: Colors.grey,
  //           child: const Icon(Icons.error),
  //         );
  //       },
  //     );
  //   }
  // }

  Widget _buildProductImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const Center(child: Text('No image available'));
    } else if (File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return Container(
            color: Colors.grey,
            child: const Icon(Icons.error),
          );
        },
      );
    } else if (imagePath.startsWith('pics/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      return Container(
        color: Colors.grey,
        child: const Icon(Icons.error),
      );
    }
  }
}
