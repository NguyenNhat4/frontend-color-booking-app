import 'package:dio/dio.dart';
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
        onError: (DioError error, handler) async {
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
      print('Token refresh failed: $e');
    }
    return false;
  }

  Future<String?> login(String usernameOrEmail, String password) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/auth/login',
        data: {'username_or_email': usernameOrEmail, 'password': password},
      );
      if (response.statusCode == 200 && response.data['access_token'] != null) {
        return response.data['access_token'];
      }
    } catch (e) {
      // Handle error appropriately
      print('Login failed: $e');
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
    required String accountType,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/auth/register',
        data: {
          'email': email,
          'username': username,
          'password': password,
          'confirm_password':
              password, // Assuming confirm_password is same as password for now
          'first_name': firstName,
          'last_name': lastName,
          'phone_number': phoneNumber,
          'account_type': accountType,
        },
      );
      if (response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      print('Registration failed: $e');
    }
    return null;
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
}
