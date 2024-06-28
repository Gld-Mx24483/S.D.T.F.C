// // ignore_for_file: avoid_print
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// class DriverLicenseValidator {
//   static Future<bool> recognizeAndValidateDriversLicense(
//       String filePath) async {
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
//     print('Recognized Text from Driver\'s License:\n$recognizedTextStr');

//     final RegExp bloodGroupRegExp = RegExp(r'BG\s*([A|B|AB|O|0][+-]?)');
//     final RegExp stateRegExp = RegExp(
//         r'(LAGOS|AKWA IBOM|ANAMBRA|BAUCHI|BAYELSA|BENUE|BORNO|CROSS RIVER|DELTA|EBONYI|EDO|EKITI|ENUGU|GOMBE|IMO|JIGAWA|KADUNA|KANO|KATSINA|KEBBI|KOGI|KWARA|NASARAWA|NIGER|OGUN|ONDO|OSUN|OYO|PLATEAU|RIVERS|SOKOTO|TARABA|YOBE|ZAMFARA)\s*STATE');
//     final RegExp licenseNumberRegExp =
//         RegExp(r'(?:LINO|L/NO)?\s*([A-Z]{3,4}(?=.*\d)[A-Z0-9]{7,11})');

//     bool isBloodGroupValid = false;
//     bool isStateValid = false;
//     bool isLicenseNumberValid = false;
//     // String surname = '';
//     String licenseNumber = '';

//     for (final line in recognizedTextStr.split('\n')) {
//       if (bloodGroupRegExp.hasMatch(line)) {
//         isBloodGroupValid = true;
//         print(
//             'Blood Group match found: ${bloodGroupRegExp.firstMatch(line)?.group(1)}');
//       }
//       if (stateRegExp.hasMatch(line)) {
//         isStateValid = true;
//         print('State match found: ${stateRegExp.firstMatch(line)?.group(0)}');
//       }
//       final licenseMatch = licenseNumberRegExp.firstMatch(line);
//       if (licenseMatch != null) {
//         isLicenseNumberValid = true;
//         licenseNumber = licenseMatch.group(1) ?? '';
//         print('License Number match found: $licenseNumber');
//       }
//     }

//     bool isValid = isBloodGroupValid && isStateValid && isLicenseNumberValid;
//     return isValid;
//   }
// }

// ignore_for_file: avoid_print
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class DriverLicenseValidator {
  static String? _licenseNumber;

  static Future<bool> recognizeAndValidateDriversLicense(
      String filePath) async {
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
    print('Recognized Text from Driver\'s License:\n$recognizedTextStr');

    final RegExp bloodGroupRegExp = RegExp(r'BG\s*([A|B|AB|O|0][+-]?)');
    final RegExp stateRegExp = RegExp(
        r'(LAGOS|AKWA IBOM|ANAMBRA|BAUCHI|BAYELSA|BENUE|BORNO|CROSS RIVER|DELTA|EBONYI|EDO|EKITI|ENUGU|GOMBE|IMO|JIGAWA|KADUNA|KANO|KATSINA|KEBBI|KOGI|KWARA|NASARAWA|NIGER|OGUN|ONDO|OSUN|OYO|PLATEAU|RIVERS|SOKOTO|TARABA|YOBE|ZAMFARA)\s*STATE');
    final RegExp licenseNumberRegExp =
        RegExp(r'(?:LINO|L/NO)?\s*([A-Z]{3,4}(?=.*\d)[A-Z0-9]{7,11})');

    bool isBloodGroupValid = false;
    bool isStateValid = false;
    bool isLicenseNumberValid = false;

    for (final line in recognizedTextStr.split('\n')) {
      if (bloodGroupRegExp.hasMatch(line)) {
        isBloodGroupValid = true;
        print(
            'Blood Group match found: ${bloodGroupRegExp.firstMatch(line)?.group(1)}');
      }
      if (stateRegExp.hasMatch(line)) {
        isStateValid = true;
        print('State match found: ${stateRegExp.firstMatch(line)?.group(0)}');
      }
      final licenseMatch = licenseNumberRegExp.firstMatch(line);
      if (licenseMatch != null) {
        isLicenseNumberValid = true;
        _licenseNumber = licenseMatch.group(1) ?? '';
        print('License Number match found: $_licenseNumber');
      }
    }

    bool isValid = isBloodGroupValid && isStateValid && isLicenseNumberValid;
    return isValid;
  }

  static String? getVerificationId() {
    return _licenseNumber;
  }
}
