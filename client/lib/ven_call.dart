// // ignore_for_file: unused_local_variable

// import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:google_fonts/google_fonts.dart';

// class VendorCall extends StatefulWidget {
//   final String vendorPhoneNumber;

//   const VendorCall({super.key, required this.vendorPhoneNumber});

//   @override
//   State<VendorCall> createState() => _VendorCallState();
// }

// class _VendorCallState extends State<VendorCall>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   bool _isDialing = false;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _scaleAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.2,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.elasticOut,
//     ));
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> _makePhoneCall() async {
//     setState(() {
//       _isDialing = true;
//     });
//     _animationController.forward();

//     bool? res =
//         await FlutterPhoneDirectCaller.callNumber(widget.vendorPhoneNumber);

//     _animationController.reverse();
//     setState(() {
//       _isDialing = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1E1E1E),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: const Align(
//                   alignment: Alignment.topLeft,
//                   child: Icon(
//                     Icons.arrow_back_ios,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               Column(
//                 children: [
//                   AnimatedBuilder(
//                     animation: _scaleAnimation,
//                     builder: (context, child) => Transform.scale(
//                       scale: _scaleAnimation.value,
//                       child: child,
//                     ),
//                     child: const Icon(
//                       Icons.call,
//                       color: Colors.white,
//                       size: 120,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   Text(
//                     _isDialing ? 'Calling...' : 'Calling Vendor',
//                     style: GoogleFonts.nunito(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     widget.vendorPhoneNumber,
//                     style: GoogleFonts.nunito(
//                       fontSize: 18,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: _makePhoneCall,
//                 child: Container(
//                   width: double.infinity,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF4CAF50),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Call',
//                       style: GoogleFonts.nunito(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
