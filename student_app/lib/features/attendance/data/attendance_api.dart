import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_routes.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';

/// Attendance API — real endpoints on Cloudflare Workers.
class AttendanceApi {
  final Dio _dio;

  AttendanceApi(this._dio);

  /// Mark attendance with GPS/QR verification data.
  Future<ApiResponse<Map<String, dynamic>>> markAttendance({
    required String courseId,
    required String sectionId,
    required String timetableEntryId,
    required String markedBy, // 'student_gps', 'student_qr'
    double? latitude,
    double? longitude,
    double? distanceFromCampus,
    bool? isWithinGeofence,
    String? qrCode,
    String? deviceId,
  }) async {
    final response = await _dio.post(
      ApiRoutes.attendanceMark,
      data: {
        'course_id': courseId,
        'section_id': sectionId,
        'timetable_entry_id': timetableEntryId,
        'marked_by': markedBy,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (distanceFromCampus != null) 'distance_from_campus': distanceFromCampus,
        if (isWithinGeofence != null) 'is_within_geofence': isWithinGeofence,
        if (qrCode != null) 'qr_code': qrCode,
        if (deviceId != null) 'device_id': deviceId,
      },
    );
    return ApiResponse.fromJson(response.data, (data) => data);
  }

  /// Get overall + subject-wise attendance stats.
  Future<ApiResponse<Map<String, dynamic>>> getStats() async {
    final response = await _dio.get(ApiRoutes.attendanceStats);
    return ApiResponse.fromJson(response.data, (data) => data);
  }

  /// Get full attendance history (paginated).
  Future<ApiResponse<Map<String, dynamic>>> getHistory({
    int page = 1,
    int pageSize = 20,
    String? courseId,
  }) async {
    final response = await _dio.get(
      ApiRoutes.attendanceHistory,
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (courseId != null) 'course_id': courseId,
      },
    );
    return ApiResponse.fromJson(response.data, (data) => data);
  }

  /// Get subject-specific attendance detail.
  Future<ApiResponse<Map<String, dynamic>>> getSubjectDetail(
    String subjectId,
  ) async {
    final response = await _dio.get(ApiRoutes.attendanceSubject(subjectId));
    return ApiResponse.fromJson(response.data, (data) => data);
  }
}

final attendanceApiProvider = Provider<AttendanceApi>((ref) {
  return AttendanceApi(ref.watch(dioProvider));
});
