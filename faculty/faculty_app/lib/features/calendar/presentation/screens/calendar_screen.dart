import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Academic calendar screen with event list and month view.
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final events = [
      {'date': 'Feb 25', 'day': 'Tue', 'title': 'Mid-Term Exams Begin', 'type': 'exam', 'scope': 'institution'},
      {'date': 'Mar 1', 'day': 'Sat', 'title': 'Faculty Development Workshop', 'type': 'workshop', 'scope': 'department'},
      {'date': 'Mar 5', 'day': 'Wed', 'title': 'Assignment Deadline: SQL Practice', 'type': 'deadline', 'scope': 'class'},
      {'date': 'Mar 8', 'day': 'Sat', 'title': 'International Women\'s Day', 'type': 'holiday', 'scope': 'institution'},
      {'date': 'Mar 10', 'day': 'Mon', 'title': 'Mid-Term Results Due', 'type': 'deadline', 'scope': 'faculty'},
      {'date': 'Mar 15', 'day': 'Sat', 'title': 'TechVista 2026 — Tech Fest', 'type': 'event', 'scope': 'institution'},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Academic Calendar'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Event',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, idx) {
          final event = events[idx];
          final type = event['type'] as String;
          final (icon, color) = switch (type) {
            'exam' => (Icons.quiz_rounded, Colors.red),
            'workshop' => (Icons.groups_rounded, Colors.blue),
            'deadline' => (Icons.timer_rounded, Colors.orange),
            'holiday' => (Icons.celebration_rounded, Colors.green),
            'event' => (Icons.event_rounded, Colors.purple),
            _ => (Icons.calendar_today_rounded, Colors.grey),
          };

          return Card(
            child: ListTile(
              leading: Container(
                width: 48,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (event['date'] as String).split(' ').last,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                    ),
                    Text(
                      event['day'] as String,
                      style: TextStyle(fontSize: 10, color: color),
                    ),
                  ],
                ),
              ),
              title: Text(
                event['title'] as String,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('${event['scope']} • ${type}'),
              trailing: Icon(icon, color: color, size: 20),
            ),
          );
        },
      ),
    );
  }
}
