// incoming_request.dart
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'api_service.dart';
import 'connect_to_fash_dgn.dart';

class IncomingRequest extends StatefulWidget {
  const IncomingRequest({super.key});

  @override
  State<IncomingRequest> createState() => _IncomingRequestState();
}

class _IncomingRequestState extends State<IncomingRequest> {
  int _selectedIndex = -1;
  late List<bool> _showBottomOptions = [];
  List<Map<String, dynamic>> _incomingRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchIncomingRequests();
  }

  Future<void> _fetchIncomingRequests() async {
    try {
      final requests = await ApiService.fetchReceivedConnections();
      if (requests != null) {
        setState(() {
          _incomingRequests = requests;
          _showBottomOptions = List.generate(requests.length, (_) => false);
          _isLoading = false;
        });
        print('Fetched Incoming Requests:');
        for (var request in _incomingRequests) {
          print('Request: $request');
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching incoming requests: $e');
      setState(() => _isLoading = false);
    }
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
    final request = _incomingRequests[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConnectToFashDgn(
          designerName: request['userName'] ?? 'Unknown Designer',
          userImage: request['userImage'],
        ),
      ),
    );
  }

  Widget _buildIconWithText(IconData icon, String text, bool isDisabled) {
    final color =
        isDisabled ? const Color(0xFFA6A6A6) : const Color(0xFF621B2B);
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _incomingRequests.isEmpty
                      ? Center(
                          child: Text(
                            'No incoming requests',
                            style: GoogleFonts.nunito(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _incomingRequests.length,
                          itemBuilder: (context, index) {
                            final request = _incomingRequests[index];
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () => _selectUser(index),
                                  child: RequestItem(
                                    name: request['userName'] ?? 'Unknown User',
                                    imagePath: request['userImage'],
                                    isSelected: index == _selectedIndex,
                                    onToggleOptions: () =>
                                        _toggleBottomOptions(index),
                                    showBottomOptions:
                                        _showBottomOptions[index],
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: _showBottomOptions[index] ? 60 : 0,
                                  child: AnimatedOpacity(
                                    opacity:
                                        _showBottomOptions[index] ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildIconWithText(
                                            Icons.call_outlined, 'Call', true),
                                        _buildIconWithText(
                                            Icons.chat_outlined, 'Chat', true),
                                        _buildIconWithText(
                                            Icons.cancel_outlined,
                                            'Cancel',
                                            false),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
            ),
            if (_selectedIndex != -1)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () => _navigateToConnectToFashDgn(_selectedIndex),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBE5AA),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
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
  final String? imagePath;
  final bool isSelected;
  final VoidCallback onToggleOptions;
  final bool showBottomOptions;

  const RequestItem({
    super.key,
    required this.name,
    this.imagePath,
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
                image: imagePath != null
                    ? DecorationImage(
                        image: NetworkImage(imagePath!), fit: BoxFit.cover)
                    : null,
              ),
              child: imagePath == null
                  ? Icon(Icons.person, size: 30, color: Colors.grey[600])
                  : null,
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
