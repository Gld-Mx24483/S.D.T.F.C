// map_view_screen.dart
// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'fash_cnt.dart';
import 'fashven_chat.dart';
import 'ven_proof_dets.dart';

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
  final Map<String, dynamic> shopDetails;

  const MapViewScreen({
    super.key,
    required this.initialPosition,
    required this.selectedLocation,
    required this.shopDetails,
  });

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen>
    with TickerProviderStateMixin {
  late GoogleMapController _mapController;
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  bool _drivingViewEnabled = false;
  late BitmapDescriptor _customNavigationIcon;
  late BitmapDescriptor _customStoreIcon;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setCustomMapIcons();
    _setPolyline();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setCameraToBounds();
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _setCustomMapIcons() async {
    _customNavigationIcon = await getCustomIcon('pics/navigation.png');
    _customStoreIcon = await getCustomIcon('pics/store.png');
    setState(() {});
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

  void _navigateToVendorProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VendorProfileDetails(
          selectedLocationName: widget.shopDetails['name'],
          address: '123 Main St, Anytown, NG',
        ),
      ),
    );
  }

  Widget _buildBottomSheetContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Connected to Vendor',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _navigateToVendorProfile,
          child: Container(
            width: 336,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset(
                  'pics/store.png',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.shopDetails['name'],
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.black),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIconWithText(Icons.call_outlined, 'Call', 0xFF621B2B),
            _buildIconWithText(Icons.chat_outlined, 'Chat', 0xFF621B2B, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FashvenChat(
                    selectedLocationName: widget.shopDetails['name'],
                  ),
                ),
              );
            }),
            _buildIconWithText(Icons.cancel_outlined, 'Cancel', 0xFF621B2B),
          ],
        ),
        const SizedBox(height: 100),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const FashCnt()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBE5AA),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Back to Connect',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF621B2B),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconWithText(IconData icon, String text, int color,
      [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: Color(color),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(color),
              letterSpacing: -0.3,
            ),
          ),
        ],
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
                icon: _customStoreIcon,
                onTap: _navigateToVendorProfile,
              ),
            },
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Positioned(
            top: 50,
            left: 30,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(0, 255, 255, 255),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 18,
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
          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  _animationController.value = notification.extent;
                  return true;
                },
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20 * _animation.value),
                        topRight: Radius.circular(20 * _animation.value),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1 * _animation.value),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, -5 * _animation.value),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: _buildBottomSheetContent(),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
