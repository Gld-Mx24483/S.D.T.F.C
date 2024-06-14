// add_suggested_product.dart

// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, non_constant_identifier_names, avoid_types_as_parameter_names, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddSuggestedProductScreen extends StatefulWidget {
  final String imagePath;

  const AddSuggestedProductScreen({super.key, required this.imagePath});

  @override
  _AddSuggestedProductScreenState createState() =>
      _AddSuggestedProductScreenState();
}

class _AddSuggestedProductScreenState extends State<AddSuggestedProductScreen> {
  String _productCategory = '';
  String _productType = '';
  Color _productColor = Colors.black;
  final List<Color> _selectedColors = [];
  String _productStatus = 'In Stock';
  double _weight = 0.0;
  double _width = 0.0;
  String _thickness = 'Light';
  int _quantity = 0;
  double _price = 0.0;
  final _formatter = NumberFormat('#,###');

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _productColor,
              onColorChanged: (Color color) {
                setState(() {
                  _productColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  if (_selectedColors.length < 3) {
                    _selectedColors.add(_productColor);
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _removeColor(int index) {
    setState(() {
      _selectedColors.removeAt(index);
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
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'Add Suggested Product',
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
                            // Implement save functionality
                          },
                          child: Text(
                            'Save',
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
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFFDADADA),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Rest of the fields remain the same as in add_my_product.dart
              _buildDropdownField(
                label: 'Product Category',
                value: _productCategory,
                onChanged: (value) {
                  setState(() {
                    _productCategory = value!;
                  });
                },
                items: ['Category 1', 'Category 2', 'Category 3'],
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Product Type',
                value: _productType,
                onChanged: (value) {
                  setState(() {
                    _productType = value!;
                  });
                },
                items: ['Type 1', 'Type 2', 'Type 3'],
              ),
              const SizedBox(height: 16),
              _buildColorField(
                label: 'Product Colour',
                onTap: _showColorPicker,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < _selectedColors.length; i++)
                      GestureDetector(
                        onTap: () => _removeColor(i),
                        child: Stack(
                          children: [
                            Container(
                              width: 53,
                              height: 47,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: _selectedColors[i],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    size: 18, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_selectedColors.length < 3)
                      GestureDetector(
                        onTap: _showColorPicker,
                        child: Container(
                          width: 53,
                          height: 47,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDADADA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Product Status',
                value: _productStatus,
                onChanged: (value) {
                  setState(() {
                    _productStatus = value!;
                  });
                },
                items: ['In Stock', 'Out of Stock'],
              ),
              const SizedBox(height: 16),
              _buildMeasurementField(
                label: 'Weight',
                value: _weight,
                unit: 'kg',
                onChanged: (value) {
                  setState(() {
                    _weight = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildMeasurementField(
                label: 'Width',
                value: _width,
                unit: 'cm',
                onChanged: (value) {
                  setState(() {
                    _width = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Thickness',
                value: _thickness,
                onChanged: (value) {
                  setState(() {
                    _thickness = value!;
                  });
                },
                items: ['Light', 'Medium', 'Heavy'],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Quantity',
                value: _quantity.toString(),
                onChanged: (value) {
                  setState(() {
                    _quantity = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Price of the smallest unit',
                value: '₦ ${_formatter.format(_price)}',
                onChanged: (value) {
                  setState(() {
                    _price = double.tryParse(
                            value.replaceAll(RegExp(r'[^0-9.]'), '')) ??
                        0;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Total Price',
                value: '₦ ${_formatter.format(_price * _quantity)}',
                enabled: false,
                onChanged: (String) {},
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Tags',
                value: '',
                onChanged: (value) {
                  // Handle tags input
                },
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required Function(String?) onChanged,
    required List<String> items,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(45, 215, 215, 215),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFD8D7D7),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value.isEmpty ? null : value,
                hint: Text('Select ${label}'),
                onChanged: onChanged,
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorField({
    required String label,
    required VoidCallback onTap,
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
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(45, 215, 215, 215),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFD8D7D7),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Color',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
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
    required Function(double) onChanged,
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
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (value) =>
                        onChanged(double.tryParse(value) ?? 0),
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

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
    bool enabled = true,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: enabled
                  ? const Color.fromARGB(45, 215, 215, 215)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFD8D7D7),
              ),
            ),
            child: TextField(
              enabled: enabled,
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: value,
                  selection: TextSelection.collapsed(offset: value.length),
                ),
              ),
              onChanged: onChanged,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: enabled ? Colors.black : Colors.grey,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
