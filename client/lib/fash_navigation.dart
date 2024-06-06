import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FashNavigation extends StatelessWidget {
  final LatLng initialPosition;
  final LatLng destination;

  const FashNavigation({
    super.key,
    required this.initialPosition,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('initialPosition'),
            position: initialPosition,
            infoWindow: const InfoWindow(title: 'Current Location'),
          ),
          Marker(
            markerId: const MarkerId('destination'),
            position: destination,
            infoWindow: const InfoWindow(title: 'Destination'),
          ),
        },
      ),
    );
  }
}
