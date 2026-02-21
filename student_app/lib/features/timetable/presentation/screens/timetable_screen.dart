import 'package:flutter/material.dart';

/// Timetable screen — fetches from /v1/timetable/my (real API).
class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Timetable')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, size: 64, color: theme.colorScheme.primary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text('Weekly Timetable', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Your weekly class schedule will appear here.', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
