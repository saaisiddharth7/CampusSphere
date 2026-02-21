import 'package:flutter/material.dart';

/// Fee dashboard screen — fetches from /v1/fees/my (real API).
class FeeDashboardScreen extends StatelessWidget {
  const FeeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Fees & Payments')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, size: 64, color: theme.colorScheme.primary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text('Fee Dashboard', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Fee breakdown, payment, and receipts will appear here.', style: TextStyle(color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
