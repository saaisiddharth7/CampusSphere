/// Environment configuration for CampusSphere Student App.
/// All values come from compile-time dart-define or .env
class AppConfig {
  // Supabase
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  // Cloudflare Workers API Base URL
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  // Razorpay
  static const String razorpayKeyId = String.fromEnvironment(
    'RAZORPAY_KEY_ID',
    defaultValue: '',
  );

  // 100ms Video
  static const String hmsTokenEndpoint = String.fromEnvironment(
    'HMS_TOKEN_ENDPOINT',
    defaultValue: '',
  );

  // Geo-fence defaults (overridden per tenant)
  static const double defaultGeofenceRadius = 500; // meters
  static const double defaultLatitude = 0;
  static const double defaultLongitude = 0;

  // Offline sync
  static const int maxOfflineRetries = 3;
  static const int syncIntervalMinutes = 5;

  // Pagination
  static const int defaultPageSize = 20;

  // Cache TTL (in minutes)
  static const int timetableCacheTtl = 1440; // 24h
  static const int attendanceCacheTtl = 60; // 1h
  static const int feeCacheTtl = 30;
  static const int resultsCacheTtl = 60;
  static const int notificationsCacheTtl = 5;
}
