import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_routes.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';

/// Auth API — handles login, OTP, token refresh, profile.
class AuthApi {
  final Dio _dio;

  AuthApi(this._dio);

  /// Login with email/phone + password.
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String tenantSlug,
    required String identifier,
    required String password,
  }) async {
    final response = await _dio.post(ApiRoutes.login, data: {
      'tenant_slug': tenantSlug,
      'identifier': identifier,
      'password': password,
      'role': 'faculty',
    });
    return ApiResponse.fromJson(response.data, (data) => data);
  }

  /// Request OTP.
  Future<ApiResponse<Map<String, dynamic>>> requestOtp({
    required String tenantSlug,
    required String phone,
  }) async {
    final response = await _dio.post(ApiRoutes.loginOtp, data: {
      'tenant_slug': tenantSlug,
      'phone': phone,
      'role': 'faculty',
    });
    return ApiResponse.fromJson(response.data, (data) => data);
  }

  /// Verify OTP.
  Future<ApiResponse<Map<String, dynamic>>> verifyOtp({
    required String tenantSlug,
    required String phone,
    required String otp,
  }) async {
    final response = await _dio.post(ApiRoutes.verifyOtp, data: {
      'tenant_slug': tenantSlug,
      'phone': phone,
      'otp': otp,
    });
    return ApiResponse.fromJson(response.data, (data) => data);
  }

  /// Get current profile.
  Future<ApiResponse<Map<String, dynamic>>> getProfile() async {
    final response = await _dio.get(ApiRoutes.profile);
    return ApiResponse.fromJson(response.data, (data) => data);
  }
}

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(dioProvider));
});
