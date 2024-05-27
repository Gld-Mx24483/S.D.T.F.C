// ignore_for_file: deprecated_member_use
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class FullMap extends StatefulWidget {
  final LatLng initialPosition;

  const FullMap({super.key, required this.initialPosition});

  @override
  State<FullMap> createState() => _FullMapState();
}

class _FullMapState extends State<FullMap> {
  double bottomSheetHeight = 70;
  double maxBottomSheetHeight = 300;
  final TextEditingController _searchController = TextEditingController();
  final bool _isSearchBarEnabled = true;
  List<MapBoxPlacePrediction> _predictions = [];

  void toggleBottomSheet(DragUpdateDetails details) {
    if (details.delta.dy > 0) {
      setState(() {
        bottomSheetHeight = 70;
      });
    } else if (details.delta.dy < 0) {
      setState(() {
        bottomSheetHeight = maxBottomSheetHeight;
      });
    }
  }

  void _searchLocation(String searchText) async {
    if (searchText.isNotEmpty) {
      String apiUrl =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$searchText.json?sk.eyJ1IjoiZ2xkLW14MjQ0ODMiLCJhIjoiY2x3b3AxaDd6MDRocDJ3cDFwZ2Jrcmp6OCJ9.e86ewf7CHgmO4RH4DQsvPQ&country=ng';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predictions = data['features']
            .map<MapBoxPlacePrediction>(
                (prediction) => MapBoxPlacePrediction.fromJson(prediction))
            .toList();

        setState(() {
          _predictions = predictions;
        });
      } else {
        // Handle error
      }
    } else {
      setState(() {
        _predictions = [];
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: widget.initialPosition,
              zoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/gld-mx24483/clwcfad7h00ct01qsh79s39hx/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZ2xkLW14MjQ0ODMiLCJhIjoiY2x3YTNkYjM3MDl4dTJxbThkMzczYTViOCJ9.BbgPbwHYVpsRewARW-UdJQ',
                additionalOptions: const {
                  'accessToken':
                      'pk.eyJ1IjoiZ2xkLW14MjQ0ODMiLCJhIjoiY2x3YTNkYjM3MDl4dTJxbThkMzczYTViOCJ9.BbgPbwHYVpsRewARW-UdJQ',
                  'id': 'mapbox.mapbox-streets-v8',
                },
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: widget.initialPosition,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: toggleBottomSheet,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: bottomSheetHeight,
                width: 375,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: bottomSheetHeight == maxBottomSheetHeight
                        ? const Radius.circular(0)
                        : const Radius.circular(20),
                    bottomRight: bottomSheetHeight == maxBottomSheetHeight
                        ? const Radius.circular(0)
                        : const Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height:
                          bottomSheetHeight == maxBottomSheetHeight ? 31 : 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (bottomSheetHeight == maxBottomSheetHeight) {
                            bottomSheetHeight = 70;
                          } else {
                            bottomSheetHeight = maxBottomSheetHeight;
                          }
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    if (bottomSheetHeight == maxBottomSheetHeight)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _searchLocation,
                          enabled: _isSearchBarEnabled,
                          decoration: InputDecoration(
                            hintText: 'Search Location',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    if (_predictions.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: _predictions.length,
                          itemBuilder: (context, index) {
                            final prediction = _predictions[index];
                            return ListTile(
                              title: Text(prediction.placeName),
                              onTap: () {
                                // Navigate to the selected location
                                // You'll need to handle this part
                              },
                            );
                          },
                        ),
                      ),
                    if (bottomSheetHeight == maxBottomSheetHeight)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 21,
                              height: 21,
                              decoration: BoxDecoration(
                                color: const Color(0xFFA6A6A6).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                Icons.access_time,
                                color: Color(0xFFA6A6A6),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 23),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gucci Shop',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Ikoyi, Lagos, Nigeria',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFA6A6A6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (bottomSheetHeight == maxBottomSheetHeight)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 21,
                              height: 21,
                              decoration: BoxDecoration(
                                color: const Color(0xFFA6A6A6).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                Icons.location_on_outlined,
                                color: Color(0xFFA6A6A6),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 23),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Zara Clothing Store',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Lekki Phase 1, Lagos, Nigeria',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFA6A6A6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (bottomSheetHeight == maxBottomSheetHeight)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 21,
                              height: 21,
                              decoration: BoxDecoration(
                                color: const Color(0xFFA6A6A6).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                Icons.location_on_outlined,
                                color: Color(0xFFA6A6A6),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 23),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nike Store',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Victoria Island, Lagos, Nigeria',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFA6A6A6),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
  }
}

class MapBoxPlacePrediction {
  final String placeName;
  final double latitude;
  final double longitude;
  MapBoxPlacePrediction({
    required this.placeName,
    required this.latitude,
    required this.longitude,
  });
  factory MapBoxPlacePrediction.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'];
    final coordinates = geometry['coordinates'];
    return MapBoxPlacePrediction(
      placeName: json['place_name'],
      latitude: coordinates[1],
      longitude: coordinates[0],
    );
  }
}
