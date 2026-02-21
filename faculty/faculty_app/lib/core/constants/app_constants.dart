/// Secure storage keys and app-wide constants.
class SecureKeys {
  SecureKeys._();

  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
  static const tenantId = 'tenant_id';
  static const userProfile = 'user_profile';
  static const themeConfig = 'theme_config';
}

class AppConstants {
  AppConstants._();

  static const int attendanceWindowMinutes = 10;
  static const int qrExpirySeconds = 60;
  static const int maxFileSizeMb = 10;
  static const double campusRadiusMeters = 200.0;
  static const double attendanceMinimumPct = 75.0;
  static const int chatRateLimit = 30; // messages per minute
  static const int meetingMinParticipationPct = 70;
}
