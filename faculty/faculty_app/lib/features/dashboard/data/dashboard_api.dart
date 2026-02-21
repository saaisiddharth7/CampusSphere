import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_routes.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';

/// Dashboard API — fetches aggregated faculty dashboard data.
class DashboardApi {
  final Dio _dio;

  DashboardApi(this._dio);

  /// Fetch today's dashboard snapshot.
  Future<ApiResponse<Map<String, dynamic>>> getDashboard() async {
    final response = await _dio.get(ApiRoutes.dashboard);
    return ApiResponse.fromJson(response.data, (data) => data);
  }

  /// Fetch notification count.
  Future<ApiResponse<Map<String, dynamic>>> getNotifications({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _dio.get(
      ApiRoutes.notifications,
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    return ApiResponse.fromJson(response.data, (data) => data);
  }
}

final dashboardApiProvider = Provider<DashboardApi>((ref) {
  return DashboardApi(ref.watch(dioProvider));
});
