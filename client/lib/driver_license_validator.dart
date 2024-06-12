// driver_license_validator.dart
// ignore_for_file: avoid_print

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class DriverLicenseValidator {
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

    final RegExp bloodGroupRegExp = RegExp(r'BG\s*([A|B|AB|O][+-])');
    final RegExp stateRegExp = RegExp(
        r'(LAGOS|AKWA IBOM|ANAMBRA|BAUCHI|BAYELSA|BENUE|BORNO|CROSS RIVER|DELTA|EBONYI|EDO|EKITI|ENUGU|GOMBE|IMO|JIGAWA|KADUNA|KANO|KATSINA|KEBBI|KOGI|KWARA|NASARAWA|NIGER|OGUN|ONDO|OSUN|OYO|PLATEAU|RIVERS|SOKOTO|TARABA|YOBE|ZAMFARA)\s*STATE');

    bool isBloodGroupValid = bloodGroupRegExp.hasMatch(recognizedTextStr);
    bool isStateValid = stateRegExp.hasMatch(recognizedTextStr);

    if (isBloodGroupValid && isStateValid) {
      print(
          'Blood Group match found: ${bloodGroupRegExp.firstMatch(recognizedTextStr)?.group(1)}');
      print(
          'State match found: ${stateRegExp.firstMatch(recognizedTextStr)?.group(0)}');
    } else {
      print('Blood Group or State validation failed');
    }

    // Add more validation logic here

    // Set the validation result
    bool isValid = isBloodGroupValid && isStateValid;

    return isValid;
  }
}
