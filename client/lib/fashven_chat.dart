import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FashvenChat extends StatelessWidget {
  final String selectedLocationName;
  final String selectedLocationAddress = '123 Main Street, Anytown, CA 12345';

  const FashvenChat({
    super.key,
    required this.selectedLocationName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          color: Colors.white,
          child: Padding(
            // padding: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),

            child: Card(
              color: Colors.white,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 24,
                      ),
                      padding: const EdgeInsets.only(left: 4.42),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedLocationName,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        Text(
                          selectedLocationAddress,
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFFA6A6A6),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.call_outlined,
                          color: Color(0xFF621B2B),
                          size: 21,
                        ),
                        padding: const EdgeInsets.all(1.75),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(
          'No Messages',
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}
