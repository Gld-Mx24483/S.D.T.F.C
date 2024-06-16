// fash_search_nav_me.dart
// ignore_for_file: avoid_print, unnecessary_to_list_in_spreads, unused_field

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';

import 'connect_to_vendor_screen.dart';
import 'loading_modal.dart';

class FashSearchNavMe extends StatefulWidget {
  final LatLng initialPosition;
  final bool isAddingNewLocation;

  const FashSearchNavMe({
    super.key,
    required this.initialPosition,
    required this.isAddingNewLocation,
  });

  @override
  State<FashSearchNavMe> createState() => _FashSearchNavMeState();
}

class _FashSearchNavMeState extends State<FashSearchNavMe>
    with SingleTickerProviderStateMixin {
  final TextEditingController _startingPointController =
      TextEditingController();
  final TextEditingController _marketLocationController =
      TextEditingController();
  LatLng? _selectedLocation;
  LatLng? _marketLocation;
  List<Map<String, dynamic>> nearbyLocations = [];
  List<Map<String, dynamic>> allShops = [];
  Map<String, dynamic>? selectedNearbyLocation;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final FocusNode _startingPointFocusNode = FocusNode();
  final FocusNode _marketLocationFocusNode = FocusNode();
  bool showAllShops = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _selectedLocation = widget.initialPosition;
    _generateAllShops();
  }

  @override
  void dispose() {
    _startingPointController.dispose();
    _marketLocationController.dispose();
    _animationController.dispose();
    _startingPointFocusNode.dispose();
    _marketLocationFocusNode.dispose();
    super.dispose();
  }

  void _generateAllShops() {
    final storeNames = [
      'Gucci Shop',
      'Zara Clothing Store',
      'Nike Store',
      'H&M',
      'Adidas Store',
      'Louis Vuitton',
      'Prada',
      'Chanel',
      'Burberry',
      'Versace',
      'Fendi',
      'Hermès',
      'Dior',
      'Dolce & Gabbana',
      'Saint Laurent'
    ];

    final random = Random();
    for (var storeName in storeNames) {
      final lat = widget.initialPosition.latitude +
          random.nextDouble() * 0.1 * (random.nextBool() ? 1 : -1);
      final lng = widget.initialPosition.longitude +
          random.nextDouble() * 0.1 * (random.nextBool() ? 1 : -1);
      allShops.add({
        'name': storeName,
        'position': LatLng(lat, lng),
      });
    }
  }

  void _generateNearbyLocations() {
    final random = Random();
    final numberOfLocations = random.nextInt(5) + 3;

    nearbyLocations = List.from(allShops)..shuffle();
    nearbyLocations = nearbyLocations.take(numberOfLocations).toList();

    for (var shop in nearbyLocations) {
      final lat = _marketLocation!.latitude +
          random.nextDouble() * 0.01 * (random.nextBool() ? 1 : -1);
      final lng = _marketLocation!.longitude +
          random.nextDouble() * 0.01 * (random.nextBool() ? 1 : -1);
      shop['position'] = LatLng(lat, lng);
    }
  }

  void _navigateToShopDetails() {
    if (selectedNearbyLocation != null) {
      final initialPosition =
          widget.isAddingNewLocation && _selectedLocation != null
              ? _selectedLocation!
              : widget.initialPosition;

      print('Initial Position: $initialPosition');

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: ConnectingToVendorScreen(
                shopDetails: selectedNearbyLocation!,
                initialPosition: initialPosition,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  void _showLoadingModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingModal(
          showNextModal: () {
            setState(() {
              _animationController.forward();
            });
          },
        );
      },
    );
  }

  void _generateNearbyLocationsWithDelay() {
    Future.delayed(const Duration(seconds: 5), () {
      _generateNearbyLocations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            if (nearbyLocations.isNotEmpty) {
              setState(() {
                nearbyLocations.clear();
                selectedNearbyLocation = null;
                _marketLocation = null;
                showAllShops = false;
              });
              _animationController.reverse();
            } else {
              Navigator.pop(context);
            }
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF000000),
            size: 24,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 40),
          child: Text(
            nearbyLocations.isNotEmpty ? 'Connect to Vendor' : 'Your Shop',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
            ),
          ),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Container(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      if (!widget.isAddingNewLocation)
                        Column(
                          children: [
                            Container(
                              width: 336,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF1F1F1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 7,
                                      child: Icon(
                                        Icons.circle,
                                        color: Colors.blue,
                                        size: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Current Location',
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (widget.isAddingNewLocation)
                        Column(
                          children: [
                            Container(
                              width: 336,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFFBE5AA),
                                  width: 2,
                                ),
                              ),
                              child: GooglePlacesAutoCompleteTextFormField(
                                textEditingController: _startingPointController,
                                googleAPIKey:
                                    'AIzaSyCTYqVltSQBBAmgOqneKuz_cc1fHEyoMvE',
                                decoration: InputDecoration(
                                  hintText: 'Starting point',
                                  hintStyle: GoogleFonts.nunito(
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                ),
                                debounceTime: 500,
                                countries: const ["ng"],
                                isLatLngRequired: true,
                                focusNode: _startingPointFocusNode,
                                getPlaceDetailWithLatLng:
                                    (Prediction prediction) {
                                  setState(() {
                                    _selectedLocation = LatLng(
                                        double.parse(prediction.lat!),
                                        double.parse(prediction.lng!));
                                  });
                                  print(
                                      'Selected Starting Point Coordinates: $_selectedLocation');
                                },
                                itmClick: (Prediction prediction) {
                                  _startingPointController.text =
                                      prediction.description ?? "";
                                  _startingPointController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                      offset:
                                          prediction.description?.length ?? 0,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      Container(
                        width: 336,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFFBE5AA),
                            width: 2,
                          ),
                        ),
                        child: GooglePlacesAutoCompleteTextFormField(
                          textEditingController: _marketLocationController,
                          googleAPIKey:
                              'AIzaSyCTYqVltSQBBAmgOqneKuz_cc1fHEyoMvE',
                          decoration: InputDecoration(
                            hintText: 'Find Market Location',
                            hintStyle: GoogleFonts.nunito(
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                          ),
                          debounceTime: 500,
                          countries: const ["ng"],
                          isLatLngRequired: true,
                          focusNode: _marketLocationFocusNode,
                          getPlaceDetailWithLatLng: (Prediction prediction) {
                            setState(() {
                              _marketLocation = LatLng(
                                  double.parse(prediction.lat!),
                                  double.parse(prediction.lng!));
                              showAllShops = false;
                            });
                            _showLoadingModal();
                            _generateNearbyLocationsWithDelay();
                          },
                          itmClick: (Prediction prediction) {
                            _marketLocationController.text =
                                prediction.description ?? "";
                            _marketLocationController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                offset: prediction.description?.length ?? 0,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizeTransition(
                  sizeFactor: _animation,
                  axis: Axis.vertical,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ...(showAllShops ? allShops : nearbyLocations)
                          .map((location) {
                        final isSelected = selectedNearbyLocation == location;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedNearbyLocation = location;
                            });
                          },
                          child: Container(
                            width: 336,
                            height: 72,
                            margin: const EdgeInsets.only(bottom: 10, left: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFBE5AA)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'pics/bigstore.png',
                                  width: 35.84,
                                  height: 40,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    location['name'],
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 24,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      if (!showAllShops && nearbyLocations.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showAllShops = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFBE5AA),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'See All Shops',
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF621B2B),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (selectedNearbyLocation != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Center(
                child: ElevatedButton(
                  onPressed: _navigateToShopDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBE5AA),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Continue',
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
    );
  }
}
