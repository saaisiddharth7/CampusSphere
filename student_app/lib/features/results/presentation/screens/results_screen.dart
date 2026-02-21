import 'package:flutter/material.dart';

/// Results screen — fetches from /v1/results (real API).
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Academic Results')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 64, color: theme.colorScheme.primary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text('Academic Results', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('CGPA, semester grades, and rank will appear here.', style: TextStyle(color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
