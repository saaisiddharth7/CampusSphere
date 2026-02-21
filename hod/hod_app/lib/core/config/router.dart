import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/department/presentation/screens/department_screen.dart';
import '../../features/faculty_performance/presentation/screens/faculty_performance_screen.dart';
import '../../features/approvals/presentation/screens/approvals_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/grievances/presentation/screens/grievances_screen.dart';
import '../../features/attendance/presentation/screens/attendance_overview_screen.dart';
import '../../features/chatrooms/presentation/screens/chatrooms_screen.dart';
import '../../features/meetings/presentation/screens/meetings_screen.dart';
import '../../features/ai_insights/presentation/screens/ai_insights_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../widgets/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isOnLogin = state.matchedLocation == '/login';
      if (!isLoggedIn && !isOnLogin) return '/login';
      if (isLoggedIn && isOnLogin) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // Shell route with bottom nav
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
          GoRoute(path: '/department', builder: (context, state) => const DepartmentScreen()),
          GoRoute(path: '/faculty-perf', builder: (context, state) => const FacultyPerformanceScreen()),
          GoRoute(path: '/approvals', builder: (context, state) => const ApprovalsScreen()),
          GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
        ],
      ),

      // Full-screen routes (no bottom nav)
      GoRoute(path: '/grievances', builder: (context, state) => const GrievancesScreen()),
      GoRoute(path: '/attendance', builder: (context, state) => const AttendanceOverviewScreen()),
      GoRoute(path: '/chatrooms', builder: (context, state) => const ChatroomsScreen()),
      GoRoute(path: '/meetings', builder: (context, state) => const MeetingsScreen()),
      GoRoute(path: '/ai-insights', builder: (context, state) => const AiInsightsScreen()),
      GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
    ],
  );
});
