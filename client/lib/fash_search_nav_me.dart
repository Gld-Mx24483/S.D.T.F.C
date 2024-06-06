// fash_search_nav_me.dart
// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';

import 'map_view_screen.dart';

class FashSearchNavMe extends StatefulWidget {
  final LatLng initialPosition;

  const FashSearchNavMe({super.key, required this.initialPosition});

  @override
  State<FashSearchNavMe> createState() => _FashSearchNavMeState();
}

class _FashSearchNavMeState extends State<FashSearchNavMe> {
  final TextEditingController _searchController = TextEditingController();
  LatLng? _selectedLocation;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToMapView() {
    if (_selectedLocation != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapViewScreen(
            selectedLocation: _selectedLocation!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            color: Color(0xFF000000),
            size: 24,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 70),
          child: Text(
            'Your Shop',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  width: 336,
                  height: 37,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                Container(
                  width: 336,
                  height: 37,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    border: Border.all(
                      color: const Color(0xFFFBE5AA),
                      width: 2,
                    ),
                  ),
                  child: GooglePlacesAutoCompleteTextFormField(
                    textEditingController: _searchController,
                    googleAPIKey: 'AIzaSyCTYqVltSQBBAmgOqneKuz_cc1fHEyoMvE',
                    decoration: InputDecoration(
                      hintText: 'Find Shop',
                      hintStyle: GoogleFonts.nunito(
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    debounceTime: 500,
                    countries: const ["ng"],
                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (Prediction prediction) {
                      setState(() {
                        _selectedLocation = LatLng(
                            double.parse(prediction.lat!),
                            double.parse(prediction.lng!));
                      });
                      print("Destination Latitude ${prediction.lat}");
                      print("Destination Longitude ${prediction.lng}");
                      print("Description ${prediction.description}");
                      _navigateToMapView();
                    },
                    itmClick: (Prediction prediction) {
                      _searchController.text = prediction.description ?? "";
                      _searchController.selection = TextSelection.fromPosition(
                        TextPosition(
                          offset: prediction.description?.length ?? 0,
                        ),
                      );
                      print(
                          "Current Position Latitude: ${widget.initialPosition.latitude}, Longitude: ${widget.initialPosition.longitude}");
                      print("Description ${prediction.description}");

                      _navigateToMapView();
                    },
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
