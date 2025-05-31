import 'package:dio/dio.dart';
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
      print('Failed to get current user: $e');
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
      print('Failed to update user profile: $e');
      rethrow; // Re-throw to handle in UI
    }
    return null;
  }

  /// Update user email (might require verification)
  Future<User?> updateEmail(String newEmail) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.baseUrl}/users/me/email',
        data: {'email': newEmail},
      );

      if (response.statusCode == 200 && response.data != null) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      print('Failed to update email: $e');
      rethrow;
    }
    return null;
  }

  /// Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.baseUrl}/users/me/password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Failed to change password: $e');
      rethrow;
    }
  }

  /// Delete user account
  Future<bool> deleteAccount(String password) async {
    try {
      final response = await _dio.delete(
        '${ApiConstants.baseUrl}/users/me',
        data: {'password': password},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Failed to delete account: $e');
      rethrow;
    }
  }

  /// Upload profile picture
  Future<User?> uploadProfilePicture(String imagePath) async {
    try {
      FormData formData = FormData.fromMap({
        'profile_picture': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        '${ApiConstants.baseUrl}/users/me/profile-picture',
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      print('Failed to upload profile picture: $e');
      rethrow;
    }
    return null;
  }
}
