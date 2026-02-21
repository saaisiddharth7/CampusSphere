import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// View past attendance records per class.
class AttendanceHistoryScreen extends ConsumerWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Demo attendance history
    final history = [
      {'date': 'Feb 23, 2026', 'section': 'CSE-3A', 'present': 45, 'total': 52, 'pct': 86.5},
      {'date': 'Feb 22, 2026', 'section': 'CSE-3B', 'present': 40, 'total': 48, 'pct': 83.3},
      {'date': 'Feb 22, 2026', 'section': 'CSE-3A', 'present': 48, 'total': 52, 'pct': 92.3},
      {'date': 'Feb 21, 2026', 'section': 'CSE-3A', 'present': 42, 'total': 52, 'pct': 80.8},
      {'date': 'Feb 20, 2026', 'section': 'CSE-3B', 'present': 38, 'total': 48, 'pct': 79.2},
      {'date': 'Feb 20, 2026', 'section': 'CSE-3A', 'present': 44, 'total': 52, 'pct': 84.6},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance History')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, idx) {
          final record = history[idx];
          final pct = record['pct'] as double;

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: pct >= 85
                    ? Colors.green.withOpacity(0.15)
                    : pct >= 75
                        ? Colors.orange.withOpacity(0.15)
                        : Colors.red.withOpacity(0.15),
                child: Text(
                  '${pct.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: pct >= 85 ? Colors.green : pct >= 75 ? Colors.orange : Colors.red,
                  ),
                ),
              ),
              title: Text(
                'DBMS — ${record['section']}',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('${record['date']} • ${record['present']}/${record['total']} present'),
            ),
          );
        },
      ),
    );
  }
}
