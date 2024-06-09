// //full_map.dart
// // ignore_for_file: deprecated_member_use, avoid_print, unused_element, use_full_hex_values_for_flutter_colors
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'fash_search_nav_me.dart';

// Future<BitmapDescriptor> getCustomIcon(String assetPath) async {
//   final BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
//     const ImageConfiguration(),
//     assetPath,
//   );
//   return customIcon;
// }

// class FullMap extends StatefulWidget {
//   final LatLng initialPosition;

//   const FullMap({super.key, required this.initialPosition});

//   @override
//   State<FullMap> createState() => _FullMapState();
// }

// class _FullMapState extends State<FullMap> {
//   double bottomSheetHeight = 70;
//   double maxBottomSheetHeight = 300;
//   late BitmapDescriptor _customNavigationIcon;
//   late BitmapDescriptor _customStoreIcon;
//   Map<PolylineId, Polyline> polylines = {};
//   PolylinePoints polylinePoints = PolylinePoints();
//   late GoogleMapController _mapController;

//   List<Map<String, dynamic>> nearbyLocations = [
//     {
//       'name': 'Gucci Shop',
//       'position': null,
//     },
//     {
//       'name': 'Zara Clothing Store',
//       'position': null,
//     },
//     {
//       'name': 'Nike Store',
//       'position': null,
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _setCustomMapIcons();
//     _generateNearbyLocations();
//   }

//   void _setCustomMapIcons() async {
//     _customNavigationIcon = await getCustomIcon('pics/navigation.png');
//     _customStoreIcon = await getCustomIcon('pics/store.png');
//     setState(() {});
//   }

//   void _generateNearbyLocations() {
//     final random = Random();
//     for (var i = 0; i < nearbyLocations.length; i++) {
//       final lat = widget.initialPosition.latitude +
//           random.nextDouble() * 0.01 * (i % 2 == 0 ? 1 : -1);
//       final lng = widget.initialPosition.longitude +
//           random.nextDouble() * 0.01 * (i % 2 == 0 ? -1 : 1);
//       nearbyLocations[i]['position'] = LatLng(lat, lng);
//     }
//   }

//   void _setPolyline(LatLng destination) async {
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       'AIzaSyCTYqVltSQBBAmgOqneKuz_cc1fHEyoMvE',
//       PointLatLng(
//           widget.initialPosition.latitude, widget.initialPosition.longitude),
//       PointLatLng(destination.latitude, destination.longitude),
//     );

//     if (result.points.isNotEmpty) {
//       setState(() {
//         polylines.clear();
//         polylines[const PolylineId('polyline')] = Polyline(
//           polylineId: const PolylineId('polyline'),
//           color: Colors.black,
//           points: result.points
//               .map((e) => LatLng(e.latitude, e.longitude))
//               .toList(),
//           width: 5,
//         );
//       });

//       _animateToPolyline(result.points);
//     }
//   }

//   void _animateToPolyline(List<PointLatLng> points) {
//     if (points.isEmpty) return;

//     double minLat = points[0].latitude;
//     double maxLat = points[0].latitude;
//     double minLng = points[0].longitude;
//     double maxLng = points[0].longitude;

//     for (var point in points) {
//       minLat = min(minLat, point.latitude);
//       maxLat = max(maxLat, point.latitude);
//       minLng = min(minLng, point.longitude);
//       maxLng = max(maxLng, point.longitude);
//     }

//     final bounds = LatLngBounds(
//       southwest: LatLng(minLat, minLng),
//       northeast: LatLng(maxLat, maxLng),
//     );

//     _mapController.animateCamera(
//       CameraUpdate.newLatLngBounds(bounds, 50),
//     );
//   }

//   void toggleBottomSheet(DragUpdateDetails? details) {
//     if (details != null && details.delta.dy > 0) {
//       setState(() {
//         bottomSheetHeight = 70;
//       });
//     } else {
//       setState(() {
//         bottomSheetHeight = maxBottomSheetHeight;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: widget.initialPosition,
//               zoom: 18.0,
//             ),
//             markers: {
//               Marker(
//                 markerId: const MarkerId('current'),
//                 position: widget.initialPosition,
//                 icon: _customNavigationIcon,
//               ),
//               ...nearbyLocations.map(
//                 (location) => Marker(
//                   markerId: MarkerId(location['name']),
//                   position: location['position'],
//                   infoWindow: InfoWindow(title: location['name']),
//                   icon: _customStoreIcon,
//                   onTap: () {
//                     _setPolyline(location['position']);
//                   },
//                 ),
//               ),
//             },
//             polylines: Set<Polyline>.of(polylines.values),
//             onMapCreated: (GoogleMapController controller) {
//               _mapController = controller;
//             },
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: GestureDetector(
//               onVerticalDragUpdate: (details) => toggleBottomSheet(details),
//               onTap: () => toggleBottomSheet(null),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//                 height: bottomSheetHeight,
//                 width: 375,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: const Radius.circular(20),
//                     topRight: const Radius.circular(20),
//                     bottomLeft: bottomSheetHeight == maxBottomSheetHeight
//                         ? const Radius.circular(0)
//                         : const Radius.circular(20),
//                     bottomRight: bottomSheetHeight == maxBottomSheetHeight
//                         ? const Radius.circular(0)
//                         : const Radius.circular(20),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height:
//                           bottomSheetHeight == maxBottomSheetHeight ? 31 : 10,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           if (bottomSheetHeight == maxBottomSheetHeight) {
//                             bottomSheetHeight = 70;
//                             polylines.clear();
//                           } else {
//                             bottomSheetHeight = maxBottomSheetHeight;
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => FashSearchNavMe(
//                                   initialPosition: widget.initialPosition,
//                                 ),
//                               ),
//                             );
//                           }
//                         });
//                       },
//                       child: Container(
//                         width: 60,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFD9D9D9),
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                       ),
//                     ),
//                     if (bottomSheetHeight == maxBottomSheetHeight) ...[
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 20),
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => FashSearchNavMe(
//                                   initialPosition: widget.initialPosition,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 16),
//                             child: const Row(
//                               children: [
//                                 Icon(
//                                   Icons.search,
//                                   color: Colors.grey,
//                                 ),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'Search Market Location',
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       ...nearbyLocations.map(
//                         (location) => Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 10),
//                           child: GestureDetector(
//                             onTap: () {
//                               _setPolyline(location['position']);
//                             },
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(
//                                   width: 21,
//                                   height: 21,
//                                   child: Icon(
//                                     Icons.location_on_outlined,
//                                     color: Color(0xFFA6A6A6),
//                                     size: 16,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 23),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       location['name'],
//                                       style: const TextStyle(
//                                         fontFamily: 'Nunito',
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       '${location['position'].latitude.toStringAsFixed(4)}, ${location['position'].longitude.toStringAsFixed(4)}',
//                                       style: const TextStyle(
//                                         fontFamily: 'Nunito',
//                                         fontSize: 11,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xFFA6A6A6),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
