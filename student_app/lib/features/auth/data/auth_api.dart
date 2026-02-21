import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_routes.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';

/// Auth API service — all calls go to real Cloudflare Workers endpoints.
class AuthApi {
  final Dio _dio;

  AuthApi(this._dio);

  /// Login with email/roll number + password.
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String identifier, // email or roll number
    required String password,
    required String tenantId,
  }) async {
    final response = await _dio.post(
      ApiRoutes.login,
      data: {
        'identifier': identifier,
        'password': password,
      },
      options: Options(headers: {'X-Tenant-ID': tenantId}),
    );
    return ApiResponse.fromJson(response.data, (data) => data);
  }

  /// Request OTP for phone login.
  Future<ApiResponse<Map<String, dynamic>>> sendOtp({
    required String phone,
    required String tenantId,
  }) async {
    final response = await _dio.post(
      ApiRoutes.otpSend,
      data: {'phone': phone},
      options: Options(headers: {'X-Tenant-ID': tenantId}),
    );
    return ApiResponse.fromJson(response.data, (data) => data);
  }

  /// Verify OTP and get JWT tokens.
  Future<ApiResponse<Map<String, dynamic>>> verifyOtp({
    required String phone,
    required String otp,
    required String tenantId,
  }) async {
    final response = await _dio.post(
      ApiRoutes.otpVerify,
      data: {'phone': phone, 'otp': otp},
      options: Options(headers: {'X-Tenant-ID': tenantId}),
    );
    return ApiResponse.fromJson(response.data, (data) => data);
  }

  /// Refresh access token.
  Future<ApiResponse<Map<String, dynamic>>> refreshToken(
    String refreshToken,
  ) async {
    final response = await _dio.post(
      ApiRoutes.refreshToken,
      data: {'refresh_token': refreshToken},
    );
    return ApiResponse.fromJson(response.data, (data) => data);
  }

  /// Fetch student profile.
  Future<ApiResponse<Map<String, dynamic>>> getProfile() async {
    final response = await _dio.get(ApiRoutes.profile);
    return ApiResponse.fromJson(response.data, (data) => data);
  }

  /// Update student profile.
  Future<ApiResponse<Map<String, dynamic>>> updateProfile(
    Map<String, dynamic> updates,
  ) async {
    final response = await _dio.put(ApiRoutes.profile, data: updates);
    return ApiResponse.fromJson(response.data, (data) => data);
  }
}

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(dioProvider));
});
