import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart'; // Import logger package

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api/v1';
  static final Logger _logger = Logger(); // Initialize logger instance

  static Future<bool> signUpUser(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/users/signup');
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
        _logger.e('Signup failed: ${response.body}'); // Log error
        return false; // Signup failed
      }
    } catch (e) {
      _logger.e('Error: $e'); // Log error
      return false; // Error occurred
    }
  }
}
