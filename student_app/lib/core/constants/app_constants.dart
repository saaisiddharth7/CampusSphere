/// Hive box names for local storage.
class HiveBoxes {
  static const String userSession = 'user_session';
  static const String tenantConfig = 'tenant_config';
  static const String timetableCache = 'timetable_cache';
  static const String attendanceCache = 'attendance_cache';
  static const String offlineQueue = 'offline_queue';
  static const String notificationsCache = 'notifications_cache';
  static const String materialsCache = 'materials_cache';
  static const String chatroomCache = 'chatroom_cache';
  static const String feeCache = 'fee_cache';
  static const String resultsCache = 'results_cache';
}

/// Secure storage keys.
class SecureKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String tenantId = 'tenant_id';
  static const String userId = 'user_id';
  static const String studentId = 'student_id';
}

/// App-wide constants.
class AppConstants {
  static const String appName = 'CampusSphere';
  static const int otpLength = 6;
  static const int otpResendSeconds = 30;
  static const int maxFileUploadMb = 10;
  static const double defaultAttendanceMin = 75.0;
  static const List<String> allowedFileTypes = [
    'pdf',
    'doc',
    'docx',
    'zip',
    'jpg',
    'png'
  ];
}
