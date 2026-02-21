import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Faculty timetable — day-by-day teaching schedule.
class TimetableScreen extends ConsumerWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final today = DateTime.now().weekday - 1; // 0 = Monday

    final timetable = <String, List<Map<String, String>>>{
      'Mon': [
        {'time': '10:00 - 10:50', 'subject': 'DBMS', 'section': 'CSE-3A', 'room': '302', 'type': 'theory'},
        {'time': '11:00 - 11:50', 'subject': 'DBMS', 'section': 'CSE-3B', 'room': '302', 'type': 'theory'},
      ],
      'Tue': [
        {'time': '09:00 - 09:50', 'subject': 'DBMS', 'section': 'CSE-3A', 'room': '302', 'type': 'theory'},
        {'time': '14:00 - 16:00', 'subject': 'DBMS Lab', 'section': 'CSE-3A', 'room': 'CL-2', 'type': 'lab'},
      ],
      'Wed': [
        {'time': '10:00 - 10:50', 'subject': 'DBMS', 'section': 'CSE-3B', 'room': '302', 'type': 'theory'},
      ],
      'Thu': [
        {'time': '10:00 - 10:50', 'subject': 'DBMS', 'section': 'CSE-3A', 'room': '302', 'type': 'theory'},
        {'time': '11:00 - 11:50', 'subject': 'DBMS', 'section': 'CSE-3B', 'room': '302', 'type': 'theory'},
      ],
      'Fri': [
        {'time': '09:00 - 09:50', 'subject': 'DBMS', 'section': 'CSE-3B', 'room': '302', 'type': 'theory'},
        {'time': '14:00 - 16:00', 'subject': 'DBMS Lab', 'section': 'CSE-3A', 'room': 'CL-2', 'type': 'lab'},
      ],
      'Sat': [],
    };

    return DefaultTabController(
      length: days.length,
      initialIndex: today.clamp(0, 5),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Teaching Schedule'),
          bottom: TabBar(
            isScrollable: true,
            tabs: days.asMap().entries.map((e) {
              return Tab(
                child: Text(
                  e.value,
                  style: TextStyle(
                    fontWeight: e.key == today ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: days.map((day) {
            final periods = timetable[day] ?? [];
            if (periods.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.weekend_rounded, size: 64, color: colorScheme.outlineVariant),
                    const SizedBox(height: 16),
                    Text('No classes on $day', style: theme.textTheme.bodyLarge),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: periods.length,
              itemBuilder: (context, idx) {
                final period = periods[idx];
                final isLab = period['type'] == 'lab';

                return Card(
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isLab
                            ? colorScheme.tertiaryContainer
                            : colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isLab ? Icons.computer_rounded : Icons.menu_book_rounded,
                        color: isLab
                            ? colorScheme.onTertiaryContainer
                            : colorScheme.onPrimaryContainer,
                      ),
                    ),
                    title: Text(
                      '${period['subject']} — ${period['section']}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text('${period['time']} • Room ${period['room']}'),
                    trailing: isLab
                        ? Chip(
                            label: const Text('Lab', style: TextStyle(fontSize: 11)),
                            side: BorderSide.none,
                            backgroundColor: colorScheme.tertiaryContainer,
                            visualDensity: VisualDensity.compact,
                          )
                        : null,
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
