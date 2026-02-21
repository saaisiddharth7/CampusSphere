import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/attendance/presentation/screens/mark_attendance_screen.dart';
import '../../features/attendance/presentation/screens/attendance_history_screen.dart';
import '../../features/assignments/presentation/screens/assignment_list_screen.dart';
import '../../features/assignments/presentation/screens/create_assignment_screen.dart';
import '../../features/assignments/presentation/screens/submissions_screen.dart';
import '../../features/timetable/presentation/screens/timetable_screen.dart';
import '../../features/chat/presentation/screens/chatroom_list_screen.dart';
import '../../features/chat/presentation/screens/chatroom_screen.dart';
import '../../features/meetings/presentation/screens/meeting_list_screen.dart';
import '../../features/materials/presentation/screens/materials_list_screen.dart';
import '../../features/grades/presentation/screens/enter_grades_screen.dart';
import '../../features/calendar/presentation/screens/calendar_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/ai_insights/presentation/screens/ai_dashboard_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../widgets/app_shell.dart';

/// GoRouter configuration with auth redirect.
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
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Shell route for bottom navigation
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/timetable',
            builder: (context, state) => const TimetableScreen(),
          ),
          GoRoute(
            path: '/attendance',
            builder: (context, state) => const MarkAttendanceScreen(),
          ),
          GoRoute(
            path: '/attendance/history',
            builder: (context, state) => const AttendanceHistoryScreen(),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => const ChatroomListScreen(),
          ),
          GoRoute(
            path: '/chat/:chatroomId',
            builder: (context, state) => ChatroomScreen(
              chatroomId: state.pathParameters['chatroomId']!,
            ),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Full-screen routes (no bottom nav)
      GoRoute(
        path: '/assignments',
        builder: (context, state) => const AssignmentListScreen(),
      ),
      GoRoute(
        path: '/assignments/create',
        builder: (context, state) => const CreateAssignmentScreen(),
      ),
      GoRoute(
        path: '/assignments/:id/submissions',
        builder: (context, state) => SubmissionsScreen(
          assignmentId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/meetings',
        builder: (context, state) => const MeetingListScreen(),
      ),
      GoRoute(
        path: '/materials',
        builder: (context, state) => const MaterialsListScreen(),
      ),
      GoRoute(
        path: '/grades',
        builder: (context, state) => const EnterGradesScreen(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/ai-insights',
        builder: (context, state) => const AiDashboardScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
});
