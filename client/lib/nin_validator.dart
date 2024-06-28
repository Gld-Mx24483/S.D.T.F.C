// // ignore_for_file: avoid_print, unused_local_variable
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// class NinValidator {
//   static Future<bool> validateIdFile(String filePath) async {
//     final TextRecognizer textRecognizer =
//         TextRecognizer(script: TextRecognitionScript.latin);
//     final RecognizedText recognizedText =
//         await textRecognizer.processImage(InputImage.fromFilePath(filePath));
//     String recognizedTextStr = '';
//     for (TextBlock block in recognizedText.blocks) {
//       for (TextLine line in block.lines) {
//         recognizedTextStr += '${line.text}\n';
//       }
//     }

//     // Regular expressions to capture dynamic values for NIN
//     final RegExp ninRegExp = RegExp(r'\b\d{11}\b');
//     final RegExp trackingIdRegExp = RegExp(r'Tracking ID:\s*([A-Z0-9]{15})');

//     String errorMessage = '';
//     bool isValid = false;
//     String? ninToSend;

//     // Check for NIN and Tracking ID
//     if (ninRegExp.hasMatch(recognizedTextStr)) {
//       ninToSend = ninRegExp.firstMatch(recognizedTextStr)?.group(0);
//       print('NIN match found: $ninToSend');
//     } else {
//       print('No NIN match found');
//     }

//     // Print statement for NIN to be sent to the database
//     print('NIN to be sent to the database: $ninToSend');

//     if (trackingIdRegExp.hasMatch(recognizedTextStr)) {
//       print(
//           'Tracking ID match found: ${trackingIdRegExp.firstMatch(recognizedTextStr)?.group(1)}');
//     } else {
//       print('No Tracking ID match found');
//     }

//     if (ninRegExp.hasMatch(recognizedTextStr) &&
//         trackingIdRegExp.hasMatch(recognizedTextStr)) {
//       isValid = true;
//     } else {
//       errorMessage = 'Not a valid NIN';
//     }

//     return isValid;
//   }
// }

// ignore_for_file: avoid_print, unused_local_variable
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class NinValidator {
  static String? _ninNumber;

  static Future<bool> validateIdFile(String filePath) async {
    final TextRecognizer textRecognizer =
        TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(InputImage.fromFilePath(filePath));
    String recognizedTextStr = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        recognizedTextStr += '${line.text}\n';
      }
    }

    final RegExp ninRegExp = RegExp(r'\b\d{11}\b');
    final RegExp trackingIdRegExp = RegExp(r'Tracking ID:\s*([A-Z0-9]{15})');

    String errorMessage = '';
    bool isValid = false;

    if (ninRegExp.hasMatch(recognizedTextStr)) {
      _ninNumber = ninRegExp.firstMatch(recognizedTextStr)?.group(0);
      print('NIN match found: $_ninNumber');
    } else {
      print('No NIN match found');
    }

    print('NIN to be sent to the database: $_ninNumber');

    if (trackingIdRegExp.hasMatch(recognizedTextStr)) {
      print(
          'Tracking ID match found: ${trackingIdRegExp.firstMatch(recognizedTextStr)?.group(1)}');
    } else {
      print('No Tracking ID match found');
    }

    if (ninRegExp.hasMatch(recognizedTextStr) &&
        trackingIdRegExp.hasMatch(recognizedTextStr)) {
      isValid = true;
    } else {
      errorMessage = 'Not a valid NIN';
    }

    return isValid;
  }

  static String? getVerificationId() {
    return _ninNumber;
  }
}
