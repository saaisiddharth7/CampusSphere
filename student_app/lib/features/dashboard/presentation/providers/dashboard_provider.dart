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

  // Convenience getters for dashboard sections
  Map<String, dynamic>? get schedule =>
      data?['schedule'] as Map<String, dynamic>?;
  Map<String, dynamic>? get attendance =>
      data?['attendance'] as Map<String, dynamic>?;
  List? get alerts => data?['alerts'] as List?;
  Map<String, dynamic>? get aiInsights =>
      data?['ai_insights'] as Map<String, dynamic>?;
  Map<String, dynamic>? get nextClass =>
      data?['next_class'] as Map<String, dynamic>?;
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardApi _api;

  DashboardNotifier(this._api) : super(const DashboardState());

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _api.getDashboard();
      if (response.success && response.data != null) {
        state = state.copyWith(
          isLoading: false,
          data: response.data,
        );
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

  Future<void> refresh() async {
    await loadDashboard();
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(ref.watch(dashboardApiProvider));
});
