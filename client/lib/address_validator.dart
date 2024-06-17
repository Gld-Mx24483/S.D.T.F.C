// address_validator.dart
// ignore_for_file: avoid_print

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class AddressValidator {
  static Future<bool> validateAddressFile(String filePath) async {
    final TextRecognizer textRecognizer =
        TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(InputImage.fromFilePath(filePath));

    String recognizedTextStr = recognizedText.text.toLowerCase();

    // Keywords to look for
    final List<String> keywords = ['blk', 'flat', 'abesan'];

    // Check if all keywords are present in the recognized text
    bool isValid =
        keywords.every((keyword) => recognizedTextStr.contains(keyword));

    // Print recognized text and validation result for debugging
    print('Recognized text: $recognizedTextStr');
    print('Address is valid: $isValid');

    // Don't forget to close the text recognizer
    textRecognizer.close();

    return isValid;
  }
}
