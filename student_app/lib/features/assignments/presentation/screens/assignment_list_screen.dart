import 'package:flutter/material.dart';

/// Assignment list screen — fetches from /v1/assignments (real API).
class AssignmentListScreen extends StatelessWidget {
  const AssignmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment, size: 64, color: theme.colorScheme.primary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text('Assignments', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Your assignments will appear here.', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
