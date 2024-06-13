//api_service.dart
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://6f06-102-88-68-118.ngrok-free.app/api/v1';

  static Future<bool> signUpUser(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/auth/signup');
    final body = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return true; // Signup successful
      } else {
        print('Signup failed: ${response.body}'); // Handle error
        return false; // Signup failed
      }
    } catch (e) {
      print('Error: $e'); // Handle error
      return false; // Error occurred
    }
  }
}
