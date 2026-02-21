import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Department Analytics — section-wise attendance, results, engagement comparison.
class DepartmentScreen extends ConsumerWidget {
  const DepartmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Department Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section comparison
          Text('Section Comparison', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(colorScheme.surfaceContainerHighest),
                columns: const [
                  DataColumn(label: Text('Section', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Students')),
                  DataColumn(label: Text('Att %')),
                  DataColumn(label: Text('Avg CGPA')),
                  DataColumn(label: Text('Pass %')),
                ],
                rows: [
                  _sectionRow('CSE-1A', 60, 85.2, 7.9, 96),
                  _sectionRow('CSE-1B', 58, 82.1, 7.6, 94),
                  _sectionRow('CSE-2A', 56, 80.5, 7.4, 92),
                  _sectionRow('CSE-2B', 54, 78.3, 7.1, 90),
                  _sectionRow('CSE-3A', 52, 82.3, 7.8, 95),
                  _sectionRow('CSE-3B', 48, 79.1, 7.2, 91),
                  _sectionRow('CSE-4A', 78, 86.1, 8.0, 97),
                  _sectionRow('CSE-4B', 74, 83.5, 7.7, 94),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Attendance trend bars
          Text('Attendance by Year', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...['1st Year — 83.7%', '2nd Year — 79.4%', '3rd Year — 80.7%', '4th Year — 84.8%'].asMap().entries.map((e) {
            final pct = [83.7, 79.4, 80.7, 84.8][e.key];
            final color = pct >= 80 ? Colors.green : Colors.orange;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.value.split('—').first.trim(), style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text('${pct}%', style: TextStyle(fontWeight: FontWeight.w700, color: color)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct / 100,
                          minHeight: 8,
                          backgroundColor: color.withValues(alpha: 0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 24),

          // Key metrics
          Text('Key Metrics', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _MetricTile(label: 'Placement Rate', value: '90.0%', trend: '📈 +5.2%', icon: Icons.work_rounded),
                const Divider(height: 1),
                _MetricTile(label: 'Average Package', value: '₹8.2 LPA', trend: '📈 +1.1 LPA', icon: Icons.currency_rupee_rounded),
                const Divider(height: 1),
                _MetricTile(label: 'Student-Teacher Ratio', value: '20:1', trend: '➡️ stable', icon: Icons.groups_rounded),
                const Divider(height: 1),
                _MetricTile(label: 'Fee Collection', value: '94.2%', trend: '📈 +2.3%', icon: Icons.account_balance_wallet_rounded),
                const Divider(height: 1),
                _MetricTile(label: 'Grievance Resolution', value: '88%', trend: '📈 +8%', icon: Icons.support_agent_rounded),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  DataRow _sectionRow(String sec, int students, double att, double cgpa, int pass) {
    final attColor = att >= 80 ? Colors.green : (att >= 75 ? Colors.orange : Colors.red);
    return DataRow(cells: [
      DataCell(Text(sec, style: const TextStyle(fontWeight: FontWeight.w600))),
      DataCell(Text('$students')),
      DataCell(Text('${att}%', style: TextStyle(color: attColor, fontWeight: FontWeight.w600))),
      DataCell(Text('$cgpa')),
      DataCell(Text('$pass%')),
    ]);
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  final IconData icon;
  const _MetricTile({required this.label, required this.value, required this.trend, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
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
}
