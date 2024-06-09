// fash_map_cnt.dart
// ignore_for_file: avoid_print, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'fash_search_nav_me.dart';

class FashMapCnt extends StatefulWidget {
  const FashMapCnt({super.key});

  @override
  FashMapCntState createState() => FashMapCntState();
}

class FashMapCntState extends State<FashMapCnt> {
  LocationData? _currentPosition;
  final Location _location = Location();

  int? selectedMap;
  LatLng? selectedLocation;

  bool isMapTapped = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      PermissionStatus permissionStatus = await _location.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await _location.requestPermission();
        if (permissionStatus != PermissionStatus.granted) {
          return;
        }
      }

      _currentPosition = await _location.getLocation();
      setState(() {});
    } catch (e) {
      print(e);
    }
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
                onTapDown: (_) {
                  setState(() {
                    isMapTapped = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isMapTapped = false;
                  });
                },
                onTap: () {
                  setState(() {
                    selectedMap = 0;
                    selectedLocation = _currentPosition != null
                        ? LatLng(
                            _currentPosition!.latitude!,
                            _currentPosition!.longitude!,
                          )
                        : null;
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
                            child: _currentPosition != null
                                ? GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                        _currentPosition!.latitude!,
                                        _currentPosition!.longitude!,
                                      ),
                                      zoom: 16.0,
                                    ),
                                    markers: {
                                      Marker(
                                        markerId: const MarkerId('current'),
                                        position: LatLng(
                                          _currentPosition!.latitude!,
                                          _currentPosition!.longitude!,
                                        ),
                                      ),
                                    },
                                  )
                                : Container(),
                          ),
                        ),
                        if (selectedMap == 0 || isMapTapped)
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedMap == 0 || isMapTapped
                            ? const Color(0xFF621B2B)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Precise Location',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: selectedMap == 0 || isMapTapped
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 60),
              GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    isMapTapped = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isMapTapped = false;
                  });
                },
                onTap: () {
                  setState(() {
                    selectedMap = 1;
                    // Setting default location to Lagos
                    selectedLocation = const LatLng(6.5244, 3.3792);
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
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: selectedLocation ??
                                    const LatLng(6.5244, 3.3792),
                                zoom: 7.0,
                              ),
                            ),
                          ),
                        ),
                        if (selectedMap == 1 || isMapTapped)
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedMap == 1 || isMapTapped
                            ? const Color(0xFF621B2B)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Add Location',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: selectedMap == 1 || isMapTapped
                              ? Colors.white
                              : Colors.black,
                        ),
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
              onTap: selectedLocation != null && selectedMap == 0
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FashSearchNavMe(
                            initialPosition: selectedLocation!,
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
