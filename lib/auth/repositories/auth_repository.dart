import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/config/constants.dart';

class AuthRepository {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthRepository() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Attach JWT token if available
          String? token = await _secureStorage.read(key: 'auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // If 401, try to refresh token
          if (error.response?.statusCode == 401) {
            // Attempt token refresh logic here
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the original request with new token
              final opts = error.requestOptions;
              String? newToken = await _secureStorage.read(key: 'auth_token');
              if (newToken != null && newToken.isNotEmpty) {
                opts.headers['Authorization'] = 'Bearer $newToken';
              }
              try {
                final cloneReq = await _dio.fetch(opts);
                return handler.resolve(cloneReq);
              } catch (e) {
                return handler.reject(error);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      // Get the current token
      String? token = await _secureStorage.read(key: 'auth_token');
      if (token == null || token.isEmpty) {
        return false;
      }
      // Call the refresh endpoint with the current token in the Authorization header
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/auth/refresh-token',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 && response.data['access_token'] != null) {
        await persistToken(response.data['access_token']);
        return true;
      }
    } catch (e) {
      debugPrint('Token refresh failed: $e');
    }
    return false;
  }

  Future<Map<String, dynamic>?> login(
    String usernameOrEmail,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/auth/login',
        data: {'username_or_email': usernameOrEmail, 'password': password},
      );
      if (response.statusCode == 200 && response.data['access_token'] != null) {
        // Store the token for future API calls
        await persistToken(response.data['access_token']);
        if (response.data['user'] != null &&
            response.data['user']['username'] != null) {
          await persistUsername(response.data['user']['username']);
        }

        return {
          'access_token': response.data['access_token'],
          'user': response.data['user'],
        };
      }
    } catch (e) {
      // Handle error appropriately
      debugPrint('Login failed: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> register({
    required String email,
    required String username,
    required String password,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/auth/register',
        data: {
          'email': email,
          'username': username,
          'password': password,
          'confirm_password': password, // Required field matching password
          'first_name': firstName,
          'last_name': lastName,
          'phone_number': phoneNumber,
        },
      );
      if (response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      debugPrint('Registration failed: $e');
      rethrow; // Re-throw the error so the UI can handle it
    }
    return null;
  }

  /// Set account type after registration (separate endpoint)
  Future<Map<String, dynamic>?> setAccountType(String accountType) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.baseUrl}/auth/account-type',
        data: {'account_type': accountType},
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      debugPrint('Setting account type failed: $e');
    }
    return null;
  }

  /// Initiate password reset
  Future<Map<String, dynamic>?> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/auth/forgot-password',
        data: {'email': email},
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      debugPrint('Forgot password failed: $e');
    }
    return null;
  }

  /// Reset password with token
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/auth/reset-password',
        data: {
          'token': token,
          'new_password': newPassword,
          'confirm_password':
              newPassword, // Required field matching new_password
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Password reset failed: $e');
    }
    return false;
  }

  /// Verify email with token
  Future<bool> verifyEmail(String verificationToken) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/auth/verify-email/$verificationToken',
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Email verification failed: $e');
    }
    return false;
  }

  Future<void> persistToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<void> persistUsername(String username) async {
    await _secureStorage.write(key: 'username', value: username);
  }

  Future<bool> hasToken() async {
    String? token = await _secureStorage.read(key: 'auth_token');
    return token != null && token.isNotEmpty;
  }

  Future<String?> getUsername() async {
    return await _secureStorage.read(key: 'username');
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  Future<void> deleteUsername() async {
    await _secureStorage.delete(key: 'username');
  }

  /// Get current user profile
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}/users/me');
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      debugPrint('Get current user failed: $e');
    }
    return null;
  }

  /// Update current user profile
  Future<Map<String, dynamic>?> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? streetAddress,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      if (streetAddress != null) data['street_address'] = streetAddress;
      if (city != null) data['city'] = city;
      if (state != null) data['state'] = state;
      if (zipCode != null) data['zip_code'] = zipCode;
      if (country != null) data['country'] = country;

      final response = await _dio.put(
        '${ApiConstants.baseUrl}/users/me',
        data: data,
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      debugPrint('Update profile failed: $e');
    }
    return null;
  }
}
