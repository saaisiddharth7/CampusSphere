import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// AI Insights dashboard — dropout risk, attendance prediction, performance trends.
class AiDashboardScreen extends ConsumerWidget {
  const AiDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('AI Insights'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Risk Distribution
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dropout Risk Distribution',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _RiskBar(label: 'Low Risk (0-20)', count: 156, pct: 65, color: Colors.green),
                  _RiskBar(label: 'Moderate (20-50)', count: 52, pct: 22, color: Colors.amber),
                  _RiskBar(label: 'High Risk (50-75)', count: 22, pct: 9, color: Colors.orange),
                  _RiskBar(label: 'Critical (75-100)', count: 10, pct: 4, color: Colors.red),
                  const Divider(),
                  Text('Total: 240 students', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Critical Risk Students
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.crisis_alert_rounded, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text('Critical Risk Students',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          )),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _CriticalStudent(
                    name: 'Deepika R',
                    roll: '21CS104',
                    riskScore: 92,
                    factors: 'Att: 48%, CGPA: 4.2, Fees: 60 days overdue',
                  ),
                  _CriticalStudent(
                    name: 'Ganesh K',
                    roll: '21CS107',
                    riskScore: 87,
                    factors: 'Att: 52%, 3 backlogs, 0 assignments',
                  ),
                  _CriticalStudent(
                    name: 'Meera S',
                    roll: '21CS133',
                    riskScore: 81,
                    factors: 'Att: 58%, Fee default, No chatroom activity',
                  ),
                  const Divider(),
                  Text(
                    'Recommended Actions:',
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text('📞 Contact parent/guardian immediately', style: theme.textTheme.bodySmall),
                  Text('📋 Schedule counselor meeting', style: theme.textTheme.bodySmall),
                  Text('💰 Check scholarship eligibility', style: theme.textTheme.bodySmall),
                  Text('📊 Create personalized recovery plan', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Department Stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Department Overview',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _StatRow(label: 'Avg Attendance', value: '78.5%', trend: 'declining'),
                  _StatRow(label: 'Avg Submission Rate', value: '84.2%', trend: 'stable'),
                  _StatRow(label: 'Chat Engagement', value: '72.1%', trend: 'improving'),
                  _StatRow(label: 'Meeting Participation', value: '68.4%', trend: 'declining'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _RiskBar extends StatelessWidget {
  final String label;
  final int count;
  final int pct;
  final Color color;

  const _RiskBar({
    required this.label,
    required this.count,
    required this.pct,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(fontSize: 12))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct / 100,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text('$count ($pct%)', style: const TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _CriticalStudent extends StatelessWidget {
  final String name;
  final String roll;
  final int riskScore;
  final String factors;

  const _CriticalStudent({
    required this.name,
    required this.roll,
    required this.riskScore,
    required this.factors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.red.withOpacity(0.1),
            child: Text('$riskScore', style: const TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$name ($roll)', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text(factors, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final String trend;

  const _StatRow({required this.label, required this.value, required this.trend});

  @override
  Widget build(BuildContext context) {
    final trendIcon = switch (trend) {
      'improving' => (Icons.trending_up_rounded, Colors.green),
      'declining' => (Icons.trending_down_rounded, Colors.red),
      _ => (Icons.trending_flat_rounded, Colors.grey),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(width: 8),
          Icon(trendIcon.$1, color: trendIcon.$2, size: 16),
        ],
      ),
    );
  }
}
