import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// HOD Dashboard — department overview with cards, quick actions, alerts.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(authProvider).user ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good Evening, Dr. ${(user['name'] as String? ?? 'HOD').split(' ').first}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            Text('${user['department'] ?? 'CSE'} • HOD',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
          ],
        ),
        actions: [
          IconButton(
            icon: Badge(
              label: const Text('5'),
              child: const Icon(Icons.notifications_rounded),
            ),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Department Stats
          Text('Department Overview', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _StatCard(icon: Icons.people_rounded, value: '480', label: 'Total Students', color: colorScheme.primary),
              _StatCard(icon: Icons.school_rounded, value: '24', label: 'Faculty Members', color: Colors.teal),
              _StatCard(icon: Icons.trending_up_rounded, value: '82.3%', label: 'Avg Attendance', color: Colors.orange),
              _StatCard(icon: Icons.warning_amber_rounded, value: '12', label: 'At-Risk Students', color: Colors.red),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Actions
          Text('Quick Actions', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
            children: [
              _QuickAction(icon: Icons.business_rounded, label: 'Dept\nAnalytics', onTap: () => context.go('/department')),
              _QuickAction(icon: Icons.people_alt_rounded, label: 'Faculty\nPerformance', onTap: () => context.go('/faculty-perf')),
              _QuickAction(icon: Icons.approval_rounded, label: 'Purchase\nApprovals', onTap: () => context.go('/approvals')),
              _QuickAction(icon: Icons.report_problem_rounded, label: 'Grievances', onTap: () => context.push('/grievances')),
              _QuickAction(icon: Icons.checklist_rounded, label: 'Dept\nAttendance', onTap: () => context.push('/attendance')),
              _QuickAction(icon: Icons.chat_rounded, label: 'Dept\nChatrooms', onTap: () => context.push('/chatrooms')),
              _QuickAction(icon: Icons.videocam_rounded, label: 'Dept\nMeetings', onTap: () => context.push('/meetings')),
              _QuickAction(icon: Icons.insights_rounded, label: 'AI\nInsights', onTap: () => context.push('/ai-insights')),
            ],
          ),
          const SizedBox(height: 24),

          // Pending Approvals
          Text('Pending Approvals', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _ApprovalTile(title: 'Lab Equipment — 20 Raspberry Pi 5', by: 'Prof. Lakshmi P', amount: '₹1,20,000', status: 'Awaiting HOD'),
                const Divider(height: 1),
                _ApprovalTile(title: 'Conference Travel — IEEE ICML', by: 'Dr. Arun K', amount: '₹85,000', status: 'Awaiting HOD'),
                const Divider(height: 1),
                _ApprovalTile(title: 'Software Licenses — JetBrains', by: 'Prof. Meera S', amount: '₹2,40,000', status: 'Awaiting HOD'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // At-Risk Students Alert
          Text('🚨 Critical Alerts', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_rounded, color: Colors.red.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text('Dropout Risk — 12 Students', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.red.shade700)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...[
                    'Deepika R (21CS104) — Risk: 92%, Att: 48%',
                    'Ganesh K (21CS107) — Risk: 87%, Att: 52%',
                    'Meera S (21CS133) — Risk: 81%, 3 backlogs',
                  ].map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• $s', style: TextStyle(fontSize: 13, color: Colors.red.shade800)),
                  )),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push('/ai-insights'),
                      child: const Text('View All At-Risk Students'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Faculty Performance Snapshot
          Text('Faculty Performance Snapshot', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _FacultyRow(name: 'Prof. Lakshmi P', score: 8.5, classes: '97%', feedback: '4.2/5'),
                const Divider(height: 1),
                _FacultyRow(name: 'Dr. Arun K', score: 9.1, classes: '100%', feedback: '4.6/5'),
                const Divider(height: 1),
                _FacultyRow(name: 'Prof. Meera S', score: 7.2, classes: '88%', feedback: '3.8/5'),
                const Divider(height: 1),
                _FacultyRow(name: 'Dr. Ravi V', score: 8.8, classes: '95%', feedback: '4.4/5'),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _StatCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const Spacer(),
                Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
              ],
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: colorScheme.primary),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _ApprovalTile extends StatelessWidget {
  final String title;
  final String by;
  final String amount;
  final String status;
  const _ApprovalTile({required this.title, required this.by, required this.amount, required this.status});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.request_page_rounded, color: Colors.orange),
      ),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      subtitle: Text('By: $by • $amount'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(status, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.orange)),
      ),
    );
  }
}

class _FacultyRow extends StatelessWidget {
  final String name;
  final double score;
  final String classes;
  final String feedback;
  const _FacultyRow({required this.name, required this.score, required this.classes, required this.feedback});

  @override
  Widget build(BuildContext context) {
    final color = score >= 8.5 ? Colors.green : (score >= 7.5 ? Colors.orange : Colors.red);
    return ListTile(
      title: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      subtitle: Text('Classes: $classes • Feedback: $feedback', style: const TextStyle(fontSize: 12)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('${score.toStringAsFixed(1)}/10', style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 13)),
      ),
    );
  }
}
