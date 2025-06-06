import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/config/constants.dart';
import 'package:mobile/profile/models/user_model.dart';

class UserRepository {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  UserRepository() {
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
            // For now, just pass the error through
            // Token refresh logic can be added here if needed
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// Get current user profile
  Future<User?> getCurrentUser() async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}/users/me');

      if (response.statusCode == 200 && response.data != null) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Failed to get current user: $e');
    }
    return null;
  }

  /// Update user profile
  Future<User?> updateProfile({
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
      // Create update data map, only including non-null values
      final Map<String, dynamic> updateData = {};

      if (firstName != null) updateData['first_name'] = firstName;
      if (lastName != null) updateData['last_name'] = lastName;
      if (phoneNumber != null) updateData['phone_number'] = phoneNumber;
      if (streetAddress != null) updateData['street_address'] = streetAddress;
      if (city != null) updateData['city'] = city;
      if (state != null) updateData['state'] = state;
      if (zipCode != null) updateData['zip_code'] = zipCode;
      if (country != null) updateData['country'] = country;

      final response = await _dio.put(
        '${ApiConstants.baseUrl}/users/me',
        data: updateData,
      );

      if (response.statusCode == 200 && response.data != null) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Failed to update user profile: $e');
      rethrow; // Re-throw to handle in UI
    }
    return null;
  }

  /// Delete user account (soft delete - deactivates account)
  Future<bool> deleteAccount() async {
    try {
      final response = await _dio.delete('${ApiConstants.baseUrl}/users/me');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Failed to delete account: $e');
      rethrow;
    }
  }
}
