import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/dashboard_api.dart';

/// Dashboard state holding the aggregated snapshot data.
class DashboardState {
  final bool isLoading;
  final Map<String, dynamic>? data;
  final String? error;

  const DashboardState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  DashboardState copyWith({
    bool? isLoading,
    Map<String, dynamic>? data,
    String? error,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }

  // Convenience getters
  List? get todaysClasses => data?['todays_classes'] as List?;
  Map<String, dynamic>? get pendingReviews =>
      data?['pending_reviews'] as Map<String, dynamic>?;
  List? get attendanceAlerts => data?['attendance_alerts'] as List?;
  Map<String, dynamic>? get aiInsights =>
      data?['ai_insights'] as Map<String, dynamic>?;
  Map<String, dynamic>? get stats => data?['stats'] as Map<String, dynamic>?;
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardApi _api;

  DashboardNotifier(this._api) : super(const DashboardState());

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _api.getDashboard();
      if (response.success && response.data != null) {
        state = state.copyWith(isLoading: false, data: response.data);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.error?.message ?? 'Failed to load dashboard',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error. Pull to refresh.',
      );
    }
  }

  /// Load demo data for development.
  void loadDemoData() {
    state = state.copyWith(
      isLoading: false,
      data: _demoData,
    );
  }

  Future<void> refresh() async => await loadDashboard();

  static final _demoData = <String, dynamic>{
    'todays_classes': [
      {
        'id': 'class-1',
        'time': '10:00 AM',
        'subject': 'DBMS',
        'course_code': 'CS301',
        'section': 'CSE-3A',
        'room': '302',
        'status': 'current', // current, upcoming, completed
        'students_present': 45,
        'total_students': 52,
      },
      {
        'id': 'class-2',
        'time': '11:00 AM',
        'subject': 'DBMS',
        'course_code': 'CS301',
        'section': 'CSE-3B',
        'room': '302',
        'status': 'upcoming',
        'students_present': 0,
        'total_students': 48,
      },
      {
        'id': 'class-3',
        'time': '02:00 PM',
        'subject': 'DBMS Lab',
        'course_code': 'CS301L',
        'section': 'CSE-3A',
        'room': 'CL-2',
        'status': 'upcoming',
        'students_present': 0,
        'total_students': 52,
      },
    ],
    'pending_reviews': {
      'total': 26,
      'assignments': [
        {
          'title': 'DB Normalization',
          'course': 'DBMS (CS301)',
          'section': 'CSE-3A',
          'submitted': 38,
          'verified': 12,
          'pending': 26,
        },
      ],
    },
    'attendance_alerts': [
      {
        'student_name': 'Deepika R',
        'roll': '21CS104',
        'attendance_pct': 48.0,
        'risk': 'critical',
      },
      {
        'student_name': 'Ganesh K',
        'roll': '21CS107',
        'attendance_pct': 52.0,
        'risk': 'high',
      },
      {
        'student_name': 'Meera S',
        'roll': '21CS133',
        'attendance_pct': 68.0,
        'risk': 'medium',
      },
    ],
    'stats': {
      'total_classes_today': 3,
      'avg_attendance': 82.3,
      'pending_assignments': 26,
      'meetings_today': 1,
      'unread_notifications': 5,
    },
    'ai_insights': {
      'dropout_risk_critical': 3,
      'below_75_attendance': 8,
      'declining_performance': 5,
    },
  };
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(ref.watch(dashboardApiProvider));
});
