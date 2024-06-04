//fash_navigation.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:mapbox_gl/mapbox_gl.dart' as mapbox_gl;

class FashNavigation extends StatefulWidget {
  final latlong2.LatLng initialPosition;
  final latlong2.LatLng destination;
  const FashNavigation({
    super.key,
    required this.initialPosition,
    required this.destination,
  });
  @override
  State<FashNavigation> createState() => _FashNavigationState();
}

class _FashNavigationState extends State<FashNavigation> {
  late mapbox_gl.MapboxMapController mapController;
  late latlong2.LatLng currentPosition;

  void _onMapCreated(mapbox_gl.MapboxMapController controller) {
    mapController = controller;
    _drawRoute();
  }

  void _drawRoute() async {
    String accessToken =
        'pk.eyJ1IjoiZ2xkLW14MjQ0ODMiLCJhIjoiY2x3YTNkYjM3MDl4dTJxbThkMzczYTViOCJ9.BbgPbwHYVpsRewARW-UdJQ';
    String apiUrl =
        'https://api.mapbox.com/directions/v5/mapbox/driving/${widget.initialPosition.longitude},${widget.initialPosition.latitude};${widget.destination.longitude},${widget.destination.latitude}?access_token=$accessToken&geometries=geojson';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null && data['routes'] != null) {
        final geometry = data['routes'][0]['geometry'];
        final lineString = geometry['coordinates'];
        final lineLatLngs = (lineString as List)
            .map<latlong2.LatLng>(
                (point) => latlong2.LatLng(point[1], point[0]))
            .toList();

        mapController.addLine(
          mapbox_gl.LineOptions(
            geometry: lineLatLngs
                .map((latLng) =>
                    mapbox_gl.LatLng(latLng.latitude, latLng.longitude))
                .toList(),
            lineColor: "#0000FF",
            lineWidth: 5.0,
            lineOpacity: 1.0,
          ),
        );

        mapController.animateCamera(
          mapbox_gl.CameraUpdate.newLatLngBounds(
            mapbox_gl.LatLngBounds(
              southwest: mapbox_gl.LatLng(
                widget.initialPosition.latitude,
                widget.initialPosition.longitude,
              ),
              northeast: mapbox_gl.LatLng(
                widget.destination.latitude,
                widget.destination.longitude,
              ),
            ),
            left: 50,
            top: 50,
            right: 50,
            bottom: 50,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    currentPosition = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation'),
      ),
      body: mapbox_gl.MapboxMap(
        accessToken:
            'pk.eyJ1IjoiZ2xkLW14MjQ0ODMiLCJhIjoiY2x3YTNkYjM3MDl4dTJxbThkMzczYTViOCJ9.BbgPbwHYVpsRewARW-UdJQ',
        initialCameraPosition: mapbox_gl.CameraPosition(
          target: mapbox_gl.LatLng(
              currentPosition.latitude, currentPosition.longitude),
          zoom: 14.0,
        ),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
      ),
    );
  }
}
