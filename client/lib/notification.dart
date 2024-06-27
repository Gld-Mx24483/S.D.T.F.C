// // //notification.dart
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // class NotificationScreen extends StatelessWidget {
// //   const NotificationScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         width: 375,
// //         height: 812,
// //         color: Colors.white,
// //         child: Column(
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.only(top: 35),
// //               child: Container(
// //                 width: 375,
// //                 height: 56,
// //                 decoration: const BoxDecoration(),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     InkWell(
// //                       onTap: () {
// //                         Navigator.pop(context);
// //                       },
// //                       child: Container(
// //                         width: 24,
// //                         height: 24,
// //                         margin: const EdgeInsets.only(
// //                           left: 20,
// //                         ),
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 4.0,
// //                         ),
// //                         child: const Icon(
// //                           Icons.arrow_back,
// //                           color: Color.fromARGB(255, 1, 1, 1),
// //                         ),
// //                       ),
// //                     ),
// //                     Text(
// //                       'Notifications',
// //                       style: GoogleFonts.nunito(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.w700,
// //                         color: const Color(0xFF232323),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 44),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 371),
// //             Text(
// //               'No Notifications',
// //               style: GoogleFonts.nunito(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w700,
// //                 color: const Color(0xFFA6A6A6),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// Notification.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'api_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final sentConnections = await ApiService.fetchSentConnections();
    if (sentConnections != null) {
      setState(() {
        notifications = sentConnections;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
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
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return NotificationTile(notification: notification);
                  },
                ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    String statusColor;
    IconData statusIcon;

    switch (notification['status']) {
      case 'pending':
        statusColor = '#FFA500';
        statusIcon = Icons.hourglass_empty;
        break;
      case 'accepted':
        statusColor = '#4CAF50';
        statusIcon = Icons.check_circle;
        break;
      case 'canceled':
        statusColor = '#F44336';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = '#9E9E9E';
        statusIcon = Icons.info;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Color(
              int.parse(statusColor.substring(1, 7), radix: 16) + 0xFF000000),
          child: Icon(statusIcon, color: Colors.white),
        ),
        title: Text(
          'Connection Request',
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Store: ${notification['storeName'] ?? 'Unknown Store'}',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              'Vendor: ${notification['vendorName'] ?? 'Unknown Vendor'}',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              'Status: ${notification['status']}',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Text(
          notification['status'].toUpperCase(),
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(
                int.parse(statusColor.substring(1, 7), radix: 16) + 0xFF000000),
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Connection Details'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Store: ${notification['storeName'] ?? 'Unknown Store'}'),
                  Text(
                      'Vendor: ${notification['vendorName'] ?? 'Unknown Vendor'}'),
                  // Text('User: ${notification['userName'] ?? 'Unknown User'}'),
                  Text('Status: ${notification['status']}'),
                  Text('Date Created: ${notification['dateCreated']}'),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
