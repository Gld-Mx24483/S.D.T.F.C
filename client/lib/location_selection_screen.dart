// location_selection_screen.dart
// ignore_for_file: use_build_context_synchronously, avoid_print, unused_field

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';

import 'any_loading_modal.dart'; // Import the AnyLoadingModal
import 'map_view_screen.dart';

class LocationSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> shopDetails;

  const LocationSelectionScreen({super.key, required this.shopDetails});

  @override
  LocationSelectionScreenState createState() => LocationSelectionScreenState();
}

class LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final TextEditingController _locationController = TextEditingController();
  LatLng? _selectedLocation;
  bool _isUsingCurrentLocation = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _isUsingCurrentLocation = true;
      });
    } catch (e) {
      print("Error getting current location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to get current location')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToMapView() {
    if (_selectedLocation != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapViewScreen(
            initialPosition: _selectedLocation!,
            selectedLocation: LatLng(
              widget.shopDetails['selectedAddress']['latitude'],
              widget.shopDetails['selectedAddress']['longitude'],
            ),
            shopDetails: widget.shopDetails,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Location', style: GoogleFonts.nunito()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _getCurrentLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBE5AA),
                  ),
                  child: Text(
                    'Use Current Location',
                    style: GoogleFonts.nunito(color: const Color(0xFF621B2B)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'OR',
                  style: GoogleFonts.nunito(color: const Color(0xFF621B2B)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GooglePlacesAutoCompleteTextFormField(
                    textEditingController: _locationController,
                    googleAPIKey: 'AIzaSyCTYqVltSQBBAmgOqneKuz_cc1fHEyoMvE',
                    decoration: const InputDecoration(
                      hintText: 'Enter location',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    debounceTime: 400,
                    countries: const ["ng"],
                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (Prediction prediction) {
                      setState(() {
                        _selectedLocation = LatLng(
                          double.parse(prediction.lat!),
                          double.parse(prediction.lng!),
                        );
                        _isUsingCurrentLocation = false;
                      });
                    },
                    itmClick: (Prediction prediction) {
                      _locationController.text = prediction.description!;
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ElevatedButton(
              onPressed: _navigateToMapView,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFBE5AA),
              ),
              child: Text(
                'Continue',
                style: GoogleFonts.nunito(color: const Color(0xFF621B2B)),
              ),
            ),
          ),
          if (_isLoading) const AnyLoadingModal(),
        ],
      ),
    );
  }
}
