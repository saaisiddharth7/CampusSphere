/// Typed wrapper for API responses from Cloudflare Workers.
class ApiResponse<T> {
  final bool success;
  final T? data;
  final ApiError? error;
  final Map<String, dynamic>? meta;

  const ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic data) fromData,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? fromData(json['data']) : null,
      error: json['error'] != null ? ApiError.fromJson(json['error']) : null,
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }
}

class ApiError {
  final String code;
  final String message;

  const ApiError({required this.code, required this.message});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] ?? 'UNKNOWN',
      message: json['message'] ?? 'Something went wrong',
    );
  }
}
