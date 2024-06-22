// api_service.dart
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://b7d6-197-211-58-213.ngrok-free.app/api/v1';
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

  static Future<bool> signUpVendor(
    String firstName,
    String lastName,
    String email,
    String password,
    String shopName,
  ) async {
    final url = Uri.parse('$baseUrl/stores/vendor');
    final body = {
      "signupRequest": {
        "email": email,
        "password": password,
        "firstName": firstName,
        "lastName": lastName
      },
      "name": shopName,
      "logo": null
    };

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30)); // Add a timeout

      if (response.statusCode == 200) {
        print('Vendor signup successful: ${response.body}');
        return true;
      } else {
        print('Vendor signup failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during vendor signup: $e');
      rethrow; // Re-throw the exception to be caught in _validateOTPAndProceed
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
            responseData['data']['accessToken'] != null) {
          await _secureStorage.write(
              key: 'access_token', value: responseData['data']['accessToken']);
        }

        // Store the user type
        if (responseData['data'] != null &&
            responseData['data']['userType'] != null) {
          await _secureStorage.write(
              key: 'user_type', value: responseData['data']['userType']);
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
        // Print fetched data to console
        print('Fetched user profile:');
        print(responseData);
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
    String? profileImage,
  }) async {
    final url = Uri.parse('$baseUrl/users');
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
      'profileImage': profileImage,
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

  static Future<Map<String, dynamic>?> sendTransactionDetails(
      Map<String, dynamic> transactionDetails) async {
    final url = Uri.parse('$baseUrl/connects/wallet/token/add');
    final accessToken = await getAccessToken();

    if (accessToken == null) {
      print('No access token found');
      return null;
    }

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(transactionDetails),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('Failed to send transaction details: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error sending transaction details: $e');
      return null;
    }
  }

  static Future<List<dynamic>?> fetchRecentTransactions() async {
    final url = Uri.parse('$baseUrl/connects/wallet/transactions');
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
        if (responseData['data'] != null && responseData['data'] is List) {
          return responseData['data'];
        } else {
          print('Failed to fetch recent transactions: ${response.body}');
        }
      } else {
        print('Failed to fetch recent transactions: ${response.body}');
      }
    } catch (e) {
      print('Error fetching recent transactions: $e');
    }

    return null;
  }

  static Future<Map<String, dynamic>?> updateStore(
      Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/stores/update');
    final accessToken = await getAccessToken();

    if (accessToken == null) {
      print('No access token found');
      return null;
    }

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
        print('Failed to update store details: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error updating store details: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchStoreDetails() async {
    final url = Uri.parse('$baseUrl/stores');
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
        print('Failed to fetch store details: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching store details: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> updateStoreLogo(
      String logoUrl, String shopName) async {
    final url = Uri.parse('$baseUrl/stores');
    final accessToken = await getAccessToken();

    if (accessToken == null) {
      print('No access token found');
      return null;
    }

    final body = {
      'name': shopName,
      'logo': logoUrl,
    };

    try {
      final response = await http.post(
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
        print('Failed to update store logo: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error updating store logo: $e');
      return null;
    }
  }
}
