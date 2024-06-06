// ignore_for_file: deprecated_member_use, avoid_print, unused_element, use_full_hex_values_for_flutter_colors
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'fash_search_nav_me.dart';

class FullMap extends StatefulWidget {
  final LatLng initialPosition;

  const FullMap({super.key, required this.initialPosition});

  @override
  State<FullMap> createState() => _FullMapState();
}

class _FullMapState extends State<FullMap> {
  double bottomSheetHeight = 70;
  double maxBottomSheetHeight = 300;

  void toggleBottomSheet(DragUpdateDetails? details) {
    if (details != null && details.delta.dy > 0) {
      setState(() {
        bottomSheetHeight = 70;
      });
    } else {
      setState(() {
        bottomSheetHeight = maxBottomSheetHeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition,
              zoom: 18.0,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('current'),
                position: widget.initialPosition,
              ),
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) => toggleBottomSheet(details),
              onTap: () => toggleBottomSheet(null),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: bottomSheetHeight,
                width: 375,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: bottomSheetHeight == maxBottomSheetHeight
                        ? const Radius.circular(0)
                        : const Radius.circular(20),
                    bottomRight: bottomSheetHeight == maxBottomSheetHeight
                        ? const Radius.circular(0)
                        : const Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height:
                          bottomSheetHeight == maxBottomSheetHeight ? 31 : 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (bottomSheetHeight == maxBottomSheetHeight) {
                            bottomSheetHeight = 70;
                          } else {
                            bottomSheetHeight = maxBottomSheetHeight;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FashSearchNavMe(
                                  initialPosition: widget.initialPosition,
                                ),
                              ),
                            );
                          }
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    if (bottomSheetHeight == maxBottomSheetHeight)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FashSearchNavMe(
                                  initialPosition: widget.initialPosition,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Search Location',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (bottomSheetHeight == maxBottomSheetHeight)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 21,
                              height: 21,
                              decoration: BoxDecoration(
                                color: const Color(0xFFA6A6A6).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                Icons.access_time,
                                color: Color(0xFFA6A6A6),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 23),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gucci Shop',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Ikoyi, Lagos, Nigeria',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFA6A6A6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (bottomSheetHeight == maxBottomSheetHeight)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 21,
                              height: 21,
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xffa6aa6a6).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                Icons.location_on_outlined,
                                color: Color(0xFFA6A6A6),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 23),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Zara Clothing Store',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Lekki Phase 1, Lagos, Nigeria',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFA6A6A6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (bottomSheetHeight == maxBottomSheetHeight)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 21,
                              height: 21,
                              decoration: BoxDecoration(
                                color: const Color(0xFFA6A6A6).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                Icons.location_on_outlined,
                                color: Color(0xFFA6A6A6),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 23),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nike Store',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Victoria Island, Lagos, Nigeria',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFA6A6A6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
