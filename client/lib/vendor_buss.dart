//vendor_buss.dart
// ignore_for_file: avoid_print, use_build_context_synchronously, unused_element, unused_import

import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'any_loading_modal.dart';
import 'api_service.dart';
import 'vendor_bottom_navigation_bar.dart';

class VendorBussScreen extends StatefulWidget {
  const VendorBussScreen({super.key});

  @override
  State<VendorBussScreen> createState() => _VendorBussScreenState();
}

class _VendorBussScreenState extends State<VendorBussScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessStreetController =
      TextEditingController();
  final TextEditingController _businessEmailController =
      TextEditingController();
  final TextEditingController _businessDescriptionController =
      TextEditingController();
  final TextEditingController _businessPhoneNumberController =
      TextEditingController();

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  bool _isLoading = true;
  bool _useCurrentLocation = false;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _fetchBusinessDetails();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.'),
        ),
      );
      return;
    }

    _getCurrentLocation();
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFBE5AA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Save Changes',
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF621B2B),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationStatusIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color:
            _useCurrentLocation ? Colors.green.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _useCurrentLocation ? Icons.location_on : Icons.location_on,
            size: 16,
            color: _useCurrentLocation ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            _useCurrentLocation ? 'Current Location' : 'Inputted Location',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _useCurrentLocation ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchBusinessDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final storeDetails = await ApiService.fetchStoreDetails();
      if (storeDetails != null) {
        setState(() {
          _businessNameController.text = storeDetails['name'] ?? '';
          _businessDescriptionController.text =
              storeDetails['description'] ?? '';
          _businessEmailController.text = storeDetails['email'] ?? '';
          _businessPhoneNumberController.text = storeDetails['phone'] ?? '';

          if (storeDetails['addresses'] != null &&
              storeDetails['addresses'].isNotEmpty) {
            final address = storeDetails['addresses'][0];
            _businessStreetController.text = address['street'] ?? '';
            _cityController.text = address['city'] ?? '';
            _stateController.text = address['state'] ?? '';
            _countryController.text = address['country'] ?? '';
          }
        });
      }
    } catch (e) {
      print('Error fetching business details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load business details')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _useCurrentLocation = true;
        _businessStreetController.text = 'Current Location';
      });
      print('Current Location: $_selectedLocation');
    } catch (e) {
      print('Error getting current location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get current location')),
      );
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, dynamic> updateData = {
      "name": _businessNameController.text,
      "description": _businessDescriptionController.text,
      "address": {
        "street": _businessStreetController.text,
        "city": _cityController.text,
        "state": _stateController.text,
        "country": _countryController.text,
        "latitude": _selectedLocation?.latitude,
        "longitude": _selectedLocation?.longitude,
      },
      "phone": _businessPhoneNumberController.text,
      "email": _businessEmailController.text,
    };

    try {
      final result = await ApiService.updateStore(updateData);
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Business details updated successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update business details')),
        );
      }
    } catch (e) {
      print('Error updating business details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while updating')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Business Details',
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF232323),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    label: 'Business Name',
                    controller: _businessNameController,
                    hintText: 'Enter your business name',
                  ),
                  const SizedBox(height: 16),
                  _buildLocationInput(),
                  const SizedBox(height: 8),
                  _buildLocationStatusIndicator(),
                  const SizedBox(height: 16),
                  _buildAddressPicker(),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Business Email',
                    controller: _businessEmailController,
                    hintText: 'Enter your business email',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Business Description',
                    controller: _businessDescriptionController,
                    hintText: 'Enter your business description',
                  ),
                  const SizedBox(height: 16),
                  _buildPhoneTextField(),
                  const SizedBox(height: 32),
                  _buildSaveButton(),
                ],
              ),
            ),
      bottomNavigationBar: VendorBottomNavigationBar(
        onItemTapped: (label) {
          // Handle bottom navigation bar item taps
        },
        tutorialStep: 0,
        selectedLabel: '',
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
            letterSpacing: -0.019,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            fillColor: const Color.fromARGB(45, 215, 215, 215),
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFFD9D9D9),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFD8D7D7),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFD8D7D7),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF621B2B),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Street',
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
            letterSpacing: -0.019,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(45, 215, 215, 215),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFD8D7D7)),
          ),
          child: Row(
            children: [
              Expanded(
                child: GooglePlaceAutoCompleteTextField(
                  textEditingController: _businessStreetController,
                  googleAPIKey: "AIzaSyCTYqVltSQBBAmgOqneKuz_cc1fHEyoMvE",
                  inputDecoration: const InputDecoration(
                    hintText: 'Enter your street address',
                    hintStyle: TextStyle(color: Color(0xFFD9D9D9)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                  debounceTime: 800,
                  countries: const ["ng"],
                  isLatLngRequired: true,
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    setState(() {
                      _selectedLocation = LatLng(
                        double.parse(prediction.lat ?? "0"),
                        double.parse(prediction.lng ?? "0"),
                      );
                      _useCurrentLocation = false;
                    });
                    print('Selected Location: $_selectedLocation');
                  },
                  itemClick: (Prediction prediction) {
                    _businessStreetController.text =
                        prediction.description ?? "";
                    _businessStreetController.selection =
                        TextSelection.fromPosition(
                      TextPosition(offset: prediction.description?.length ?? 0),
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  _getCurrentLocation();
                },
                child: Text(
                  'Use Current',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF621B2B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address',
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
            letterSpacing: -0.019,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        CountryStateCityPicker(
          country: _countryController,
          state: _stateController,
          city: _cityController,
        ),
      ],
    );
  }

  Widget _buildPhoneTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Phone Number',
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
            letterSpacing: -0.019,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber number) {
            // Handle phone number input changes
          },
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.disabled,
          selectorTextStyle: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
            letterSpacing: -0.019,
            color: Colors.black,
          ),
          initialValue: PhoneNumber(isoCode: 'NG'),
          textFieldController: _businessPhoneNumberController,
          formatInput: false,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          inputDecoration: InputDecoration(
            fillColor: const Color.fromARGB(45, 215, 215, 215),
            filled: true,
            hintText: 'Enter your business phone number',
            hintStyle: const TextStyle(
              color: Color(0xFFD9D9D9),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFD8D7D7),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFD8D7D7),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF621B2B),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
