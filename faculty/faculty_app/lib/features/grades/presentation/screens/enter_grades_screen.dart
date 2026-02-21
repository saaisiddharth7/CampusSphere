import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Grade entry screen — faculty enters marks per student.
class EnterGradesScreen extends ConsumerWidget {
  const EnterGradesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final students = [
      {'roll': '21CS101', 'name': 'Rahul Kumar', 'internal': 42, 'external': 52, 'grade': 'A'},
      {'roll': '21CS102', 'name': 'Priya Menon', 'internal': 44, 'external': 51, 'grade': 'A+'},
      {'roll': '21CS103', 'name': 'Arun Krishnan', 'internal': 38, 'external': 48, 'grade': 'A'},
      {'roll': '21CS104', 'name': 'Deepika R', 'internal': 22, 'external': 28, 'grade': 'C'},
      {'roll': '21CS105', 'name': 'Suresh V', 'internal': 36, 'external': 44, 'grade': 'B+'},
      {'roll': '21CS106', 'name': 'Anita S', 'internal': 40, 'external': 50, 'grade': 'A'},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Enter Grades'),
        actions: [
          FilledButton.tonal(
            onPressed: () {},
            child: const Text('Save'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Course info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: colorScheme.surfaceContainerLow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DBMS (CS301) — CSE-3A',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                Text('Semester 3 | Internal (50) + External (50) = Total (100)',
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),

          // Grade table
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(0.8),
                },
                border: TableBorder.all(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                    children: const [
                      _TableHeader('Roll'),
                      _TableHeader('Name'),
                      _TableHeader('Int'),
                      _TableHeader('Ext'),
                      _TableHeader('Grade'),
                    ],
                  ),
                  ...students.map((s) {
                    final grade = s['grade'] as String;
                    return TableRow(
                      children: [
                        _TableCell(s['roll'] as String),
                        _TableCell(s['name'] as String),
                        _TableCell('${s['internal']}'),
                        _TableCell('${s['external']}'),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Chip(
                              label: Text(grade, style: const TextStyle(fontSize: 11)),
                              backgroundColor: _gradeColor(grade),
                              side: BorderSide.none,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Color _gradeColor(String grade) {
    return switch (grade) {
      'A+' || 'A' => Colors.green.withOpacity(0.15),
      'B+' || 'B' => Colors.blue.withOpacity(0.15),
      'C' || 'D' => Colors.orange.withOpacity(0.15),
      _ => Colors.grey.withOpacity(0.15),
    };
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  const _TableCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(child: Text(text, style: const TextStyle(fontSize: 12))),
    );
  }
}
