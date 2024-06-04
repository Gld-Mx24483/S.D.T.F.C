// // //fash_search_nav_me.dart
// // // ignore_for_file: avoid_print

// // import 'dart:convert';

// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:latlong2/latlong.dart';

// // class FashSearchNavMe extends StatefulWidget {
// //   final LatLng initialPosition;

// //   const FashSearchNavMe({super.key, required this.initialPosition});

// //   @override
// //   State<FashSearchNavMe> createState() => _FashSearchNavMeState();
// // }

// // class _FashSearchNavMeState extends State<FashSearchNavMe> {
// //   final TextEditingController _searchController = TextEditingController();
// //   List<MapBoxPlacePrediction> _predictions = [];

// //   void _searchLocation(String searchText) async {
// //     print('Search Text: $searchText');

// //     if (searchText.isNotEmpty) {
// //       String accessToken =
// //           'pk.eyJ1IjoiZ2xkLW14MjQ0ODMiLCJhIjoiY2x3YTNkYjM3MDl4dTJxbThkMzczYTViOCJ9.BbgPbwHYVpsRewARW-UdJQ';
// //       String apiUrl =
// //           'https://api.mapbox.com/geocoding/v5/mapbox.places/$searchText.json?access_token=$accessToken&country=ng';
// //       final response = await http.get(Uri.parse(apiUrl));

// //       if (response.statusCode == 200) {
// //         print('API Response: ${response.body}');
// //         final data = json.decode(response.body);
// //         if (data != null && data['features'] != null) {
// //           final predictions = data['features']
// //               .map<MapBoxPlacePrediction>(
// //                   (prediction) => MapBoxPlacePrediction.fromJson(prediction))
// //               .toList();

// //           setState(() {
// //             _predictions = predictions;
// //           });
// //         } else {
// //           print('API response does not contain expected data');
// //           setState(() {
// //             _predictions = [];
// //           });
// //         }
// //       } else {
// //         print('API Error: ${response.statusCode}');
// //         setState(() {
// //           _predictions = [];
// //         });
// //       }
// //     } else {
// //       setState(() {
// //         _predictions = [];
// //       });
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _searchController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         leading: GestureDetector(
// //           onTap: () {
// //             Navigator.pop(context);
// //           },
// //           child: const Icon(
// //             Icons.close,
// //             color: Color(0xFF000000),
// //             size: 24,
// //           ),
// //         ),
// //         title: Padding(
// //           padding: const EdgeInsets.only(left: 70),
// //           child: Text(
// //             'Your Shop',
// //             style: GoogleFonts.nunito(
// //               fontSize: 18,
// //               fontWeight: FontWeight.w700,
// //               color: const Color(0xFF000000),
// //             ),
// //           ),
// //         ),
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //       ),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 20),
// //             child: Column(
// //               children: [
// //                 Container(
// //                   width: 336,
// //                   height: 37,
// //                   decoration: const BoxDecoration(
// //                     color: Color(0xFFF1F1F1),
// //                     borderRadius: BorderRadius.only(
// //                       topLeft: Radius.circular(10),
// //                       topRight: Radius.circular(10),
// //                     ),
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 16),
// //                     child: Row(
// //                       children: [
// //                         const CircleAvatar(
// //                           backgroundColor: Colors.white,
// //                           radius: 7,
// //                           child: Icon(
// //                             Icons.circle,
// //                             color: Colors.blue,
// //                             size: 14,
// //                           ),
// //                         ),
// //                         const SizedBox(width: 8),
// //                         Padding(
// //                           padding: const EdgeInsets.only(left: 10),
// //                           child: Text(
// //                             'Current Location',
// //                             style: GoogleFonts.nunito(
// //                               fontWeight: FontWeight.bold,
// //                               fontSize: 14,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 Container(
// //                   width: 336,
// //                   height: 37,
// //                   decoration: BoxDecoration(
// //                     color: const Color.fromARGB(255, 255, 255, 255),
// //                     borderRadius: const BorderRadius.only(
// //                       bottomLeft: Radius.circular(10),
// //                       bottomRight: Radius.circular(10),
// //                     ),
// //                     border: Border.all(
// //                       color: const Color(0xFFFBE5AA),
// //                       width: 2,
// //                     ),
// //                   ),
// //                   child: TextField(
// //                     controller: _searchController,
// //                     onChanged: _searchLocation,
// //                     decoration: InputDecoration(
// //                       hintText: 'Find Shop',
// //                       hintStyle: GoogleFonts.nunito(
// //                         fontSize: 14,
// //                       ),
// //                       border: InputBorder.none,
// //                       prefixIcon: const Icon(
// //                         Icons.search,
// //                         color: Color.fromARGB(255, 0, 0, 0),
// //                       ),
// //                       suffixIcon: Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Image.asset(
// //                           'pics/map1.png',
// //                           width: 20,
// //                           height: 20,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: Column(
// //               children: [
// //                 const SizedBox(height: 100),
// //                 Expanded(
// //                   child: _predictions.isNotEmpty
// //                       ? PredictionsList(predictions: _predictions)
// //                       : const Center(child: Text('No predictions found')),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class PredictionsList extends StatelessWidget {
// //   final List<MapBoxPlacePrediction> predictions;

// //   const PredictionsList({super.key, required this.predictions});

// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView.builder(
// //       itemCount: predictions.length,
// //       shrinkWrap: true,
// //       itemBuilder: (context, index) {
// //         final prediction = predictions[index];
// //         return GestureDetector(
// //           onTap: () {
// //             // Navigate to the selected location
// //             // You'll need to handle this part
// //           },
// //           child: Container(
// //             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(10),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.grey.withOpacity(0.3),
// //                   spreadRadius: 1,
// //                   blurRadius: 5,
// //                   offset: const Offset(0, 3),
// //                 ),
// //               ],
// //             ),
// //             child: Row(
// //               children: [
// //                 const Icon(
// //                   Icons.location_on,
// //                   color: Colors.red,
// //                 ),
// //                 const SizedBox(width: 16),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         prediction.placeName,
// //                         style: const TextStyle(
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 16,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 4),
// //                       Text(
// //                         '${prediction.latitude}, ${prediction.longitude}',
// //                         style: const TextStyle(
// //                           color: Color.fromARGB(255, 218, 14, 14),
// //                           fontSize: 14,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// // class MapBoxPlacePrediction {
// //   final String placeName;
// //   final double latitude;
// //   final double longitude;
// //   MapBoxPlacePrediction({
// //     required this.placeName,
// //     required this.latitude,
// //     required this.longitude,
// //   });
// //   factory MapBoxPlacePrediction.fromJson(Map<String, dynamic> json) {
// //     final placeName = json['place_name'] as String? ?? '';
// //     final center = (json['center'] as List?)?.cast<double>();

// //     print('Place Name: $placeName');
// //     print('Center: $center');

// //     if (center != null && center.length == 2) {
// //       return MapBoxPlacePrediction(
// //         placeName: placeName,
// //         latitude: center[1],
// //         longitude: center[0],
// //       );
// //     } else {
// //       return MapBoxPlacePrediction(
// //         placeName: placeName,
// //         latitude: 0.0,
// //         longitude: 0.0,
// //       );
// //     }
// //   }
// // }

// //fash_search_nav_me.dart
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';

// import 'fash_navigation.dart';

// class FashSearchNavMe extends StatefulWidget {
//   final LatLng initialPosition;
//   const FashSearchNavMe({super.key, required this.initialPosition});
//   @override
//   State<FashSearchNavMe> createState() => _FashSearchNavMeState();
// }

// class _FashSearchNavMeState extends State<FashSearchNavMe> {
//   final TextEditingController _searchController = TextEditingController();
//   List<MapBoxPlacePrediction> _predictions = [];
//   void _searchLocation(String searchText) async {
//     if (searchText.isNotEmpty) {
//       String accessToken =
//           'pk.eyJ1IjoiZ2xkLW14MjQ0ODMiLCJhIjoiY2x3YTNkYjM3MDl4dTJxbThkMzczYTViOCJ9.BbgPbwHYVpsRewARW-UdJQ';
//       String apiUrl =
//           'https://api.mapbox.com/geocoding/v5/mapbox.places/$searchText.json?access_token=$accessToken&country=ng';
//       final response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data != null && data['features'] != null) {
//           final predictions = data['features']
//               .map<MapBoxPlacePrediction>(
//                   (prediction) => MapBoxPlacePrediction.fromJson(prediction))
//               .toList();

//           setState(() {
//             _predictions = predictions;
//           });
//         } else {
//           setState(() {
//             _predictions = [];
//           });
//         }
//       } else {
//         setState(() {
//           _predictions = [];
//         });
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
//             Navigator.pop(context);
//           },
//           child: const Icon(
//             Icons.close,
//             color: Color(0xFF000000),
//             size: 24,
//           ),
//         ),
//         title: Padding(
//           padding: const EdgeInsets.only(left: 70),
//           child: Text(
//             'Your Shop',
//             style: GoogleFonts.nunito(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               color: const Color(0xFF000000),
//             ),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               children: [
//                 Container(
//                   width: 336,
//                   height: 37,
//                   decoration: const BoxDecoration(
//                     color: Color(0xFFF1F1F1),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       topRight: Radius.circular(10),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Row(
//                       children: [
//                         const CircleAvatar(
//                           backgroundColor: Colors.white,
//                           radius: 7,
//                           child: Icon(
//                             Icons.circle,
//                             color: Colors.blue,
//                             size: 14,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 10),
//                           child: Text(
//                             'Current Location',
//                             style: GoogleFonts.nunito(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: 336,
//                   height: 37,
//                   decoration: BoxDecoration(
//                     color: const Color.fromARGB(255, 255, 255, 255),
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(10),
//                       bottomRight: Radius.circular(10),
//                     ),
//                     border: Border.all(
//                       color: const Color(0xFFFBE5AA),
//                       width: 2,
//                     ),
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     onChanged: _searchLocation,
//                     decoration: InputDecoration(
//                       hintText: 'Find Shop',
//                       hintStyle: GoogleFonts.nunito(
//                         fontSize: 14,
//                       ),
//                       border: InputBorder.none,
//                       prefixIcon: const Icon(
//                         Icons.search,
//                         color: Color.fromARGB(255, 0, 0, 0),
//                       ),
//                       suffixIcon: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Image.asset(
//                           'pics/map1.png',
//                           width: 20,
//                           height: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Column(
//               children: [
//                 const SizedBox(height: 100),
//                 Expanded(
//                   child: _predictions.isNotEmpty
//                       ? PredictionsList(
//                           predictions: _predictions,
//                           initialPosition: widget.initialPosition)
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
//   final List<MapBoxPlacePrediction> predictions;
//   final LatLng initialPosition;
//   const PredictionsList(
//       {super.key, required this.predictions, required this.initialPosition});
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: predictions.length,
//       shrinkWrap: true,
//       itemBuilder: (context, index) {
//         final prediction = predictions[index];
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => FashNavigation(
//                   initialPosition: initialPosition,
//                   destination:
//                       LatLng(prediction.latitude, prediction.longitude),
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.3),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.location_on,
//                   color: Colors.red,
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         prediction.placeName,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         '${prediction.latitude}, ${prediction.longitude}',
//                         style: const TextStyle(
//                           color: Color.fromARGB(255, 218, 14, 14),
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
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

// class MapBoxPlacePrediction {
//   final String placeName;
//   final double latitude;
//   final double longitude;
//   MapBoxPlacePrediction({
//     required this.placeName,
//     required this.latitude,
//     required this.longitude,
//   });
//   factory MapBoxPlacePrediction.fromJson(Map<String, dynamic> json) {
//     final placeName = json['place_name'] as String? ?? '';
//     final center = (json['center'] as List?)?.cast<double>();
//     if (center != null && center.length == 2) {
//       return MapBoxPlacePrediction(
//         placeName: placeName,
//         latitude: center[1],
//         longitude: center[0],
//       );
//     } else {
//       return MapBoxPlacePrediction(
//         placeName: placeName,
//         latitude: 0.0,
//         longitude: 0.0,
//       );
//     }
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as latlong2;

import 'fash_navigation.dart';

class FashSearchNavMe extends StatefulWidget {
  final latlong2.LatLng initialPosition;
  const FashSearchNavMe({super.key, required this.initialPosition});
  @override
  State<FashSearchNavMe> createState() => _FashSearchNavMeState();
}

class _FashSearchNavMeState extends State<FashSearchNavMe> {
  final TextEditingController _searchController = TextEditingController();
  List<MapBoxPlacePrediction> _predictions = [];
  void _searchLocation(String searchText) async {
    if (searchText.isNotEmpty) {
      String accessToken =
          'pk.eyJ1IjoiZ2xkLW14MjQ0ODMiLCJhIjoiY2x3YTNkYjM3MDl4dTJxbThkMzczYTViOCJ9.BbgPbwHYVpsRewARW-UdJQ';
      String apiUrl =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$searchText.json?access_token=$accessToken&country=ng';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['features'] != null) {
          final predictions = (data['features'] as List)
              .map<MapBoxPlacePrediction>(
                  (prediction) => MapBoxPlacePrediction.fromJson(prediction))
              .toList();

          setState(() {
            _predictions = predictions;
          });
        } else {
          setState(() {
            _predictions = [];
          });
        }
      } else {
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
                  child: TextField(
                    controller: _searchController,
                    onChanged: _searchLocation,
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
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'pics/map1.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 100),
                Expanded(
                  child: _predictions.isNotEmpty
                      ? PredictionsList(
                          predictions: _predictions,
                          initialPosition: widget.initialPosition)
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
  final latlong2.LatLng initialPosition;
  const PredictionsList(
      {super.key, required this.predictions, required this.initialPosition});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: predictions.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final prediction = predictions[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FashNavigation(
                  initialPosition: initialPosition,
                  destination: latlong2.LatLng(
                      prediction.latitude, prediction.longitude),
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
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
    final center = (json['center'] as List?)?.cast<double>();
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
