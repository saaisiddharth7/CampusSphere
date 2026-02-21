import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Department-wide attendance overview — section/faculty breakdown.
class AttendanceOverviewScreen extends ConsumerWidget {
  const AttendanceOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final sections = [
      {'section': 'CSE-3A', 'faculty': 'Prof. Lakshmi P', 'students': 52, 'present': 44, 'absent': 6, 'od': 2},
      {'section': 'CSE-3B', 'faculty': 'Prof. Lakshmi P', 'students': 48, 'present': 38, 'absent': 8, 'od': 2},
      {'section': 'CSE-2A', 'faculty': 'Dr. Ravi V', 'students': 56, 'present': 48, 'absent': 7, 'od': 1},
      {'section': 'CSE-2B', 'faculty': 'Prof. Meera S', 'students': 54, 'present': 42, 'absent': 10, 'od': 2},
      {'section': 'CSE-1A', 'faculty': 'Dr. Karthik N', 'students': 60, 'present': 52, 'absent': 6, 'od': 2},
      {'section': 'CSE-1B', 'faculty': 'Prof. Deepa R', 'students': 58, 'present': 50, 'absent': 5, 'od': 3},
      {'section': 'CSE-4A', 'faculty': 'Dr. Suresh B', 'students': 78, 'present': 68, 'absent': 8, 'od': 2},
      {'section': 'CSE-4B', 'faculty': 'Dr. Arun K', 'students': 74, 'present': 62, 'absent': 10, 'od': 2},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Department Attendance'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Today's summary
          Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SumStat(label: 'Total', value: '480'),
                  _SumStat(label: 'Present', value: '404'),
                  _SumStat(label: 'Absent', value: '60'),
                  _SumStat(label: 'OD', value: '16'),
                  _SumStat(label: 'Overall', value: '84.2%'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Today — Section Wise', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...sections.map((s) {
            final total = s['students'] as int;
            final present = s['present'] as int;
            final pct = (present / total * 100);
            final pctColor = pct >= 80 ? Colors.green : (pct >= 75 ? Colors.orange : Colors.red);

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(s['section'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        const Spacer(),
                        Text('${pct.toStringAsFixed(1)}%', style: TextStyle(fontWeight: FontWeight.w800, color: pctColor, fontSize: 16)),
                      ],
                    ),
                    Text(s['faculty'] as String, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: pct / 100, minHeight: 8, backgroundColor: pctColor.withValues(alpha: 0.15), valueColor: AlwaysStoppedAnimation<Color>(pctColor)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _Badge('P: $present', Colors.green),
                        const SizedBox(width: 6),
                        _Badge('A: ${s['absent']}', Colors.red),
                        const SizedBox(width: 6),
                        _Badge('OD: ${s['od']}', Colors.blue),
                        const Spacer(),
                        Text('$total students', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _SumStat extends StatelessWidget {
  final String label;
  final String value;
  const _SumStat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
      Text(label, style: const TextStyle(fontSize: 11)),
    ],
  );
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge(this.text, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
    child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
  );
}
