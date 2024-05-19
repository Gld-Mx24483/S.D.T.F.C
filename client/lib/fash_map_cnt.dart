// fash_map_cnt.dart
// ignore_for_file: avoid_print, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'full_map.dart';

class FashMapCnt extends StatefulWidget {
  const FashMapCnt({super.key});

  @override
  FashMapCntState createState() => FashMapCntState();
}

class FashMapCntState extends State<FashMapCnt> {
  final MapController rightMapController = MapController();
  LocationData? _currentPosition;
  final Location _location = Location();

  int? selectedMap;
  LatLng? selectedLocation;

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
                                ? FlutterMap(
                                    options: MapOptions(
                                      center: LatLng(
                                        _currentPosition!.latitude!,
                                        _currentPosition!.longitude!,
                                      ),
                                      zoom: 16.0,
                                      interactiveFlags:
                                          InteractiveFlag.pinchZoom |
                                              InteractiveFlag.drag |
                                              InteractiveFlag.doubleTapZoom,
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
                                            point: LatLng(
                                              _currentPosition!.latitude!,
                                              _currentPosition!.longitude!,
                                            ),
                                            child: const Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Container(),
                          ),
                        ),
                        if (selectedMap == 0)
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
                        color: selectedMap == 0
                            ? const Color(0xFF621B2B)
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 60),
              GestureDetector(
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
                            child: FlutterMap(
                              options: MapOptions(
                                center: selectedLocation ??
                                    const LatLng(6.5244, 3.3792),
                                zoom: 7.0,
                                interactiveFlags: InteractiveFlag.pinchZoom |
                                    InteractiveFlag.drag |
                                    InteractiveFlag.doubleTapZoom,
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
                        if (selectedMap == 1)
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFBE5AA).withOpacity(0.8),
                            ),
                          ),
                        if (selectedMap == 1)
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
                        color: selectedMap == 1
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
              onTap: selectedLocation != null && selectedMap == 0
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullMap(
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
