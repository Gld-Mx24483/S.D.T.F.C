// fash_map_cnt.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'full_map.dart'; // Import the FullMap component

class FashMapCnt extends StatefulWidget {
  const FashMapCnt({super.key});

  @override
  FashMapCntState createState() => FashMapCntState();
}

class FashMapCntState extends State<FashMapCnt> {
  final MapController leftMapController = MapController();
  final MapController rightMapController = MapController();
  bool isLeftMapSelected = false;
  bool isRightMapSelected = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Request the user to enable location services
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Request the user to grant location permissions
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Request the user to enable location permissions from the app settings
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      leftMapController.move(
          LatLng(position.latitude, position.longitude), 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 200),
          const Text(
            'Connect',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF621B2B),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  setState(() {
                    isLeftMapSelected = details.globalPosition.dx <
                        (details.globalPosition.dx + 130) / 2;
                    isRightMapSelected = !isLeftMapSelected;
                  });
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: ClipOval(
                            child: FlutterMap(
                              mapController: leftMapController,
                              options: MapOptions(
                                center: _currentPosition == null
                                    ? const LatLng(6.5244,
                                        3.3792) // Default Lagos coordinates
                                    : LatLng(_currentPosition!.latitude,
                                        _currentPosition!.longitude),
                                zoom: 16.0,
                                interactiveFlags: InteractiveFlag.none,
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
                          ),
                        ),
                        if (isLeftMapSelected)
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFBE5AA).withOpacity(0.8),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Precise Location',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isLeftMapSelected
                            ? const Color(0xFF621B2B)
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 60),
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  setState(() {
                    isRightMapSelected = details.globalPosition.dx >
                        (details.globalPosition.dx + 130) / 2;
                    isLeftMapSelected = !isRightMapSelected;
                  });
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: ClipOval(
                            child: FlutterMap(
                              mapController: rightMapController,
                              options: const MapOptions(
                                center:
                                    LatLng(9.0578, 7.4951), // Abuja coordinates
                                zoom: 7.0,
                                interactiveFlags: InteractiveFlag
                                    .none, // Disable map interactions
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
                          ),
                        ),
                        if (isRightMapSelected)
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFBE5AA).withOpacity(0.8),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Add Location',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isRightMapSelected
                            ? const Color(0xFF621B2B)
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: GestureDetector(
              onTap: isLeftMapSelected && _currentPosition != null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullMap(
                            initialPosition: LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                          ),
                        ),
                      );
                    }
                  : null,
              child: Container(
                width: 337,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBE5AA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF621B2B),
                    ),
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
