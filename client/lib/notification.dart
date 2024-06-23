// //notification.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: 375,
//         height: 812,
//         color: Colors.white,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 35), // Add some top padding
//               child: Container(
//                 width: 375,
//                 height: 56,
//                 decoration: const BoxDecoration(),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         width: 24,
//                         height: 24,
//                         margin: const EdgeInsets.only(
//                           left: 20,
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 4.0,
//                         ),
//                         child: const Icon(
//                           Icons.arrow_back,
//                           color: Color.fromARGB(255, 1, 1, 1),
//                         ),
//                       ),
//                     ),
//                     Text(
//                       'Notifications',
//                       style: GoogleFonts.nunito(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         color: const Color(0xFF232323),
//                       ),
//                     ),
//                     const SizedBox(width: 44),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 371),
//             Text(
//               'No Notifications',
//               style: GoogleFonts.nunito(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: const Color(0xFFA6A6A6),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// notification.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'api_service.dart'; // Import your API service

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  List<dynamic>? stores;

  @override
  void initState() {
    super.initState();
    _fetchStores();
  }

  Future<void> _fetchStores() async {
    final fetchedStores = await ApiService.fetchAllStores();
    setState(() {
      stores = fetchedStores;
    });
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
              padding: const EdgeInsets.only(top: 35), // Add some top padding
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
              child: stores == null
                  ? const Center(child: CircularProgressIndicator())
                  : stores!.isEmpty
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
                          itemCount: stores!.length,
                          itemBuilder: (context, index) {
                            final store = stores![index];
                            return ListTile(
                              title: Text(store['name'] ?? 'Unnamed Store'),
                              subtitle: Text(store['email'] ?? 'No Email'),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
