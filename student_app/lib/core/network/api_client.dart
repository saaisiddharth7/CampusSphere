import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import '../constants/app_constants.dart';

/// Dio HTTP client with auth/tenant interceptors for Cloudflare Workers API.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  dio.interceptors.add(AuthInterceptor(ref));
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    error: true,
  ));

  return dio;
});

/// Injects JWT access token and tenant ID into every request.
class AuthInterceptor extends Interceptor {
  final Ref _ref;
  final _storage = const FlutterSecureStorage();

  AuthInterceptor(this._ref);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: SecureKeys.accessToken);
    final tenantId = await _storage.read(key: SecureKeys.tenantId);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    if (tenantId != null) {
      options.headers['X-Tenant-ID'] = tenantId;
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Try token refresh
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        // Retry original request with new token
        final token = await _storage.read(key: SecureKeys.accessToken);
        err.requestOptions.headers['Authorization'] = 'Bearer $token';
        try {
          final response = await Dio().fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
    }
    handler.next(err);
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await _storage.read(key: SecureKeys.refreshToken);
      if (refreshToken == null) return false;

      final response = await Dio().post(
        '${AppConfig.apiBaseUrl}/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        await _storage.write(
          key: SecureKeys.accessToken,
          value: response.data['access_token'],
        );
        await _storage.write(
          key: SecureKeys.refreshToken,
          value: response.data['refresh_token'],
        );
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
