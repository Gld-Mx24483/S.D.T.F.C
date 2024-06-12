//nin_validator.dart
// ignore_for_file: avoid_print, unused_local_variable

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class NinValidator {
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

    // Regular expressions to capture dynamic values for NIN
    final RegExp ninRegExp = RegExp(r'\b\d{11}\b');
    final RegExp trackingIdRegExp = RegExp(r'Tracking ID:\s*([A-Z0-9]{15})');

    // Regular expressions for other values (not used for validation)
    final RegExp surnameRegExp = RegExp(r'Gender:\s*([A-Z ]+)');
    final RegExp firstNameRegExp = RegExp(r'First Name:\s*([A-Z ]+)');
    final RegExp middleNameRegExp = RegExp(r'Middle Name:\s*([A-Z]+)\s*([MF])');
    // final RegExp sexRegExp = RegExp(r'Gender:\s*([A-Za-z ]+)\s*([MF])');

    String errorMessage = '';
    bool isValid = false;

    // Check for NIN and Tracking ID
    if (ninRegExp.hasMatch(recognizedTextStr)) {
      print(
          'NIN match found: ${ninRegExp.firstMatch(recognizedTextStr)?.group(0)}');
    } else {
      print('No NIN match found');
    }

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

    // Print matches for other regular expressions
    if (surnameRegExp.hasMatch(recognizedTextStr)) {
      print(
          'Surname match found: ${surnameRegExp.firstMatch(recognizedTextStr)?.group(1)}');
    }

    if (firstNameRegExp.hasMatch(recognizedTextStr)) {
      print(
          'First name match found: ${firstNameRegExp.firstMatch(recognizedTextStr)?.group(1)}');
    }

    if (middleNameRegExp.hasMatch(recognizedTextStr)) {
      print(
          'Middle name match found: ${middleNameRegExp.firstMatch(recognizedTextStr)?.group(1)}');
      print(
          'Sex match found: ${middleNameRegExp.firstMatch(recognizedTextStr)?.group(2)}');
    }

    return isValid;
  }
}
