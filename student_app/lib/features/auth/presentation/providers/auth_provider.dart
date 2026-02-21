import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/auth_api.dart';
import '../../domain/user_model.dart';

/// Auth state for the app.
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final StudentProfile? profile;
  final String? tenantId;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.profile,
    this.tenantId,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    StudentProfile? profile,
    String? tenantId,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      tenantId: tenantId ?? this.tenantId,
      errorMessage: errorMessage,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

/// Auth provider — manages login, logout, token storage, and session restore.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApi _authApi;
  final Ref _ref;
  final _storage = const FlutterSecureStorage();

  AuthNotifier(this._authApi, this._ref) : super(const AuthState());

  /// Try to restore session from secure storage on app launch.
  Future<void> tryRestoreSession() async {
    try {
      final token = await _storage.read(key: SecureKeys.accessToken);
      final tenantId = await _storage.read(key: SecureKeys.tenantId);

      if (token == null || tenantId == null) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return;
      }

      state = state.copyWith(status: AuthStatus.loading, tenantId: tenantId);

      // Fetch profile from API to validate token
      final profileResponse = await _authApi.getProfile();
      if (profileResponse.success && profileResponse.data != null) {
        final profile = StudentProfile.fromJson(profileResponse.data!);

        // Load tenant theme
        await _loadTenantTheme(tenantId);

        state = state.copyWith(
          status: AuthStatus.authenticated,
          profile: profile,
          tenantId: tenantId,
        );
      } else {
        // Token expired or invalid
        await _clearStorage();
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      // Network error — try offline mode with cached profile
      final cachedProfile = await _getCachedProfile();
      if (cachedProfile != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          profile: cachedProfile,
        );
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    }
  }

  /// Login with email/roll number + password.
  Future<void> login({
    required String identifier,
    required String password,
    required String tenantId,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final response = await _authApi.login(
        identifier: identifier,
        password: password,
        tenantId: tenantId,
      );

      if (response.success && response.data != null) {
        await _handleLoginSuccess(response.data!, tenantId);
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: response.error?.message ?? 'Login failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Network error. Please check your connection.',
      );
    }
  }

  /// Login with OTP.
  Future<void> sendOtp({
    required String phone,
    required String tenantId,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _authApi.sendOtp(phone: phone, tenantId: tenantId);
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Failed to send OTP',
      );
    }
  }

  Future<void> verifyOtp({
    required String phone,
    required String otp,
    required String tenantId,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await _authApi.verifyOtp(
        phone: phone,
        otp: otp,
        tenantId: tenantId,
      );

      if (response.success && response.data != null) {
        await _handleLoginSuccess(response.data!, tenantId);
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: response.error?.message ?? 'Invalid OTP',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Verification failed',
      );
    }
  }

  /// [DEV ONLY] Demo mode — bypasses API for testing before backend is deployed.
  /// Remove this when Cloudflare Workers API is live.
  Future<void> loginDemoMode() async {
    state = state.copyWith(status: AuthStatus.loading);
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate loading

    final demoProfile = StudentProfile(
      user: User(
        id: 'demo-user-001',
        tenantId: 'demo-tenant',
        email: 'student@campussphere.demo',
        phone: '9876543210',
        role: 'student',
        firstName: 'Saai',
        lastName: 'Siddu',
        isActive: true,
        createdAt: DateTime.now(),
      ),
      student: Student(
        id: 'demo-student-001',
        tenantId: 'demo-tenant',
        userId: 'demo-user-001',
        rollNumber: '21CS101',
        registrationNumber: 'REG2021CS101',
        departmentId: 'dept-cse-001',
        programId: 'prog-btech-001',
        sectionId: 'sec-a-001',
        currentSemester: 4,
        batchYear: 2021,
        admissionType: 'Regular',
        category: 'General',
        parentName: 'Parent Name',
        parentPhone: '9876543211',
        parentEmail: 'parent@email.com',
        bloodGroup: 'O+',
      ),
      departmentName: 'Computer Science & Engineering',
      departmentCode: 'CSE',
      programName: 'B.Tech',
      sectionName: 'A',
    );

    state = state.copyWith(
      status: AuthStatus.authenticated,
      profile: demoProfile,
      tenantId: 'demo-tenant',
    );
  }

  /// Logout — clear all tokens and cache.
  Future<void> logout() async {
    await _clearStorage();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Handle successful login response.
  Future<void> _handleLoginSuccess(
    Map<String, dynamic> data,
    String tenantId,
  ) async {
    // Store tokens securely
    await _storage.write(
      key: SecureKeys.accessToken,
      value: data['access_token'],
    );
    await _storage.write(
      key: SecureKeys.refreshToken,
      value: data['refresh_token'],
    );
    await _storage.write(key: SecureKeys.tenantId, value: tenantId);
    await _storage.write(key: SecureKeys.userId, value: data['user']['id']);
    await _storage.write(
      key: SecureKeys.studentId,
      value: data['student']['id'],
    );

    // Parse profile
    final profile = StudentProfile.fromJson(data);

    // Cache profile for offline use
    await _cacheProfile(data);

    // Load tenant theme config
    if (data['tenant'] != null) {
      final themeConfig = TenantThemeConfig.fromJson(data['tenant']);
      _ref.read(tenantThemeProvider.notifier).state = themeConfig;
    }

    state = state.copyWith(
      status: AuthStatus.authenticated,
      profile: profile,
      tenantId: tenantId,
    );
  }

  Future<void> _loadTenantTheme(String tenantId) async {
    try {
      final box = await Hive.openBox<String>(HiveBoxes.tenantConfig);
      final raw = box.get('theme');
      if (raw != null) {
        final config = TenantThemeConfig.fromJson(jsonDecode(raw));
        _ref.read(tenantThemeProvider.notifier).state = config;
      }
    } catch (_) {}
  }

  Future<void> _cacheProfile(Map<String, dynamic> data) async {
    try {
      final box = await Hive.openBox<String>(HiveBoxes.userSession);
      await box.put('profile', jsonEncode(data));
      if (data['tenant'] != null) {
        final configBox = await Hive.openBox<String>(HiveBoxes.tenantConfig);
        await configBox.put('theme', jsonEncode(data['tenant']));
      }
    } catch (_) {}
  }

  Future<StudentProfile?> _getCachedProfile() async {
    try {
      final box = await Hive.openBox<String>(HiveBoxes.userSession);
      final raw = box.get('profile');
      if (raw != null) {
        return StudentProfile.fromJson(jsonDecode(raw));
      }
    } catch (_) {}
    return null;
  }

  Future<void> _clearStorage() async {
    await _storage.deleteAll();
    try {
      final box = await Hive.openBox<String>(HiveBoxes.userSession);
      await box.clear();
    } catch (_) {}
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authApiProvider), ref);
});
