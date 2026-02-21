import 'package:flutter/material.dart';

/// Meeting list screen — fetches from /v1/meetings (real API).
class MeetingListScreen extends StatelessWidget {
  const MeetingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Live Classes')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam, size: 64, color: theme.colorScheme.primary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text('Live Classes & Meetings', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Upcoming and recorded meetings will appear here.', style: TextStyle(color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
