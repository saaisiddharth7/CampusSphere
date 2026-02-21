import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Notification center screen.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final notifications = [
      {'title': 'Assignment submitted', 'body': 'Rahul Kumar submitted DB Normalization', 'time': DateTime.now().subtract(const Duration(minutes: 5)), 'read': false, 'type': 'assignment'},
      {'title': 'Low attendance alert', 'body': 'Deepika R has dropped to 48% in DBMS', 'time': DateTime.now().subtract(const Duration(hours: 1)), 'read': false, 'type': 'alert'},
      {'title': 'Meeting reminder', 'body': 'DBMS Query Optimization starts in 30 min', 'time': DateTime.now().subtract(const Duration(hours: 2)), 'read': false, 'type': 'meeting'},
      {'title': 'Assignment verified', 'body': 'You verified Priya Menon\'s submission', 'time': DateTime.now().subtract(const Duration(hours: 4)), 'read': true, 'type': 'assignment'},
      {'title': 'Chat mention', 'body': 'Arun K mentioned you in DBMS — CSE-3A', 'time': DateTime.now().subtract(const Duration(hours: 6)), 'read': true, 'type': 'chat'},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, idx) {
          final n = notifications[idx];
          final isRead = n['read'] as bool;
          final type = n['type'] as String;
          final time = n['time'] as DateTime;

          final icon = switch (type) {
            'assignment' => Icons.assignment_rounded,
            'alert' => Icons.warning_rounded,
            'meeting' => Icons.videocam_rounded,
            'chat' => Icons.chat_rounded,
            _ => Icons.notifications_rounded,
          };

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: isRead
                  ? colorScheme.surfaceContainerHighest
                  : colorScheme.primaryContainer,
              child: Icon(icon,
                  color: isRead
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onPrimaryContainer,
                  size: 20),
            ),
            title: Text(
              n['title'] as String,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
              ),
            ),
            subtitle: Text(
              n['body'] as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              timeago.format(time, locale: 'en_short'),
              style: theme.textTheme.bodySmall,
            ),
            tileColor: isRead ? null : colorScheme.primaryContainer.withOpacity(0.08),
          );
        },
      ),
    );
  }
}
