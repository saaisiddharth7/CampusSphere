import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authState = ref.read(authProvider);
      if (authState.tenantId == 'demo-tenant') {
        ref.read(dashboardProvider.notifier).loadDemoData();
      } else {
        ref.read(dashboardProvider.notifier).loadDashboard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final dashboard = ref.watch(dashboardProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good ${_greetingTime()}, ${auth.profile?.user.firstName ?? 'Professor'}! 👋',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${auth.profile?.departmentCode ?? ''} Department • ${auth.profile?.faculty.employeeId ?? ''}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Badge(
                    label: Text('${dashboard.stats?['unread_notifications'] ?? 0}'),
                    child: const Icon(Icons.notifications_outlined),
                  ),
                  onPressed: () => context.push('/notifications'),
                ),
              ],
            ),

            if (dashboard.isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Today's Classes
                    _SectionHeader(title: "📅 Today's Classes"),
                    const SizedBox(height: 8),
                    ..._buildClassCards(dashboard, theme, colorScheme),
                    const SizedBox(height: 24),

                    // Quick Actions
                    _SectionHeader(title: '⚡ Quick Actions'),
                    const SizedBox(height: 8),
                    _buildQuickActions(context, colorScheme),
                    const SizedBox(height: 24),

                    // Assignment Review Queue
                    _SectionHeader(title: '📊 Assignment Review Queue'),
                    const SizedBox(height: 8),
                    _buildReviewQueue(dashboard, theme, colorScheme),
                    const SizedBox(height: 24),

                    // Low Attendance Alerts
                    _SectionHeader(title: '⚠️ Low Attendance Alerts'),
                    const SizedBox(height: 8),
                    ..._buildAlerts(dashboard, theme, colorScheme),
                    const SizedBox(height: 24),

                    // AI Insights Summary
                    _SectionHeader(title: '🤖 AI Insights'),
                    const SizedBox(height: 8),
                    _buildAiInsights(dashboard, theme, colorScheme),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _greetingTime() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  List<Widget> _buildClassCards(
      DashboardState dashboard, ThemeData theme, ColorScheme colorScheme) {
    final classes = dashboard.todaysClasses ?? [];
    if (classes.isEmpty) {
      return [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                'No classes scheduled today 🎉',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ];
    }

    return classes.asMap().entries.map((entry) {
      final idx = entry.key;
      final cls = entry.value as Map<String, dynamic>;
      final isCurrent = cls['status'] == 'current';
      final isCompleted = cls['status'] == 'completed';

      return Card(
        color: isCurrent ? colorScheme.primaryContainer : null,
        child: ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isCurrent
                  ? colorScheme.primary
                  : isCompleted
                      ? colorScheme.surfaceContainerHighest
                      : colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCurrent
                  ? Icons.play_circle_filled_rounded
                  : isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.schedule_rounded,
              color: isCurrent
                  ? colorScheme.onPrimary
                  : colorScheme.onSecondaryContainer,
            ),
          ),
          title: Text(
            '${cls['time']}  ${cls['subject']}',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text('${cls['section']} • Room ${cls['room']}'),
          trailing: isCurrent
              ? FilledButton.tonal(
                  onPressed: () => context.push('/attendance'),
                  child: const Text('Mark'),
                )
              : isCompleted
                  ? Text(
                      '${cls['students_present']}/${cls['total_students']}',
                      style: theme.textTheme.bodySmall,
                    )
                  : null,
        ),
      ).animate().fadeIn(delay: (100 * idx).ms).slideX(begin: 0.05);
    }).toList();
  }

  Widget _buildQuickActions(BuildContext context, ColorScheme colorScheme) {
    final actions = [
      (icon: Icons.fact_check_rounded, label: 'Mark\nAttend.', route: '/attendance'),
      (icon: Icons.add_task_rounded, label: 'Add\nAssign.', route: '/assignments/create'),
      (icon: Icons.videocam_rounded, label: 'Start\nMeeting', route: '/meetings'),
      (icon: Icons.chat_rounded, label: 'Chats', route: '/chat'),
      (icon: Icons.grade_rounded, label: 'Enter\nGrades', route: '/grades'),
      (icon: Icons.analytics_rounded, label: 'AI\nInsights', route: '/ai-insights'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: actions.length,
      itemBuilder: (context, idx) {
        final action = actions[idx];
        return Card(
          child: InkWell(
            onTap: () => context.push(action.route),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  action.icon,
                  size: 28,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  action.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (80 * idx).ms).scale(begin: const Offset(0.9, 0.9));
      },
    );
  }

  Widget _buildReviewQueue(
      DashboardState dashboard, ThemeData theme, ColorScheme colorScheme) {
    final reviews = dashboard.pendingReviews;
    if (reviews == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text('No pending reviews')),
        ),
      );
    }

    final assignments = reviews['assignments'] as List? ?? [];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${reviews['total']} submissions pending',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/assignments'),
                  child: const Text('View All →'),
                ),
              ],
            ),
            const Divider(),
            ...assignments.map((a) {
              final submitted = a['submitted'] as int;
              final verified = a['verified'] as int;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${a['title']} — ${a['section']}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$submitted submitted, $verified verified, ${a['pending']} pending',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: submitted > 0 ? verified / submitted : 0,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAlerts(
      DashboardState dashboard, ThemeData theme, ColorScheme colorScheme) {
    final alerts = dashboard.attendanceAlerts ?? [];
    return alerts.asMap().entries.map((entry) {
      final idx = entry.key;
      final alert = entry.value as Map<String, dynamic>;
      final risk = alert['risk'] as String;
      final riskColor = risk == 'critical'
          ? Colors.red
          : risk == 'high'
              ? Colors.orange
              : Colors.amber;

      return Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: riskColor.withOpacity(0.15),
            child: Icon(Icons.warning_rounded, color: riskColor, size: 20),
          ),
          title: Text(
            '${alert['student_name']}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text('${alert['roll']} • ${alert['attendance_pct']}% attendance'),
          trailing: Text(
            risk.toUpperCase(),
            style: TextStyle(
              color: riskColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ).animate().fadeIn(delay: (100 * idx).ms);
    }).toList();
  }

  Widget _buildAiInsights(
      DashboardState dashboard, ThemeData theme, ColorScheme colorScheme) {
    final insights = dashboard.aiInsights;
    if (insights == null) return const SizedBox.shrink();

    return Card(
      child: InkWell(
        onTap: () => context.push('/ai-insights'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _InsightRow(
                icon: Icons.crisis_alert_rounded,
                color: Colors.red,
                label: 'Students at critical dropout risk',
                value: '${insights['dropout_risk_critical']}',
              ),
              const Divider(),
              _InsightRow(
                icon: Icons.trending_down_rounded,
                color: Colors.orange,
                label: 'Students below 75% attendance',
                value: '${insights['below_75_attendance']}',
              ),
              const Divider(),
              _InsightRow(
                icon: Icons.show_chart_rounded,
                color: Colors.amber,
                label: 'Students with declining performance',
                value: '${insights['declining_performance']}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _InsightRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
