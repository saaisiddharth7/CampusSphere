import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Demo HOD profile for local development.
class AuthState {
  final AuthStatus status;
  final Map<String, dynamic>? user;
  AuthState({required this.status, this.user});
}

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(status: AuthStatus.unauthenticated));

  void loginDemo() {
    state = AuthState(
      status: AuthStatus.authenticated,
      user: {
        'id': 'hod-001',
        'name': 'Dr. Venkat R',
        'email': 'venkat.r@campussphere.demo',
        'role': 'hod',
        'department': 'Computer Science & Engineering',
        'department_id': 'dept-cse',
        'designation': 'Professor & Head',
        'employee_id': 'FAC-001',
        'phone': '9876500100',
        'specialization': 'Machine Learning & Data Science',
        'qualification': 'Ph.D. CSE (IIT Madras)',
        'experience': '18 years',
        'faculty_count': 24,
        'student_count': 480,
        'sections': ['CSE-1A','CSE-1B','CSE-2A','CSE-2B','CSE-3A','CSE-3B','CSE-4A','CSE-4B'],
      },
    );
  }

  void logout() {
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
