// //notification.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';

// import 'api_service.dart';
// import 'connect_to_vendor_screen.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   NotificationScreenState createState() => NotificationScreenState();
// }

// class NotificationScreenState extends State<NotificationScreen> {
//   List<Map<String, dynamic>> notifications = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchNotifications();
//   }

//   Future<void> fetchNotifications() async {
//     final sentConnections = await ApiService.fetchSentConnections();
//     if (sentConnections != null) {
//       setState(() {
//         notifications = sentConnections;
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> deleteNotification(String connectId, int index) async {
//     bool deleted = await ApiService.deleteConnectRequest(connectId);
//     if (deleted) {
//       setState(() {
//         notifications.removeAt(index);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Notifications',
//           style: GoogleFonts.poppins(
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : notifications.isEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.notifications_off,
//                           size: 80, color: Colors.grey[400]),
//                       const SizedBox(height: 16),
//                       Text(
//                         'No Notifications',
//                         style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: notifications.length,
//                   itemBuilder: (context, index) {
//                     final notification = notifications[index];
//                     return NotificationTile(
//                       notification: notification,
//                       onDelete: () =>
//                           deleteNotification(notification['id'], index),
//                     );
//                   },
//                 ),
//     );
//   }
// }

// class NotificationTile extends StatelessWidget {
//   final Map<String, dynamic> notification;
//   final VoidCallback onDelete;

//   const NotificationTile({
//     super.key,
//     required this.notification,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Color statusColor;
//     IconData statusIcon;

//     switch (notification['status']) {
//       case 'pending':
//         statusColor = Colors.orange;
//         statusIcon = Icons.hourglass_empty;
//         break;
//       case 'accepted':
//         statusColor = Colors.green;
//         statusIcon = Icons.check_circle;
//         break;
//       case 'canceled':
//         statusColor = Colors.red;
//         statusIcon = Icons.cancel;
//         break;
//       default:
//         statusColor = Colors.grey;
//         statusIcon = Icons.info;
//     }

//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//         onTap: () {
//           showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             builder: (context) => ConnectionDetailsBottomSheet(
//               notification: notification,
//               onDelete: onDelete,
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CircleAvatar(
//                 backgroundColor: statusColor.withOpacity(0.1),
//                 child: Icon(statusIcon, color: statusColor),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Connection Request',
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Store: ${notification['storeName'] ?? 'Unknown Store'}',
//                       style: GoogleFonts.poppins(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     Text(
//                       'Vendor: ${notification['vendorName'] ?? 'Unknown Vendor'}',
//                       style: GoogleFonts.poppins(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           DateFormat('MMM d, yyyy').format(
//                               DateTime.parse(notification['dateCreated'])),
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             color: Colors.grey[400],
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: statusColor.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             notification['status'].toUpperCase(),
//                             style: GoogleFonts.poppins(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: statusColor,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ConnectionDetailsBottomSheet extends StatelessWidget {
//   final Map<String, dynamic> notification;
//   final VoidCallback onDelete;

//   const ConnectionDetailsBottomSheet({
//     super.key,
//     required this.notification,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       clipBehavior: Clip.none,
//       alignment: Alignment.topCenter,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 0),
//           child: Container(
//             padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Connection Details',
//                   style: GoogleFonts.poppins(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 DetailRow(
//                   title: 'Store',
//                   value: notification['storeName'] ?? 'Unknown Store',
//                 ),
//                 DetailRow(
//                   title: 'Vendor',
//                   value: notification['vendorName'] ?? 'Unknown Vendor',
//                 ),
//                 DetailRow(title: 'Status', value: notification['status']),
//                 DetailRow(
//                   title: 'Date Created',
//                   value: DateFormat('MMM d, yyyy')
//                       .format(DateTime.parse(notification['dateCreated'])),
//                 ),
//                 const SizedBox(height: 32),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ConnectingToVendorScreen(
//                                 storeDetails: {
//                                   'id': notification['vendorId'],
//                                   'name': notification['storeName'],
//                                   'logo': notification['storeLogo'] ??
//                                       'pics/bigstore.png',
//                                   'selectedAddress': notification['address'],
//                                 },
//                                 initialPosition: LatLng(
//                                   notification['address']['latitude'] ?? 0.0,
//                                   notification['address']['longitude'] ?? 0.0,
//                                 ),
//                                 status: notification['status'],
//                               ),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFFBE5AA),
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                         ),
//                         child: Text(
//                           'Connect',
//                           style: GoogleFonts.poppins(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xFF621B2B),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     ElevatedButton(
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: Text('Confirm Cancellation',
//                                   style: GoogleFonts.poppins(
//                                       fontWeight: FontWeight.w600)),
//                               content: Text(
//                                   'Are you sure you want to cancel this request?',
//                                   style: GoogleFonts.poppins()),
//                               actions: [
//                                 TextButton(
//                                   child:
//                                       Text('No', style: GoogleFonts.poppins()),
//                                   onPressed: () => Navigator.of(context).pop(),
//                                 ),
//                                 TextButton(
//                                   child: Text('Yes',
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.red)),
//                                   onPressed: () {
//                                     onDelete();
//                                     Navigator.of(context).pop();
//                                     Navigator.of(context).pop();
//                                   },
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 16, horizontal: 24),
//                       ),
//                       child: Text(
//                         'Cancel Request',
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//           top: -20,
//           child: Transform.translate(
//             offset: const Offset(0, -60),
//             child: GestureDetector(
//               onTap: () => Navigator.of(context).pop(),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(150, 244, 67, 54),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       spreadRadius: 1,
//                       blurRadius: 3,
//                       offset: const Offset(0, 1),
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.all(8),
//                 child: const Icon(
//                   Icons.close,
//                   color: Colors.white,
//                   size: 40,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class DetailRow extends StatelessWidget {
//   final String title;
//   final String value;

//   const DetailRow({super.key, required this.title, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: GoogleFonts.poppins(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey[600],
//             ),
//           ),
//           Flexible(
//             child: Text(
//               value,
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//               textAlign: TextAlign.right,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// notification.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'api_service.dart';
import 'connect_to_vendor_screen.dart';
import 'location_selection_screen.dart';

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

  Future<void> deleteNotification(String connectId, int index) async {
    bool deleted = await ApiService.deleteConnectRequest(connectId);
    if (deleted) {
      setState(() {
        notifications.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off,
                          size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No Notifications',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return NotificationTile(
                      notification: notification,
                      onDelete: () =>
                          deleteNotification(notification['id'], index),
                    );
                  },
                ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onDelete;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onDelete,
  });

  void _handleConnect(BuildContext context) {
    if (notification['status'] == 'ACCEPTED') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationSelectionScreen(
            shopDetails: {
              'id': notification['vendorId'],
              'name': notification['storeName'],
              'logo': notification['storeLogo'] ?? 'pics/bigstore.png',
              'selectedAddress': notification['address'],
            },
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConnectingToVendorScreen(
            storeDetails: {
              'id': notification['vendorId'],
              'name': notification['storeName'],
              'logo': notification['storeLogo'] ?? 'pics/bigstore.png',
              'selectedAddress': notification['address'],
            },
            initialPosition: LatLng(
              notification['address']['latitude'] ?? 0.0,
              notification['address']['longitude'] ?? 0.0,
            ),
            status: notification['status'],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    switch (notification['status']) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'accepted':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'canceled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => ConnectionDetailsBottomSheet(
              notification: notification,
              onDelete: onDelete,
              onConnect: () => _handleConnect(context),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: statusColor.withOpacity(0.1),
                child: Icon(statusIcon, color: statusColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connection Request',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Store: ${notification['storeName'] ?? 'Unknown Store'}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Vendor: ${notification['vendorName'] ?? 'Unknown Vendor'}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMM d, yyyy').format(
                              DateTime.parse(notification['dateCreated'])),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            notification['status'].toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
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
    );
  }
}

class ConnectionDetailsBottomSheet extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onDelete;
  final VoidCallback onConnect;

  const ConnectionDetailsBottomSheet({
    super.key,
    required this.notification,
    required this.onDelete,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connection Details',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                DetailRow(
                  title: 'Store',
                  value: notification['storeName'] ?? 'Unknown Store',
                ),
                DetailRow(
                  title: 'Vendor',
                  value: notification['vendorName'] ?? 'Unknown Vendor',
                ),
                DetailRow(title: 'Status', value: notification['status']),
                DetailRow(
                  title: 'Date Created',
                  value: DateFormat('MMM d, yyyy')
                      .format(DateTime.parse(notification['dateCreated'])),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onConnect();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFBE5AA),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          notification['status'] == 'accepted'
                              ? 'View Map'
                              : 'Connect',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF621B2B),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Cancellation',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600)),
                              content: Text(
                                  'Are you sure you want to cancel this request?',
                                  style: GoogleFonts.poppins()),
                              actions: [
                                TextButton(
                                  child:
                                      Text('No', style: GoogleFonts.poppins()),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                  child: Text('Yes',
                                      style: GoogleFonts.poppins(
                                          color: Colors.red)),
                                  onPressed: () {
                                    onDelete();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                      ),
                      child: Text(
                        'Cancel Request',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -20,
          child: Transform.translate(
            offset: const Offset(0, -60),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(150, 244, 67, 54),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const DetailRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
