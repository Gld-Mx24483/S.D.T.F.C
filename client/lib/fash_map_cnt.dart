// //fash_map_cnt.dart
// import 'package:flutter/material.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

// class FashMapCnt extends StatefulWidget {
//   const FashMapCnt({super.key});

//   @override
//   FashMapCntState createState() => FashMapCntState();
// }

// class FashMapCntState extends State<FashMapCnt> {
//   late MapboxMapController mapController;

//   void _onMapCreated(MapboxMapController controller) {
//     mapController = controller;
//     // Initialize the map with your desired settings
//     controller.animateCamera(
//       CameraUpdate.newLatLngBounds(
//         LatLngBounds(
//           southwest: const LatLng(37.7, -122.5),
//           northeast: const LatLng(37.9, -122.3),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: MapboxMap(
//         accessToken:
//             'pk.eyJ1IjoiZ2xkLW14MjQ0ODMiLCJhIjoiY2x3YTNkYjM3MDl4dTJxbThkMzczYTViOCJ9.BbgPbwHYVpsRewARW-UdJQ',
//         styleString: 'mapbox://styles/gld-mx24483/clwcfad7h00ct01qsh79s39hx',
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: const CameraPosition(
//           target: LatLng(37.8, -122.4),
//           zoom: 11.0,
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FashMapCnt extends StatelessWidget {
  final MapController mapController = MapController();

  FashMapCnt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FashMap'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: const MapOptions(
          center: LatLng(9.0820, 8.6753), //Nigeria
          zoom: 6.0,
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
        ],
      ),
    );
  }
}
