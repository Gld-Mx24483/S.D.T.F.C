// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'api_service.dart';
import 'connect_to_fash_dgn.dart';

class VendorNotificationScreen extends StatefulWidget {
  const VendorNotificationScreen({super.key});

  @override
  VendorNotificationScreenState createState() =>
      VendorNotificationScreenState();
}

class VendorNotificationScreenState extends State<VendorNotificationScreen> {
  List<Map<String, dynamic>> _acceptedRequests = [];
  bool _isLoading = true;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _fetchAcceptedRequests();
  }

  Future<void> _fetchAcceptedRequests() async {
    try {
      final requests = await ApiService.fetchReceivedConnections();
      if (requests != null) {
        setState(() {
          _acceptedRequests = requests
              .where((request) => request['status'] == 'ACCEPTED')
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching accepted requests: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 375,
        height: 812,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Container(
                width: 375,
                height: 56,
                decoration: const BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(left: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color.fromARGB(255, 1, 1, 1),
                        ),
                      ),
                    ),
                    Text(
                      'Notifications',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF232323),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _acceptedRequests.isEmpty
                      ? Center(
                          child: Text(
                            'No Notifications',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFA6A6A6),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _acceptedRequests.length,
                          itemBuilder: (context, index) {
                            final request = _acceptedRequests[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: request['userImage'] != null
                                      ? NetworkImage(request['userImage'])
                                      : null,
                                  child: request['userImage'] == null
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                                title: Text(
                                  request['userName'] ?? 'Unknown User',
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  'Connected',
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                                selected: _selectedIndex == index,
                                selectedTileColor:
                                    const Color(0xFFFBE5AA).withOpacity(0.3),
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                              ),
                            );
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _selectedIndex != null
                    ? () {
                        final selectedRequest =
                            _acceptedRequests[_selectedIndex!];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConnectToFashDgn(
                              designerName:
                                  selectedRequest['userName'] ?? 'Unknown User',
                              userImage: selectedRequest['userImage'],
                              connectionDetails: selectedRequest,
                              isAlreadyConnected: true,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF621B2B),
                  backgroundColor: const Color(0xFFFBE5AA),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
