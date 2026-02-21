import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Chatroom list — faculty's subject chatrooms (moderator view).
class ChatroomListScreen extends ConsumerWidget {
  const ChatroomListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final chatrooms = [
      {'id': 'chat-1', 'name': 'DBMS — CSE-3A', 'members': 53, 'unread': 12, 'last_msg': 'Rahul: Query about normalization...', 'time': '5m'},
      {'id': 'chat-2', 'name': 'DBMS — CSE-3B', 'members': 49, 'unread': 3, 'last_msg': 'Priya: When is the next lab?', 'time': '1h'},
      {'id': 'chat-3', 'name': 'DBMS Lab — CSE-3A', 'members': 53, 'unread': 0, 'last_msg': 'You: Lab 5 uploaded to materials', 'time': '2h'},
      {'id': 'chat-4', 'name': 'CSE Department', 'members': 148, 'unread': 5, 'last_msg': 'HOD: Faculty meeting tomorrow at 4 PM', 'time': '3h'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Chatrooms')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: chatrooms.length,
        itemBuilder: (context, idx) {
          final chat = chatrooms[idx];
          final unread = chat['unread'] as int;

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.forum_rounded,
                color: colorScheme.onPrimaryContainer,
                size: 20,
              ),
            ),
            title: Text(
              chat['name'] as String,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: unread > 0 ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            subtitle: Text(
              chat['last_msg'] as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: unread > 0 ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat['time'] as String, style: theme.textTheme.bodySmall),
                if (unread > 0) ...[
                  const SizedBox(height: 4),
                  Badge(
                    label: Text('$unread'),
                    backgroundColor: colorScheme.primary,
                  ),
                ],
              ],
            ),
            onTap: () => context.push('/chat/${chat['id']}'),
          );
        },
      ),
    );
  }
}
