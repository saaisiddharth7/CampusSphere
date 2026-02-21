import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AI Insights Dashboard — HOD-level department-wide dropout risk + analytics.
class AiInsightsScreen extends ConsumerWidget {
  const AiInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('AI Insights'),
        actions: [TextButton.icon(onPressed: () {}, icon: const Icon(Icons.download_rounded, size: 18), label: const Text('Export'))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Risk distribution
          Text('Dropout Risk Distribution', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              _RiskCard('Low\n0-20%', 156, Colors.green),
              const SizedBox(width: 8),
              _RiskCard('Moderate\n20-50%', 52, Colors.orange),
              const SizedBox(width: 8),
              _RiskCard('High\n50-75%', 22, const Color(0xFFf97316)),
              const SizedBox(width: 8),
              _RiskCard('Critical\n75-100%', 10, Colors.red),
            ],
          ),
          const SizedBox(height: 24),

          // Critical students
          Text('🚨 Critical Risk Students', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 12),
          ...[
            {'name': 'Deepika R', 'roll': '21CS104', 'risk': 92, 'factors': 'Att: 48%, CGPA: 4.2, Fees: 60 days overdue'},
            {'name': 'Ganesh K', 'roll': '21CS107', 'risk': 87, 'factors': 'Att: 52%, 3 backlogs, 0 assignments submitted'},
            {'name': 'Meera S', 'roll': '21CS133', 'risk': 81, 'factors': 'Att: 58%, Fee default, No chatroom activity'},
            {'name': 'Vijay T', 'roll': '21CS145', 'risk': 78, 'factors': 'Att: 62%, 2 backlogs, Declining CGPA'},
          ].map((s) => Card(
            color: Colors.red.shade50,
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Colors.red, child: Text('${s['risk']}%', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
              title: Text('${s['name']}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Text('${s['roll']} • ${s['factors']}', style: const TextStyle(fontSize: 12)),
              trailing: IconButton(icon: const Icon(Icons.phone_rounded, color: Colors.red), onPressed: () {}),
            ),
          )),
          const SizedBox(height: 24),

          // Recommended actions
          Text('📋 Recommended Actions', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _ActionTile(icon: Icons.phone_rounded, text: 'Contact parent/guardian for 10 critical risk students', color: Colors.red),
                const Divider(height: 1),
                _ActionTile(icon: Icons.event_rounded, text: 'Schedule counselor meetings for 22 high-risk students', color: Colors.orange),
                const Divider(height: 1),
                _ActionTile(icon: Icons.account_balance_wallet_rounded, text: 'Check scholarship eligibility for 5 fee defaulters', color: Colors.blue),
                const Divider(height: 1),
                _ActionTile(icon: Icons.assignment_rounded, text: 'Create personalized recovery plans for top 15 at-risk', color: Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Department trends
          Text('📊 Department Trends', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _TrendTile(label: 'Avg Attendance', value: '82.3%', trend: '📉 -1.8% from last month'),
                const Divider(height: 1),
                _TrendTile(label: 'Assignment Submission', value: '84.2%', trend: '➡️ Stable'),
                const Divider(height: 1),
                _TrendTile(label: 'Chat Engagement', value: '72.1%', trend: '📈 +5.3% from last month'),
                const Divider(height: 1),
                _TrendTile(label: 'Meeting Participation', value: '68.4%', trend: '📉 -3.1%'),
                const Divider(height: 1),
                _TrendTile(label: 'Placement Rate (4th yr)', value: '90.0%', trend: '📈 +5.2% YoY'),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _RiskCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _RiskCard(this.label, this.count, this.color);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Card(
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border(left: BorderSide(color: color, width: 4)), borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text('$count', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    ),
  );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _ActionTile({required this.icon, required this.text, required this.color});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: color, size: 22),
    title: Text(text, style: const TextStyle(fontSize: 13)),
  );
}

class _TrendTile extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  const _TrendTile({required this.label, required this.value, required this.trend});
  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(label, style: const TextStyle(fontSize: 13)),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        Text(trend, style: const TextStyle(fontSize: 11)),
      ],
    ),
  );
}
