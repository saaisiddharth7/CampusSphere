/// Standard API response wrapper matching the Cloudflare Worker response format.
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final ApiError? error;
  final PaginationMeta? pagination;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.pagination,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      message: json['message'],
      error: json['error'] != null
          ? ApiError.fromJson(json['error'])
          : null,
      pagination: json['pagination'] != null
          ? PaginationMeta.fromJson(json['pagination'])
          : null,
    );
  }
}

class ApiError {
  final String code;
  final String message;

  ApiError({required this.code, required this.message});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] ?? 'UNKNOWN',
      message: json['message'] ?? 'An error occurred',
    );
  }
}

class PaginationMeta {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;

  PaginationMeta({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: json['page'] ?? 1,
      pageSize: json['page_size'] ?? 20,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
    );
  }

  bool get hasNext => page < totalPages;
}
