// ignore_for_file: avoid_print

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class InternationalPassportValidator {
  static Future<void> recognizeAndValidatePassport(String filePath) async {
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

    // Add validation logic here later
  }
}
