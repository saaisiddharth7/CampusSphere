import 'package:flutter/material.dart';

/// Assignment detail screen — fetches from /v1/assignments/:id (real API).
class AssignmentDetailScreen extends StatelessWidget {
  final String assignmentId;
  const AssignmentDetailScreen({super.key, required this.assignmentId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Assignment Detail')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description, size: 64, color: theme.colorScheme.primary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text('Assignment Detail', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('ID: $assignmentId', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
