// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class FashSearchNavMe extends StatefulWidget {
  final LatLng initialPosition;

  const FashSearchNavMe({super.key, required this.initialPosition});

  @override
  State<FashSearchNavMe> createState() => _FashSearchNavMeState();
}

class _FashSearchNavMeState extends State<FashSearchNavMe> {
  final TextEditingController _searchController = TextEditingController();
  List<MapBoxPlacePrediction> _predictions = [];

  void _searchLocation(String searchText) async {
    print('Search Text: $searchText');

    if (searchText.isNotEmpty) {
      String accessToken =
          'pk.eyJ1IjoiZ2xkLW14MjQ0ODMiLCJhIjoiY2x3YTNkYjM3MDl4dTJxbThkMzczYTViOCJ9.BbgPbwHYVpsRewARW-UdJQ';
      String apiUrl =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$searchText.json?access_token=$accessToken&country=ng';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('API Response: ${response.body}');
        final data = json.decode(response.body);
        if (data != null && data['features'] != null) {
          final predictions = data['features']
              .map<MapBoxPlacePrediction>(
                  (prediction) => MapBoxPlacePrediction.fromJson(prediction))
              .toList();

          setState(() {
            _predictions = predictions;
          });
        } else {
          print('API response does not contain expected data');
          setState(() {
            _predictions = [];
          });
        }
      } else {
        print('API Error: ${response.statusCode}');
        setState(() {
          _predictions = [];
        });
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
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            // Navigate back to FullMap
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            color: Color(0xFF000000),
            size: 24,
          ),
        ),
        title: const Text(
          'Your Shop',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF000000),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Current Location',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _searchLocation,
                decoration: const InputDecoration(
                  hintText: 'Search Location',
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 100),
                Expanded(
                  child: _predictions.isNotEmpty
                      ? PredictionsList(predictions: _predictions)
                      : const Center(child: Text('No predictions found')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PredictionsList extends StatelessWidget {
  final List<MapBoxPlacePrediction> predictions;

  const PredictionsList({super.key, required this.predictions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: predictions.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final prediction = predictions[index];
        return GestureDetector(
          onTap: () {
            // Navigate to the selected location
            // You'll need to handle this part
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediction.placeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${prediction.latitude}, ${prediction.longitude}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 218, 14, 14),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
    final placeName = json['place_name'] as String? ?? '';
    // final center = json['center'] as List<double>?;
    final center = (json['center'] as List?)?.cast<double>();

    print('Place Name: $placeName');
    print('Center: $center');

    if (center != null && center.length == 2) {
      return MapBoxPlacePrediction(
        placeName: placeName,
        latitude: center[1],
        longitude: center[0],
      );
    } else {
      return MapBoxPlacePrediction(
        placeName: placeName,
        latitude: 0.0,
        longitude: 0.0,
      );
    }
  }
}

// // ignore_for_file: avoid_print

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';
// import 'package:uuid/uuid.dart';

// class FashSearchNavMe extends StatefulWidget {
//   final LatLng initialPosition;

//   const FashSearchNavMe({super.key, required this.initialPosition});

//   @override
//   State<FashSearchNavMe> createState() => _FashSearchNavMeState();
// }

// class _FashSearchNavMeState extends State<FashSearchNavMe> {
//   final TextEditingController _searchController = TextEditingController();
//   List<MapBoxPlaceSearch> _predictions = [];
//   final String _sessionToken = const Uuid().v4();

//   void _searchLocation(String searchText) async {
//     print('Search Text: $searchText');

//     if (searchText.isNotEmpty) {
//       String accessToken =
//           'pk.eyJ1IjoiZ2xkLW14MjQ0ODMiLCJhIjoiY2x3YTNkYjM3MDl4dTJxbThkMzczYTViOCJ9.BbgPbwHYVpsRewARW-UdJQ';
//       String apiUrl =
//           'https://api.mapbox.com/search/searchbox/v1/suggest?q=$searchText&language=en&session_token=$_sessionToken&access_token=$accessToken';
//       final response = await http.get(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//         print('API Response: ${response.body}');
//         final data = json.decode(response.body);
//         final predictions = data['predictions']
//             .map<MapBoxPlaceSearch>(
//                 (prediction) => MapBoxPlaceSearch.fromJson(prediction))
//             .toList();

//         setState(() {
//           _predictions = predictions;
//         });
//       } else {
//         print('API Error: ${response.statusCode}');
//       }
//     } else {
//       setState(() {
//         _predictions = [];
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             // Navigate back to FullMap
//             Navigator.pop(context);
//           },
//           child: const Icon(
//             Icons.close,
//             color: Color(0xFF000000),
//             size: 24,
//           ),
//         ),
//         title: const Text(
//           'Your Shop',
//           style: TextStyle(
//             fontFamily: 'Nunito',
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF000000),
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.location_on,
//                       color: Colors.grey,
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       'Current Location',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: TextField(
//                 controller: _searchController,
//                 onChanged: _searchLocation,
//                 decoration: const InputDecoration(
//                   hintText: 'Search Location',
//                   border: InputBorder.none,
//                   prefixIcon: Icon(
//                     Icons.search,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Column(
//               children: [
//                 const SizedBox(height: 100),
//                 Expanded(
//                   child: _predictions.isNotEmpty
//                       ? PredictionsList(predictions: _predictions)
//                       : const Center(child: Text('No predictions found')),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PredictionsList extends StatelessWidget {
//   final List<MapBoxPlaceSearch> predictions;

//   const PredictionsList({super.key, required this.predictions});

//   @override
//   Widget build(BuildContext context) {
//     print('Predictions List: $predictions'); // Added print statement

//     return ListView.builder(
//       itemCount: predictions.length,
//       itemBuilder: (context, index) {
//         final prediction = predictions[index];
//         return GestureDetector(
//           onTap: () {
//             // Navigate to the selected location
//             // You'll need to handle this part
//           },
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: Colors.red),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.3),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on,
//                       color: Colors.red,
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Text(
//                         prediction.text,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   prediction.address,
//                   style: const TextStyle(
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class MapBoxPlaceSearch {
//   final String text;
//   final String address;
//   final LatLng coordinates;

//   MapBoxPlaceSearch({
//     required this.text,
//     required this.address,
//     required this.coordinates,
//   });

//   factory MapBoxPlaceSearch.fromJson(Map<String, dynamic> json) {
//     final text = json['text'] as String? ?? '';
//     final address = json['properties']?['address'] as String? ?? '';
//     final coordinates = json['geometry']?['coordinates'] != null
//         ? LatLng(
//             json['geometry']['coordinates'][1],
//             json['geometry']['coordinates'][0],
//           )
//         : const LatLng(0.0, 0.0);

//     return MapBoxPlaceSearch(
//       text: text,
//       address: address,
//       coordinates: coordinates,
//     );
//   }

//   @override
//   String toString() {
//     return 'MapBoxPlaceSearch(text: $text, address: $address, coordinates: $coordinates)';
//   }
// }
