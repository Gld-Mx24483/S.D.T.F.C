import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Import intl package for number formatting

import 'fash_cnt.dart';

class ProductInfoScreen extends StatefulWidget {
  final int selectedIndex;

  const ProductInfoScreen({super.key, required this.selectedIndex});

  @override
  State<ProductInfoScreen> createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreen> {
  int _quantity = 0;
  int _price = 0;
  String _hexColor = '#000000';
  late String _imagePath;
  List<Color> _colors = [];
  double _weight = 0.0;
  double _width = 0.0;
  double _thickness = 0.0;

  final _formatter = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    _generateRandomValues();
    _generateRandomColors();
    _imagePath = 'pics/${widget.selectedIndex + 1}.png';
  }

  void _generateRandomValues() {
    final random = Random();
    setState(() {
      _quantity = random.nextInt(9) + 1;
      _price = random.nextInt(10001);
      _hexColor =
          '#${random.nextInt(0xFFFFFF + 1).toRadixString(16).padLeft(6, '0')}';
      _weight = random.nextDouble() * 10;
      _width = random.nextDouble() * 100;
      _thickness = random.nextDouble() * 10;
    });
  }

  void _generateRandomColors() {
    final random = Random();
    setState(() {
      _colors = List.generate(
        3,
        (index) => Color.fromARGB(
          255,
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
        ),
      );
    });
  }

  void _handleColorChange(int index) {
    setState(() {
      _hexColor = '#${_colors[index].value.toRadixString(16).padLeft(6, '0')}';
    });
  }

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
                        child: Padding(
                          padding: const EdgeInsets.only(right: 1),
                          child: Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(left: 10),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Color.fromARGB(255, 1, 1, 1),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20), // Adjust padding here
                        child: Text(
                          'Market Place',
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF232323),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FashCnt(),
                              ),
                            );
                          },
                          child: Text(
                            'Connect',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF621B2B),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Stack(
                  children: [
                    Container(
                      width: 288,
                      height: 246,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(_imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 1,
                      child: Container(
                        width: 45,
                        height: 35,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(220, 255, 255, 255),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Colors.black,
                                size: 22,
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                label: 'Product Category',
                value: 'Fabrics',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Product Type',
                value: 'Style',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Product Colour',
                value: _hexColor,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < 3; i++)
                      GestureDetector(
                        onTap: () => _handleColorChange(i),
                        child: Container(
                          width: 53,
                          height: 47,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: _colors[i],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Product Status',
                value: 'In Stock',
              ),
              const SizedBox(height: 16),
              _buildMeasurementField(
                label: 'Weight',
                value: _weight,
                unit: 'kg',
              ),
              const SizedBox(height: 16),
              _buildMeasurementField(
                label: 'Width',
                value: _width,
                unit: 'cm',
              ),
              const SizedBox(height: 16),
              _buildMeasurementField(
                label: 'Thickness',
                value: _thickness,
                unit: 'cm',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Quantity',
                value: _quantity.toString(),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Price of the smallest unit',
                value: '₦ ${_formatter.format(_price)}',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Total Price',
                value: '₦ ${_formatter.format(_price * _quantity)}',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Tags',
                value: 'Fabrics Fashion',
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
              letterSpacing: -0.019,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(45, 215, 215, 215),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFD8D7D7),
              ),
            ),
            child: Text(
              value,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementField({
    required String label,
    required double value,
    required String unit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
              letterSpacing: -0.019,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(45, 215, 215, 215),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFD8D7D7),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 135,
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFD8D7D7),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      value.toStringAsFixed(2),
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 135,
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFD8D7D7),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      unit,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
