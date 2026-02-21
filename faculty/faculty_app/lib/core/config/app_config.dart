/// Centralized app configuration.
/// All values come from compile-time env or have sensible defaults.
class AppConfig {
  AppConfig._();

  /// Base URL for the Cloudflare Workers API.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.campussphere.in',
  );

  /// Supabase project URL (for Realtime subscriptions).
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  /// Supabase anonymous key.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// 100ms video SDK credentials.
  static const String hmsTokenEndpoint = String.fromEnvironment(
    'HMS_TOKEN_ENDPOINT',
    defaultValue: '',
  );

  /// App version displayed in settings.
  static const String appVersion = '1.0.0';
}
