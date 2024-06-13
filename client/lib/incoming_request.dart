import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'connect_to_fash_dgn.dart';

class IncomingRequest extends StatefulWidget {
  const IncomingRequest({super.key});

  @override
  State<IncomingRequest> createState() => _IncomingRequestState();
}

class _IncomingRequestState extends State<IncomingRequest> {
  int _selectedIndex = 0;
  final List<bool> _showBottomOptions = List.generate(3, (_) => false);
  Position? _currentPosition;
  final List<LatLng> _designerLocations = [
    const LatLng(6.5244, 3.6792), // Designer 1 location (Lagos Island)
    const LatLng(6.4542, 3.3943), // Designer 2 location (Ikeja)
    const LatLng(6.6318, 3.3535), // Designer 3 location (Lekki)
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  void _selectUser(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleBottomOptions(int index) {
    setState(() {
      _showBottomOptions[index] = !_showBottomOptions[index];
    });
  }

  void _navigateToConnectToFashDgn(int index) {
    if (_currentPosition != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConnectToFashDgn(
            initialPosition:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            selectedLocation: _designerLocations[index],
            designerName: 'Designer ${index + 1}',
          ),
        ),
      );
    }
  }

  Widget _buildIconWithText(IconData icon, String text, bool isDisabled) {
    final color =
        isDisabled ? const Color(0xFFA6A6A6) : const Color(0xFF621B2B);
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: color,
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: GoogleFonts.nunito(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: color,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: 375,
              height: 56,
              margin: const EdgeInsets.only(top: 1),
              alignment: Alignment.center,
              child: Text(
                'Incoming Requests',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => _selectUser(index),
                        child: RequestItem(
                          name: 'Designer ${index + 1}',
                          address: '123 Main St, City',
                          imagePath: 'pics/userreq${index + 1}.png',
                          isSelected: index == _selectedIndex,
                          onToggleOptions: () => _toggleBottomOptions(index),
                          showBottomOptions: _showBottomOptions[index],
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: _showBottomOptions[index] ? 60 : 0,
                        child: AnimatedOpacity(
                          opacity: _showBottomOptions[index] ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildIconWithText(
                                Icons.call_outlined,
                                'Call',
                                true, // Disabled
                              ),
                              _buildIconWithText(
                                Icons.chat_outlined,
                                'Chat',
                                true, // Disabled
                              ),
                              _buildIconWithText(
                                Icons.cancel_outlined,
                                'Cancel',
                                false, // Enabled
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  _navigateToConnectToFashDgn(_selectedIndex);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFBE5AA),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Continue',
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
    );
  }
}

class RequestItem extends StatelessWidget {
  final String name;
  final String address;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onToggleOptions;
  final bool showBottomOptions;

  const RequestItem({
    super.key,
    required this.name,
    required this.address,
    required this.imagePath,
    this.isSelected = false,
    required this.onToggleOptions,
    required this.showBottomOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 336,
      height: 72,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFBE5AA) : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 21.5,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 75,
            child: Text(
              name,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF111827),
              ),
            ),
          ),
          Positioned(
            top: 41,
            left: 75,
            child: Text(
              address,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w300,
                color: const Color(0xFFA6A6A6),
                letterSpacing: -0.3,
              ),
            ),
          ),
          Positioned(
            top: 24,
            right: 21.5,
            child: GestureDetector(
              onTap: onToggleOptions,
              child: AnimatedRotation(
                turns: showBottomOptions ? 0.25 : 0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: isSelected
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFFA6A6A6),
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
