import 'package:flutter/material.dart';

/// Placeholder screen for chatroom list — will be fully implemented in Phase 3.
/// Connects to real Supabase Realtime for messaging.
/// Push notifications scoped to chatroom_members only (not all users).
class ChatroomListScreen extends StatelessWidget {
  const ChatroomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Chatrooms')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: theme.colorScheme.primary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text('Chatrooms', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Subject & class chatrooms will appear here.\nNotifications are scoped to room members only.',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
