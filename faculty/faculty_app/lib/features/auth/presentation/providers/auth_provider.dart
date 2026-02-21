import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/cache_manager.dart';
import '../../data/auth_api.dart';
import '../../data/models/faculty_profile.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final FacultyProfile? profile;
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
    FacultyProfile? profile,
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
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApi _api;
  final _storage = const FlutterSecureStorage();

  AuthNotifier(this._api) : super(const AuthState());

  /// Login with credentials.
  Future<void> login({
    required String tenantSlug,
    required String identifier,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await _api.login(
        tenantSlug: tenantSlug,
        identifier: identifier,
        password: password,
      );

      if (response.success && response.data != null) {
        await _handleLoginSuccess(response.data!);
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: response.error?.message ?? 'Login failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Network error. Check your connection.',
      );
    }
  }

  /// Demo mode for development — bypasses API.
  Future<void> loginDemoMode() async {
    state = state.copyWith(status: AuthStatus.loading);
    await Future.delayed(const Duration(milliseconds: 800));

    final demoProfile = FacultyProfile(
      user: User(
        id: 'demo-faculty-001',
        tenantId: 'demo-tenant',
        email: 'lakshmi.p@campussphere.demo',
        phone: '9876543200',
        role: 'faculty',
        firstName: 'Lakshmi',
        lastName: 'P',
        isActive: true,
        createdAt: DateTime.now(),
      ),
      faculty: Faculty(
        id: 'demo-fac-001',
        tenantId: 'demo-tenant',
        userId: 'demo-faculty-001',
        employeeId: 'FAC-042',
        departmentId: 'dept-cse-001',
        designation: 'Assistant Professor',
        specialization: 'Database Systems',
        qualification: 'M.Tech CSE',
        experienceYears: 8,
        isHod: false,
        isCoordinator: true,
        coordinatorSectionId: 'sec-a-001',
      ),
      departmentName: 'Computer Science & Engineering',
      departmentCode: 'CSE',
      assignedCourses: [
        const AssignedCourse(
          courseId: 'course-dbms-001',
          courseCode: 'CS301',
          courseName: 'Database Management Systems',
          sectionId: 'sec-a-001',
          sectionName: 'CSE-3A',
          semester: 3,
        ),
        const AssignedCourse(
          courseId: 'course-dbms-001',
          courseCode: 'CS301',
          courseName: 'Database Management Systems',
          sectionId: 'sec-b-001',
          sectionName: 'CSE-3B',
          semester: 3,
        ),
        const AssignedCourse(
          courseId: 'course-dblab-001',
          courseCode: 'CS301L',
          courseName: 'DBMS Lab',
          sectionId: 'sec-a-001',
          sectionName: 'CSE-3A',
          semester: 3,
          courseType: 'lab',
        ),
      ],
    );

    state = state.copyWith(
      status: AuthStatus.authenticated,
      profile: demoProfile,
      tenantId: 'demo-tenant',
    );
  }

  /// Try to restore session from secure storage.
  Future<void> tryRestoreSession() async {
    final token = await _storage.read(key: SecureKeys.accessToken);
    if (token == null) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }

    final cached = await _getCachedProfile();
    if (cached != null) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        profile: cached,
        tenantId: cached.faculty.tenantId,
      );
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  /// Logout and clear all stored data.
  Future<void> logout() async {
    await _clearStorage();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> _handleLoginSuccess(Map<String, dynamic> data) async {
    await _storage.write(
      key: SecureKeys.accessToken,
      value: data['access_token'],
    );
    await _storage.write(
      key: SecureKeys.refreshToken,
      value: data['refresh_token'],
    );

    final profile = FacultyProfile.fromJson(data['profile']);
    await _storage.write(
      key: SecureKeys.tenantId,
      value: profile.faculty.tenantId,
    );
    await _cacheProfile(profile);

    state = state.copyWith(
      status: AuthStatus.authenticated,
      profile: profile,
      tenantId: profile.faculty.tenantId,
    );
  }

  Future<void> _cacheProfile(FacultyProfile profile) async {
    await CacheManager.put('faculty_profile', profile.toJson());
  }

  Future<FacultyProfile?> _getCachedProfile() async {
    final data = await CacheManager.get<Map<String, dynamic>>('faculty_profile');
    if (data == null) return null;
    return FacultyProfile.fromJson(data);
  }

  Future<void> _clearStorage() async {
    await _storage.deleteAll();
    await CacheManager.clearAll();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authApiProvider));
});
