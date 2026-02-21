import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/attendance/presentation/screens/attendance_hub_screen.dart';
import '../../features/attendance/presentation/screens/mark_attendance_screen.dart';
import '../../features/chat/presentation/screens/chatroom_list_screen.dart';
import '../../features/timetable/presentation/screens/timetable_screen.dart';
import '../../features/assignments/presentation/screens/assignment_list_screen.dart';
import '../../features/assignments/presentation/screens/assignment_detail_screen.dart';
import '../../features/fees/presentation/screens/fee_dashboard_screen.dart';
import '../../features/results/presentation/screens/results_screen.dart';
import '../../features/meetings/presentation/screens/meeting_list_screen.dart';
import '../../features/calendar/presentation/screens/calendar_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../widgets/app_shell.dart';

/// GoRouter configuration with bottom nav shell and auth guard.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/home',
    redirect: (context, state) {
      final isAuth = authState.isAuthenticated;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isAuth && !isLoginRoute) return '/login';
      if (isAuth && isLoginRoute) return '/home';
      return null;
    },
    routes: [
      // Login
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Main Shell with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          // Tab 0: Home / Dashboard
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),

          // Tab 1: Calendar
          GoRoute(
            path: '/calendar',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CalendarScreen(),
            ),
          ),

          // Tab 2: Attendance
          GoRoute(
            path: '/attendance',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AttendanceHubScreen(),
            ),
            routes: [
              GoRoute(
                path: 'mark',
                builder: (context, state) => const MarkAttendanceScreen(),
              ),
            ],
          ),

          // Tab 3: Chat
          GoRoute(
            path: '/chat',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChatroomListScreen(),
            ),
          ),

          // Tab 4: More
          GoRoute(
            path: '/more',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _MoreScreen(),
            ),
          ),
        ],
      ),

      // Non-tabbed routes (pushed on top of shell)
      GoRoute(
        path: '/timetable',
        builder: (context, state) => const TimetableScreen(),
      ),
      GoRoute(
        path: '/assignments',
        builder: (context, state) => const AssignmentListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) => AssignmentDetailScreen(
              assignmentId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/fees',
        builder: (context, state) => const FeeDashboardScreen(),
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) => const ResultsScreen(),
      ),
      GoRoute(
        path: '/meetings',
        builder: (context, state) => const MeetingListScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});

/// "More" tab showing grid of all modules.
class _MoreScreen extends StatelessWidget {
  const _MoreScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final modules = [
      _ModuleItem('Timetable', Icons.schedule, '/timetable', Colors.blue),
      _ModuleItem('Assignments', Icons.assignment, '/assignments', Colors.orange),
      _ModuleItem('Fees', Icons.payment, '/fees', Colors.green),
      _ModuleItem('Results', Icons.bar_chart, '/results', Colors.purple),
      _ModuleItem('Meetings', Icons.videocam, '/meetings', Colors.red),
      _ModuleItem('Exams', Icons.quiz, '/exams', Colors.indigo),
      _ModuleItem('Materials', Icons.menu_book, '/materials', Colors.teal),
      _ModuleItem('Hostel', Icons.hotel, '/hostel', Colors.brown),
      _ModuleItem('Events', Icons.celebration, '/events', Colors.pink),
      _ModuleItem('Grievance', Icons.report_problem, '/grievance', Colors.amber),
      _ModuleItem('Polls', Icons.poll, '/polls', Colors.cyan),
      _ModuleItem('Placement', Icons.work, '/placement', Colors.deepOrange),
      _ModuleItem('Internship', Icons.school, '/internship', Colors.lime),
      _ModuleItem('AI Bot', Icons.smart_toy, '/chatbot', Colors.deepPurple),
      _ModuleItem('Profile', Icons.person, '/profile', Colors.blueGrey),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        actions: [
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_outlined),
            ),
          ),
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          return _buildModuleCard(context, module, theme);
        },
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    _ModuleItem module,
    ThemeData theme,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(module.route),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: module.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  module.icon,
                  color: module.color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                module.label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleItem {
  final String label;
  final IconData icon;
  final String route;
  final Color color;

  _ModuleItem(this.label, this.icon, this.route, this.color);
}
