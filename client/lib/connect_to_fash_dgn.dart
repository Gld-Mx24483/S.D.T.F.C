// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConnectToFashDgn extends StatefulWidget {
  final LatLng initialPosition;
  final LatLng selectedLocation;
  final String designerName;

  const ConnectToFashDgn({
    super.key,
    required this.initialPosition,
    required this.selectedLocation,
    required this.designerName,
  });

  @override
  State<ConnectToFashDgn> createState() => _ConnectToFashDgnState();
}

class _ConnectToFashDgnState extends State<ConnectToFashDgn> {
  late GoogleMapController _mapController;
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  bool _showBottomOptions = false;
  BitmapDescriptor? _customIcon;

  @override
  void initState() {
    super.initState();
    _setPolyline();
    _loadCustomIcon();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setCameraToBounds();
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _setPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCTYqVltSQBBAmgOqneKuz_cc1fHEyoMvE', // Replace with your API key
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

  void _toggleBottomOptions() {
    setState(() {
      _showBottomOptions = !_showBottomOptions;
    });
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
          'Connected to Designer',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'You are now connected to ${widget.designerName}. You can start chatting or call them to discuss your fashion needs.',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _loadCustomIcon() async {
    _customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'pics/store.png',
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
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
              if (_customIcon != null)
                Marker(
                  markerId: const MarkerId('selected_location'),
                  position: widget.selectedLocation,
                  icon: _customIcon!,
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
          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  return true;
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: _buildBottomSheetContent(),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
