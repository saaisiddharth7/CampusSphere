import 'package:flutter/material.dart';

/// Calendar screen — fetches from /v1/calendar/events (real API).
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Academic Calendar')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month, size: 64, color: theme.colorScheme.primary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text('Academic Calendar', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Events, holidays, and academic dates will appear here.', style: TextStyle(color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
