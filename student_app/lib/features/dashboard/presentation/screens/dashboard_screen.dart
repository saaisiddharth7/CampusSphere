import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
    // Load dashboard data from real API on mount
    Future.microtask(() {
      ref.read(dashboardProvider.notifier).loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authProvider);
    final dashboard = ref.watch(dashboardProvider);
    final profile = authState.profile;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 80,
              floating: true,
              pinned: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '👋 Hey, ${profile?.user.firstName ?? 'Student'}!',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (profile != null)
                    Text(
                      '${profile.departmentCode ?? 'CSE'} – Sem ${profile.student.currentSemester} | ${profile.student.rollNumber}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () => context.push('/notifications'),
                  icon: Badge(
                    label: Text(
                      '${dashboard.alerts?.length ?? 0}',
                      style: const TextStyle(fontSize: 10),
                    ),
                    child: const Icon(Icons.notifications_outlined),
                  ),
                ),
                IconButton(
                  onPressed: () => context.push('/profile'),
                  icon: CircleAvatar(
                    radius: 16,
                    backgroundColor: colorScheme.primaryContainer,
                    backgroundImage: profile?.user.avatarUrl != null
                        ? NetworkImage(profile!.user.avatarUrl!)
                        : null,
                    child: profile?.user.avatarUrl == null
                        ? Text(
                            profile?.user.firstName.substring(0, 1) ?? 'S',
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Dashboard Content
            if (dashboard.isLoading && dashboard.data == null)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (dashboard.error != null && dashboard.data == null)
              SliverFillRemaining(
                child: _buildErrorState(dashboard.error!),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Stat Cards Row
                    _buildStatCards(dashboard, colorScheme)
                        .animate()
                        .fadeIn(duration: 500.ms),

                    const SizedBox(height: 24),

                    // Today's Schedule
                    _buildSectionHeader('Today\'s Schedule', Icons.schedule),
                    const SizedBox(height: 12),
                    _buildScheduleList(dashboard, theme)
                        .animate()
                        .fadeIn(delay: 100.ms, duration: 500.ms),

                    const SizedBox(height: 24),

                    // Quick Actions
                    _buildSectionHeader('Quick Actions', Icons.flash_on),
                    const SizedBox(height: 12),
                    _buildQuickActions(context, colorScheme)
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 500.ms),

                    const SizedBox(height: 24),

                    // Alerts & Deadlines
                    _buildSectionHeader('Alerts', Icons.warning_amber),
                    const SizedBox(height: 12),
                    _buildAlerts(dashboard, theme)
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 500.ms),

                    const SizedBox(height: 24),

                    // AI Insights
                    _buildSectionHeader('AI Insights', Icons.smart_toy),
                    const SizedBox(height: 12),
                    _buildAiInsights(dashboard, theme, colorScheme)
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 500.ms),

                    const SizedBox(height: 32),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCards(DashboardState dashboard, ColorScheme colorScheme) {
    final attendance = dashboard.attendance;
    final nextClass = dashboard.nextClass;
    final attendancePercentage = attendance?['overall'] ?? 0.0;

    return Row(
      children: [
        // Attendance Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.primaryContainer.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📊 ${(attendancePercentage is num ? attendancePercentage : 0).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Attendance',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (attendancePercentage is num && attendancePercentage < 80)
                  Text(
                    '⚠️ Low',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Next Class Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.secondaryContainer,
                  colorScheme.secondaryContainer.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📚 Next Class',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  nextClass?['course_name'] ?? '—',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSecondaryContainer,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  nextClass?['time'] ?? '—',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSecondaryContainer.withOpacity(0.8),
                  ),
                ),
                Text(
                  '📍 ${nextClass?['room'] ?? '—'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSecondaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleList(DashboardState dashboard, ThemeData theme) {
    final schedule = dashboard.schedule;
    final entries = schedule?['entries'] as List? ?? [];

    if (entries.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'No classes scheduled today',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: entries.map<Widget>((entry) {
            final isCompleted = entry['status'] == 'completed';
            final isCurrent = entry['status'] == 'current';

            return ListTile(
              dense: true,
              leading: Text(
                entry['time'] ?? '',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isCurrent
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              title: Text(
                '${isCompleted ? '✅' : isCurrent ? '▶️' : '⬜'} ${entry['course_name'] ?? ''}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                  decoration:
                      isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: entry['room'] != null
                  ? Text('📍 ${entry['room']}')
                  : null,
              trailing: isCurrent
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'NOW',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : null,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ColorScheme colorScheme) {
    final actions = [
      _QuickAction('Mark\nAttendance', Icons.location_on, Colors.blue, '/attendance/mark'),
      _QuickAction('Pay\nFees', Icons.payment, Colors.green, '/fees'),
      _QuickAction('Submit\nAssignment', Icons.upload, Colors.orange, '/assignments'),
    ];

    return Row(
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => context.push(action.route),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: action.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: action.color.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(action.icon, color: action.color, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      action.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: action.color,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAlerts(DashboardState dashboard, ThemeData theme) {
    final alerts = dashboard.alerts ?? [];

    if (alerts.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No alerts right now 🎉',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: alerts.map<Widget>((alert) {
            final severity = alert['severity'] ?? 'info';
            final icon = severity == 'critical'
                ? '🔴'
                : severity == 'warning'
                    ? '🟠'
                    : '🔵';

            return ListTile(
              dense: true,
              title: Text(
                '$icon ${alert['message'] ?? ''}',
                style: theme.textTheme.bodyMedium,
              ),
              subtitle: alert['due_date'] != null
                  ? Text(
                      'Due: ${alert['due_date']}',
                      style: theme.textTheme.bodySmall,
                    )
                  : null,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAiInsights(
    DashboardState dashboard,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final insights = dashboard.aiInsights;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.smart_toy,
                    color: Colors.deepPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'AI-Powered Insights',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _insightRow(
              '🤖 Dropout Risk',
              insights?['dropout_risk'] ?? '—',
              insights?['dropout_risk_level'] == 'low'
                  ? Colors.green
                  : Colors.orange,
            ),
            const SizedBox(height: 8),
            _insightRow(
              '📈 Predicted CGPA',
              insights?['predicted_cgpa']?.toString() ?? '—',
              colorScheme.primary,
            ),
            const SizedBox(height: 8),
            if (insights?['focus_subject'] != null)
              _insightRow(
                '⚠️ Focus Area',
                insights!['focus_subject'],
                Colors.amber,
              ),
          ],
        ),
      ),
    );
  }

  Widget _insightRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(error, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(dashboardProvider.notifier).loadDashboard();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final String route;

  _QuickAction(this.label, this.icon, this.color, this.route);
}
