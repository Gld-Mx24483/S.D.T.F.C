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

class _ConnectToFashDgnState extends State<ConnectToFashDgn>
    with TickerProviderStateMixin {
  late GoogleMapController _mapController;
  PolylinePoints polylinePoints = PolylinePoints();
  bool _showBottomOptions = false;
  BitmapDescriptor? _customIcon;
  BitmapDescriptor? _defaultIcon;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadCustomIcon();
    _loadDefaultIcon();
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
    _mapController.dispose();
    _animationController.dispose();
    super.dispose();
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

    if (_showBottomOptions) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
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
          'Connect to Fashion Designer',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('pics/userreq1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Designer 1',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '123 Main St, City',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFFA6A6A6),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '5 Points to connect',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF621B2B),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _toggleBottomOptions,
                child: AnimatedRotation(
                  turns: _showBottomOptions ? 0.25 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFA6A6A6),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _showBottomOptions ? null : 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconWithText(Icons.call_outlined, 'Call', 0xFFA6A6A6, null),
              _buildIconWithText(Icons.chat_outlined, 'Chat', 0xFFA6A6A6, null),
              _buildIconWithText(Icons.cancel_outlined, 'Cancel', 0xFF621B2B),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _showBottomOptions ? 0 : null,
          child: Container(
            width: 300,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 2),
                    image: const DecorationImage(
                      image: AssetImage('pics/3.png'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Product Category : Fabrics',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Product Type : Silk',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Colour Code : 0xFFAD43T2',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Quantity : 5 Yards',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 65),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFBE5AA),
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Accept Request',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF621B2B),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildIconWithText(IconData icon, String text, int color, [param3]) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showBottomOptions ? null : 0,
      child: AnimatedOpacity(
        opacity: _showBottomOptions ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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
      ),
    );
  }

  Future<void> _loadCustomIcon() async {
    _customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'pics/store.png',
    );
  }

  Future<void> _loadDefaultIcon() async {
    _defaultIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
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
                icon: _customIcon ?? BitmapDescriptor.defaultMarker,
              ),
              Marker(
                markerId: const MarkerId('selected_location'),
                position: widget.selectedLocation,
                icon: _defaultIcon ?? BitmapDescriptor.defaultMarker,
              ),
            },
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
