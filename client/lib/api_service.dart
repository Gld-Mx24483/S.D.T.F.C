// api_service.dart
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://2a1a-197-211-58-220.ngrok-free.app/api/v1';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

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
        return true;
      } else {
        print('Signup failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> loginUser(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final body = {
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
        final responseData = jsonDecode(response.body);
        print('Login Response:');
        print('Message: ${responseData['message']}');
        print('Data:');
        if (responseData['data'] != null) {
          responseData['data'].forEach((key, value) {
            print('  $key: $value');
          });
        }
        print('StatusCode: ${responseData['statusCode']}');
        print('Timestamp: ${responseData['timestamp']}');

        // Store the access token
        if (responseData['data'] != null &&
            responseData['data']['access_token'] != null) {
          await _secureStorage.write(
              key: 'access_token', value: responseData['data']['access_token']);
        }

        return responseData;
      } else {
        print('Login failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    final url = Uri.parse('$baseUrl/users/profile');
    final accessToken = await getAccessToken();

    if (accessToken == null) {
      print('No access token found');
      return null;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data'];
      } else {
        print('Failed to get user profile: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> updateUserProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    String? imageUrl, // Add the imageUrl parameter here
  }) async {
    final url = Uri.parse('$baseUrl/api/users');
    final accessToken = await getAccessToken();

    if (accessToken == null) {
      print('No access token found');
      return null;
    }

    final body = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl, // Include the imageUrl in the request body
    };

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('Failed to update user profile: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error updating user profile: $e');
      return null;
    }
  }

  static Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/users/change-password');
    final accessToken = await getAccessToken();

    if (accessToken == null) {
      print('No access token found');
      return false;
    }

    final body = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Password changed successfully');
        return true;
      } else {
        print('Failed to change password: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error changing password: $e');
      return false;
    }
  }
}
