// ignore_for_file: avoid_print, unused_local_variable
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class InternationalPassportValidator {
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

    // Regular expression to capture any standalone 'M' or 'F'
    final RegExp sexRegExp = RegExp(r'\b[M|F]\b');

    // Regular expression to capture specific 3-letter uppercase country codes
    final RegExp countryCodeRegExp =
        RegExp(r'\b(NGA|USA|CAN|GBR|AUS|IND|CHN|JPN|DEU|FRA|BRA|RUS)\b');

    // Regular expression to capture surname, which is a single capitalized word with more than 2 letters,
    // excluding specific words like "PASSPORT", "PASSEPORT", "NIGERIA", "AMERICA", "NGA", "USA", "LAGOS"
    // and other Nigerian states, not containing digits, and not having words separated by spaces or non-alphabetic characters
    // Also includes a pattern to capture surnames based on the keywords "name" or "Surname"
    final RegExp surnameRegExp = RegExp(
        r'^(?!PASSPORT|FEDERAL|Type|name|Country|Surname|PASSEPORT|NIGERIA|AMERICA|NGA|USA|LAGOS|AKWA IBOM|ANAMBRA|BAUCHI|BAYELSA|BENUE|BORNO|CROSS RIVER|DELTA|EBONYI|EDO|EKITI|ENUGU|GOMBE|IMO|JIGAWA|KADUNA|KANO|KATSINA|KEBBI|KOGI|KWARA|NASARAWA|NIGER|OGUN|ONDO|OSUN|OYO|PLATEAU|RIVERS|SOKOTO|TARABA|YOBE|ZAMFARA)(?:([A-Z]{3,})(?!\w)|((?:name|Surname).+?\n[A-Z]{3,}))',
        multiLine: true,
        caseSensitive: false);

    String errorMessage = '';
    bool isValid = false;
    String surname = '';

    // Validate using standalone 'M' or 'F', a valid country code, and a valid surname
    if (sexRegExp.hasMatch(recognizedTextStr) &&
        countryCodeRegExp.hasMatch(recognizedTextStr)) {
      final sexMatch = sexRegExp.firstMatch(recognizedTextStr);
      final countryCodeMatch = countryCodeRegExp.firstMatch(recognizedTextStr);
      final surnameMatch = surnameRegExp.firstMatch(recognizedTextStr);
      if (surnameMatch != null) {
        surname = surnameMatch.group(1) ?? surnameMatch.group(2) ?? '';
        isValid = true;
        print('Sex match found: ${sexMatch?.group(0)}');
        print('Country code match found: ${countryCodeMatch?.group(0)}');
        print('Surname: $surname');
      } else {
        errorMessage = 'No valid surname found';
        print('Validation failed: $errorMessage');
      }
    } else {
      errorMessage = 'Not a valid International Passport';
      print('Validation failed: $errorMessage');
    }
    return isValid;
  }
}
