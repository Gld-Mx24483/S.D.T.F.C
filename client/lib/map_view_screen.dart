// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Future<BitmapDescriptor> getCustomIcon(String assetPath) async {
  final BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
    const ImageConfiguration(),
    assetPath,
  );
  return customIcon;
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
  late BitmapDescriptor _customNavigationIcon;
  late BitmapDescriptor _customStoreIcon;

  List<Map<String, dynamic>> nearbyLocations = [];
  List<String> storeNames = [
    'Gucci Shop',
    'Zara Clothing Store',
    'Nike Store',
    'H&M',
    'Adidas Store',
    'Louis Vuitton',
    'Prada',
    'Chanel',
    'Burberry',
    'Versace',
    'Fendi',
    'Hermès',
    'Dior',
    'Dolce & Gabbana',
    'Saint Laurent'
  ];

  @override
  void initState() {
    super.initState();
    _setCustomMapIcons();
    _generateNearbyLocations();
    _setPolyline();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setCameraToBounds();
    });
  }

  void _setCustomMapIcons() async {
    _customNavigationIcon = await getCustomIcon('pics/navigation.png');
    _customStoreIcon = await getCustomIcon('pics/store.png');
    setState(() {});
  }

  void _generateNearbyLocations() {
    final random = Random();
    final numberOfLocations = random.nextInt(5) + 3; // 3 to 7 locations
    storeNames.shuffle();

    for (var i = 0; i < numberOfLocations; i++) {
      final lat = widget.selectedLocation.latitude +
          random.nextDouble() * 0.01 * (i % 2 == 0 ? 1 : -1);
      final lng = widget.selectedLocation.longitude +
          random.nextDouble() * 0.01 * (i % 2 == 0 ? -1 : 1);
      nearbyLocations.add({
        'name': storeNames[i],
        'position': LatLng(lat, lng),
      });
    }
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
          color: Colors.black,
          points: polylineCoordinates,
          width: 5,
        );
      });
    }
  }

  void _setCameraToBounds() {
    LatLngBounds bounds;
    if (widget.initialPosition.latitude > widget.selectedLocation.latitude &&
        widget.initialPosition.longitude > widget.selectedLocation.longitude) {
      bounds = LatLngBounds(
        southwest: widget.selectedLocation,
        northeast: widget.initialPosition,
      );
    } else {
      bounds = LatLngBounds(
        southwest: widget.initialPosition,
        northeast: widget.selectedLocation,
      );
    }
    _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
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

      final initialLatLng =
          '${widget.initialPosition.latitude},${widget.initialPosition.longitude}';
      final destinationLatLng =
          '${widget.selectedLocation.latitude},${widget.selectedLocation.longitude}';
      final googleMapsUrl =
          'https://www.google.com/maps/dir/?api=1&origin=$initialLatLng&destination=$destinationLatLng&travelmode=driving';

      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
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

  void _focusOnLocation(LatLng location) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 16.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _setCameraToBounds();
            },
            markers: {
              Marker(
                markerId: const MarkerId('initial_location'),
                position: widget.initialPosition,
                icon: _customNavigationIcon,
              ),
              Marker(
                markerId: const MarkerId('selected_location'),
                position: widget.selectedLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
              ...nearbyLocations.map(
                (location) => Marker(
                  markerId: MarkerId(location['name']),
                  position: location['position'],
                  infoWindow: InfoWindow(title: location['name']),
                  icon: _customStoreIcon,
                ),
              ),
            },
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: _toggleDrivingView,
                  child: Icon(
                    _drivingViewEnabled
                        ? Icons.navigation
                        : Icons.directions_car_outlined,
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _focusOnLocation(widget.selectedLocation);
                  },
                  child: const Text('Destination'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _focusOnLocation(widget.initialPosition);
                  },
                  child: const Text('My Location'),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 115,
            right: 10,
            child: ElevatedButton(
              onPressed: _setCameraToBounds,
              child: const Icon(Icons.zoom_out_map),
            ),
          ),
        ],
      ),
    );
  }
}
