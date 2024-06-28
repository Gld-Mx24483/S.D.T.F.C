// // ignore_for_file: avoid_print, unused_local_variable
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// class InternationalPassportValidator {
//   static Future<bool> recognizeAndValidatePassport(String filePath) async {
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
//     print('Recognized Text from International Passport:\n$recognizedTextStr');

//     final RegExp sexRegExp = RegExp(r'\b[M|F]\b');
//     final RegExp countryCodeRegExp =
//         RegExp(r'\b(NGA|USA|CAN|GBR|AUS|IND|CHN|JPN|DEU|FRA|BRA|RUS)\b');

//     // New regex for passport number
//     final RegExp passportNumberRegExp = RegExp(r'\b[A-Z]{1,2}\d{7,8}\b');

//     String errorMessage = '';
//     bool isValid = false;
//     String passportNumber = '';

//     if (sexRegExp.hasMatch(recognizedTextStr) &&
//         countryCodeRegExp.hasMatch(recognizedTextStr) &&
//         passportNumberRegExp.hasMatch(recognizedTextStr)) {
//       final sexMatch = sexRegExp.firstMatch(recognizedTextStr);
//       final countryCodeMatch = countryCodeRegExp.firstMatch(recognizedTextStr);
//       final passportNumberMatch =
//           passportNumberRegExp.firstMatch(recognizedTextStr);

//       if (passportNumberMatch != null) {
//         passportNumber = passportNumberMatch.group(0) ?? '';
//         isValid = true;
//         print('Sex match found: ${sexMatch?.group(0)}');
//         print('Country code match found: ${countryCodeMatch?.group(0)}');
//         print('Passport number match found: $passportNumber');
//       } else {
//         errorMessage = 'No valid passport number found';
//         print('Validation failed: $errorMessage');
//       }
//     } else {
//       errorMessage = 'Not a valid International Passport';
//       print('Validation failed: $errorMessage');
//     }

//     return isValid;
//   }
// }

// ignore_for_file: avoid_print, unused_local_variable
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class InternationalPassportValidator {
  static String? _passportNumber;

  static Future<bool> recognizeAndValidatePassport(String filePath) async {
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
    print('Recognized Text from International Passport:\n$recognizedTextStr');

    final RegExp sexRegExp = RegExp(r'\b[M|F]\b');
    final RegExp countryCodeRegExp =
        RegExp(r'\b(NGA|USA|CAN|GBR|AUS|IND|CHN|JPN|DEU|FRA|BRA|RUS)\b');
    final RegExp passportNumberRegExp = RegExp(r'\b[A-Z]{1,2}\d{7,8}\b');

    String errorMessage = '';
    bool isValid = false;

    if (sexRegExp.hasMatch(recognizedTextStr) &&
        countryCodeRegExp.hasMatch(recognizedTextStr) &&
        passportNumberRegExp.hasMatch(recognizedTextStr)) {
      final sexMatch = sexRegExp.firstMatch(recognizedTextStr);
      final countryCodeMatch = countryCodeRegExp.firstMatch(recognizedTextStr);
      final passportNumberMatch =
          passportNumberRegExp.firstMatch(recognizedTextStr);

      if (passportNumberMatch != null) {
        _passportNumber = passportNumberMatch.group(0) ?? '';
        isValid = true;
        print('Sex match found: ${sexMatch?.group(0)}');
        print('Country code match found: ${countryCodeMatch?.group(0)}');
        print('Passport number match found: $_passportNumber');
      } else {
        errorMessage = 'No valid passport number found';
        print('Validation failed: $errorMessage');
      }
    } else {
      errorMessage = 'Not a valid International Passport';
      print('Validation failed: $errorMessage');
    }

    return isValid;
  }

  static String? getVerificationId() {
    return _passportNumber;
  }
}
