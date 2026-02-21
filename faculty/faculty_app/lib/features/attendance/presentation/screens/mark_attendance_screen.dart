import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Attendance marking screen — faculty marks P/A/OD/ML/Late per student.
class MarkAttendanceScreen extends ConsumerStatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  ConsumerState<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends ConsumerState<MarkAttendanceScreen> {
  String _selectedCourse = 'DBMS (CS301) — CSE-3A';
  final Map<String, String> _attendance = {}; // studentId -> status

  // Demo student list
  final List<Map<String, dynamic>> _students = [
    {'id': '1', 'roll': '21CS101', 'name': 'Rahul Kumar', 'att_pct': 78.5},
    {'id': '2', 'roll': '21CS102', 'name': 'Priya Menon', 'att_pct': 92.1},
    {'id': '3', 'roll': '21CS103', 'name': 'Arun Krishnan', 'att_pct': 85.0},
    {'id': '4', 'roll': '21CS104', 'name': 'Deepika R', 'att_pct': 48.0},
    {'id': '5', 'roll': '21CS105', 'name': 'Suresh V', 'att_pct': 80.5},
    {'id': '6', 'roll': '21CS106', 'name': 'Anita S', 'att_pct': 88.0},
    {'id': '7', 'roll': '21CS107', 'name': 'Ganesh K', 'att_pct': 52.0},
    {'id': '8', 'roll': '21CS108', 'name': 'Divya P', 'att_pct': 90.0},
    {'id': '9', 'roll': '21CS109', 'name': 'Karthik M', 'att_pct': 76.0},
    {'id': '10', 'roll': '21CS110', 'name': 'Sneha B', 'att_pct': 84.0},
  ];

  @override
  void initState() {
    super.initState();
    // Default all to Present
    for (final s in _students) {
      _attendance[s['id']] = 'P';
    }
  }

  int get _presentCount =>
      _attendance.values.where((s) => s == 'P' || s == 'Late').length;
  int get _absentCount => _attendance.values.where((s) => s == 'A').length;

  void _markAllPresent() {
    setState(() {
      for (final s in _students) {
        _attendance[s['id']] = 'P';
      }
    });
  }

  void _submitAttendance() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 48),
        title: const Text('Attendance Submitted'),
        content: Text(
          'Present: $_presentCount | Absent: $_absentCount\nTotal: ${_students.length} students',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
        actions: [
          TextButton.icon(
            onPressed: _markAllPresent,
            icon: const Icon(Icons.done_all_rounded),
            label: const Text('All Present'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Course selector
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: _selectedCourse,
              decoration: const InputDecoration(
                labelText: 'Class',
                prefixIcon: Icon(Icons.class_rounded),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'DBMS (CS301) — CSE-3A',
                  child: Text('DBMS (CS301) — CSE-3A'),
                ),
                DropdownMenuItem(
                  value: 'DBMS (CS301) — CSE-3B',
                  child: Text('DBMS (CS301) — CSE-3B'),
                ),
                DropdownMenuItem(
                  value: 'DBMS Lab (CS301L) — CSE-3A',
                  child: Text('DBMS Lab (CS301L) — CSE-3A'),
                ),
              ],
              onChanged: (v) => setState(() => _selectedCourse = v!),
            ),
          ),

          // Stats bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatChip(label: 'Total', value: '${_students.length}', color: colorScheme.primary),
                _StatChip(label: 'Present', value: '$_presentCount', color: Colors.green),
                _StatChip(label: 'Absent', value: '$_absentCount', color: Colors.red),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Student list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _students.length,
              itemBuilder: (context, idx) {
                final student = _students[idx];
                final status = _attendance[student['id']] ?? 'P';
                final attPct = student['att_pct'] as double;
                final isLow = attPct < 75;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        // Roll + Name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    student['roll'],
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  if (isLow) ...[
                                    const SizedBox(width: 4),
                                    Icon(Icons.warning_rounded,
                                        color: Colors.orange, size: 14),
                                  ],
                                ],
                              ),
                              Text(
                                student['name'],
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${attPct.toStringAsFixed(1)}% overall',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isLow ? Colors.red : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Status buttons
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'P', label: Text('P')),
                            ButtonSegment(value: 'A', label: Text('A')),
                            ButtonSegment(value: 'OD', label: Text('OD')),
                          ],
                          selected: {status},
                          onSelectionChanged: (Set<String> s) {
                            setState(() => _attendance[student['id']] = s.first);
                          },
                          showSelectedIcon: false,
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: (40 * idx).ms);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _submitAttendance,
            icon: const Icon(Icons.check_rounded),
            label: Text('Submit Attendance ($_presentCount/${_students.length})'),
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
