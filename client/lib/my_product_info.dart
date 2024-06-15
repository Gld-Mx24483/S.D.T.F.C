// my_product_info.dart

// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MyProductInfoScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function onDelete;

  const MyProductInfoScreen({
    super.key,
    required this.product,
    required this.onDelete,
  });

  @override
  _MyProductInfoScreenState createState() => _MyProductInfoScreenState();
}

class _MyProductInfoScreenState extends State<MyProductInfoScreen> {
  final formatter = NumberFormat('#,###');
  String currentColorCode = '';
  List<Color> _colors = [];

  @override
  void initState() {
    super.initState();
    currentColorCode = widget.product['colorCode'] ?? 'N/A';
    _colors = (widget.product['selectedColors'] as List<String>?)
            ?.map((colorString) =>
                Color(int.parse('0xFF${colorString.substring(1)}')))
            .toList() ??
        [];
    while (_colors.length < 3) {
      _colors.add(Colors.transparent);
    }
  }

  void _handleColorChange(int index) {
    if (index < _colors.length && _colors[index] != Colors.transparent) {
      setState(() {
        currentColorCode =
            '#${_colors[index].value.toRadixString(16).substring(2)}';
      });
    }
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
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'My Product',
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF232323),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Placeholder for symmetry
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 288,
                height: 246,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: widget.product['imagePath'] != null
                      ? DecorationImage(
                          image: FileImage(File(widget.product['imagePath'])),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: widget.product['imagePath'] == null
                    ? const Center(child: Text('No image available'))
                    : null,
              ),
              const SizedBox(height: 24),
              _buildInfoField('Product Category',
                  widget.product['productCategory'] ?? 'N/A'),
              _buildInfoField(
                  'Product Type', widget.product['productType'] ?? 'N/A'),
              _buildColorField('Product Colour', currentColorCode),
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
              _buildInfoField(
                  'Product Status', widget.product['productStatus'] ?? 'N/A'),
              _buildInfoField(
                  'Weight',
                  widget.product['weight'] != null
                      ? '${widget.product['weight']} kg'
                      : 'N/A'),
              _buildInfoField(
                  'Width',
                  widget.product['width'] != null
                      ? '${widget.product['width']} cm'
                      : 'N/A'),
              _buildInfoField(
                  'Thickness', widget.product['thickness'] ?? 'N/A'),
              _buildInfoField(
                  'Quantity', widget.product['quantity']?.toString() ?? 'N/A'),
              _buildInfoField(
                  'Price of the smallest unit',
                  widget.product['price'] != null
                      ? '₦ ${formatter.format(widget.product['price'])}'
                      : 'N/A'),
              _buildInfoField(
                  'Total Price',
                  (widget.product['price'] != null &&
                          widget.product['quantity'] != null)
                      ? '₦ ${formatter.format(widget.product['price'] * widget.product['quantity'])}'
                      : 'N/A'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Product'),
                        content: const Text(
                            'Are you sure you want to delete this product?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              widget.onDelete();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Delete Product',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
          const SizedBox(height: 4),
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
              value?.toString() ?? 'N/A',
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

  // Widget _buildInfoField(String label, dynamic value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           label,
  //           style: GoogleFonts.nunito(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w500,
  //             height: 1.5,
  //             letterSpacing: -0.019,
  //             color: Colors.black,
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Container(
  //           width: double.infinity,
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //           decoration: BoxDecoration(
  //             color: const Color.fromARGB(45, 215, 215, 215),
  //             borderRadius: BorderRadius.circular(8),
  //             border: Border.all(
  //               color: const Color(0xFFD8D7D7),
  //             ),
  //           ),
  //           child: Text(
  //             value?.toString() ?? 'N/A',
  //             style: GoogleFonts.nunito(
  //               fontSize: 16,
  //               fontWeight: FontWeight.w400,
  //               color: Colors.grey,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildColorField(String label, String colorCode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
          const SizedBox(height: 4),
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
              colorCode,
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
}
