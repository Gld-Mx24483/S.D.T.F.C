// api_service.dart
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://5841-62-173-45-238.ngrok-free.app/api/v1';
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
        final storeData = responseData['data'];

        print('Fetched store details:');
        print(storeData);

        if (storeData != null && storeData['logo'] != null) {
          print('Store logo URL: ${storeData['logo']}');
        } else {
          print('No logo found in the store details');
        }

        return storeData;
      } else {
        print('Failed to fetch store details: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching store details: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> updateStoreLogo(String logoUrl) async {
    final url = Uri.parse('$baseUrl/stores/update');
    final accessToken = await getAccessToken();

    if (accessToken == null) {
      print('No access token found');
      return null;
    }

    final body = {
      'logo': logoUrl,
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
        print('Failed to update store logo: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error updating store logo: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> updateStoreAddress(
      Map<String, dynamic> addressData) async {
    final url = Uri.parse('$baseUrl/stores/address/update');
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
        body: jsonEncode(addressData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('Failed to update store address: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error updating store address: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> createStoreAddress(
      Map<String, dynamic> addressData) async {
    final url = Uri.parse('$baseUrl/stores/address');
    final accessToken = await getAccessToken();

    if (accessToken == null) {
      print('No access token found');
      return null;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(addressData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('Failed to create store address: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating store address: $e');
      return null;
    }
  }

  static Future<bool> deleteStoreAddress(String addressId) async {
    final url = Uri.parse('$baseUrl/stores/address/$addressId/delete');
    final accessToken = await getAccessToken();

    if (accessToken == null) {
      print('No access token found');
      return false;
    }

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Address deleted successfully');
        return true;
      } else {
        print('Failed to delete address: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting address: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchAllStores() async {
    final url = Uri.parse('$baseUrl/connects/stores/all');
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
        print('Fetch All Stores Response: $responseData');

        if (responseData['data'] == null) {
          print('API returned null data');
          return [];
        }

        if (responseData['data'] is! List) {
          print(
              'API returned unexpected data type: ${responseData['data'].runtimeType}');
          return [];
        }

        return List<Map<String, dynamic>>.from(responseData['data']);
      } else {
        print(
            'Failed to fetch stores: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching stores: $e');
      return null;
    }
  }

  static Future<bool> sendConnectRequest(
      String storeId, String addressId) async {
    final url = Uri.parse('$baseUrl/connects');
    final accessToken = await getAccessToken();

    if (accessToken == null) {
      print('No access token found');
      return false;
    }

    final body = {
      'storeId': storeId,
      'addressId': addressId,
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
        print('Connect request sent successfully');
        return true;
      } else {
        print('Failed to send connect request: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error sending connect request: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchSentConnections() async {
    final url = Uri.parse('$baseUrl/connects/sent-connections');
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
        print('Sent connections raw data: $responseData');

        if (responseData['data'] != null && responseData['data'] is List) {
          final connections =
              List<Map<String, dynamic>>.from(responseData['data']);
          for (var connection in connections) {
            print('Connection: $connection');
            print('Vendor Name: ${connection['vendorName']}');
            print('User Name: ${connection['userName']}');
            print('Store Name: ${connection['storeName']}');
            print('Status: ${connection['status']}');
            print('Date Created: ${connection['dateCreated']}');
            print('Address: ${connection['address']}');
          }
          return connections;
        } else {
          print('Unexpected data format: ${responseData['data']}');
          return [];
        }
      } else {
        print('Failed to fetch sent connections: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching sent connections: $e');
      return null;
    }
  }

  static Future<bool> deleteConnectRequest(String connectId) async {
    final url = Uri.parse('$baseUrl/connects/delete/$connectId');
    final accessToken = await getAccessToken();

    if (accessToken == null) {
      print('No access token found');
      return false;
    }

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Connect request deleted successfully');
        return true;
      } else {
        print('Failed to delete connect request: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting connect request: $e');
      return false;
    }
  }

  static Future<bool> sendVerificationDetails(
      String verificationType, String verificationId) async {
    final url = Uri.parse('$baseUrl/users/verify-account');
    final accessToken = await getAccessToken();

    if (accessToken == null) {
      print('No access token found');
      return false;
    }

    final body = {
      'verificationStatus': 'VERIFIED',
      'verificationType': verificationType,
      'verificationId': verificationId,
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
        print('Verification details sent successfully');
        return true;
      } else {
        print('Failed to send verification details: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error sending verification details: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchReceivedConnections() async {
    final url = Uri.parse('$baseUrl/connects/received-connections');
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
        print('Received connections raw data: $responseData');
        if (responseData['data'] != null && responseData['data'] is List) {
          final connections =
              List<Map<String, dynamic>>.from(responseData['data']);
          for (var connection in connections) {
            print('Connection: $connection');
            print('Vendor Name: ${connection['vendorName']}');
            print('User Name: ${connection['userName']}');
            print('Store Name: ${connection['storeName']}');
            print('Status: ${connection['status']}');
            print('Date Created: ${connection['dateCreated']}');
            print('Address: ${connection['address']}');
          }
          return connections;
        } else {
          print('Unexpected data format: ${responseData['data']}');
          return [];
        }
      } else {
        print('Failed to fetch received connections: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching received connections: $e');
      return null;
    }
  }

  static Future<bool> acceptConnectRequest(String connectId) async {
    final url = Uri.parse('$baseUrl/connects/accept/$connectId');
    final accessToken = await getAccessToken();

    if (accessToken == null) {
      print('No access token found');
      return false;
    }

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Connect request accepted successfully');
        return true;
      } else {
        print('Failed to accept connect request: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error accepting connect request: $e');
      return false;
    }
  }
}
