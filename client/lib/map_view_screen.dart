//map_view_screen.dart
// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map View',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapViewScreen(
        initialPosition: LatLng(37.7749, -122.4194), // San Francisco
        selectedLocation: LatLng(37.8199, -122.4783), // Golden Gate Bridge
      ),
    );
  }
}

class MapViewScreen extends StatefulWidget {
  final LatLng initialPosition;
  final LatLng selectedLocation;

  const MapViewScreen({
    super.key,
    required this.initialPosition,
    required this.selectedLocation,
  });

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  late GoogleMapController _mapController;
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  bool _drivingViewEnabled = false;

  @override
  void initState() {
    super.initState();
    _setPolyline();
  }

  void _setPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCTYqVltSQBBAmgOqneKuz_cc1fHEyoMvE',
      PointLatLng(
          widget.initialPosition.latitude, widget.initialPosition.longitude),
      PointLatLng(
          widget.selectedLocation.latitude, widget.selectedLocation.longitude),
    );

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = [];
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        polylines.clear();
        polylines[const PolylineId('polyline')] = Polyline(
          polylineId: const PolylineId('polyline'),
          color: Colors.blue,
          points: polylineCoordinates,
          width: 5,
        );
      });
    }
  }

  void _toggleDrivingView() async {
    setState(() {
      _drivingViewEnabled = !_drivingViewEnabled;
    });

    if (_drivingViewEnabled) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: widget.selectedLocation,
            zoom: 25.0,
            tilt: 65.0,
            bearing: 40.0,
          ),
        ),
      );

      // Launch the Google Maps app with navigation mode
      final initialLatLng =
          '${widget.initialPosition.latitude},${widget.initialPosition.longitude}';
      final destinationLatLng =
          '${widget.selectedLocation.latitude},${widget.selectedLocation.longitude}';
      final googleMapsUrl =
          'https://www.google.com/maps/dir/?api=1&origin=$initialLatLng&destination=$destinationLatLng&travelmode=driving';

      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
        // Handle the case when Google Maps is not available
        print('Unable to launch Google Maps');
      }
    } else {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: widget.selectedLocation,
            zoom: 14.0,
            tilt: 0.0,
            bearing: 0.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.selectedLocation,
              zoom: 14.0,
            ),
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: {
              Marker(
                markerId: const MarkerId('initial_location'),
                position: widget.initialPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
              Marker(
                markerId: const MarkerId('selected_location'),
                position: widget.selectedLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              ),
            },
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _toggleDrivingView,
                  child: Icon(
                    _drivingViewEnabled
                        ? Icons.directions_car
                        : Icons.directions_car_outlined,
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: widget.selectedLocation,
                          zoom: 16.0,
                        ),
                      ),
                    );
                  },
                  child: const Text('Focus on Location'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
