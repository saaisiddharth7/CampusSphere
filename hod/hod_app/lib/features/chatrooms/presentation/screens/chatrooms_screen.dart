import 'package:flutter/material.dart';

/// Department chatrooms — HOD has read access to all dept chatrooms.
class ChatroomsScreen extends StatelessWidget {
  const ChatroomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final chatrooms = [
      {'name': 'CSE Announcements', 'type': 'one-way', 'members': 504, 'last': 'Mid-semester exam schedule posted', 'unread': 0, 'icon': Icons.campaign_rounded},
      {'name': 'CSE Faculty Room', 'type': 'faculty-only', 'members': 24, 'last': 'Dr. Arun: Invigilation duty list shared', 'unread': 3, 'icon': Icons.groups_rounded},
      {'name': 'CS301 DBMS — CSE-3A', 'type': 'subject', 'members': 53, 'last': 'Prof. Lakshmi: Unit 4 notes uploaded', 'unread': 12, 'icon': Icons.class_rounded},
      {'name': 'CS301 DBMS — CSE-3B', 'type': 'subject', 'members': 49, 'last': 'Student: Doubt about normalization', 'unread': 5, 'icon': Icons.class_rounded},
      {'name': 'CSE-3A General', 'type': 'section', 'members': 54, 'last': 'CR: Lab schedule change notice', 'unread': 0, 'icon': Icons.forum_rounded},
      {'name': 'CSE-2A — Data Structures', 'type': 'subject', 'members': 57, 'last': 'Dr. Ravi: Assignment 3 posted', 'unread': 8, 'icon': Icons.class_rounded},
      {'name': 'CSE Final Year — Projects', 'type': 'section', 'members': 156, 'last': 'Phase 2 submission deadline reminder', 'unread': 15, 'icon': Icons.engineering_rounded},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Department Chatrooms'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.visibility_rounded, size: 14, color: colorScheme.onPrimaryContainer),
                const SizedBox(width: 4),
                Text('Read-only', style: TextStyle(fontSize: 11, color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: chatrooms.length,
        itemBuilder: (context, idx) {
          final c = chatrooms[idx];
          final unread = c['unread'] as int;
          return Card(
            child: ListTile(
              leading: Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                child: Icon(c['icon'] as IconData, color: colorScheme.onPrimaryContainer),
              ),
              title: Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c['last'] as String, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('${c['members']} members • ${c['type']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                ],
              ),
              trailing: unread > 0
                  ? Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
                      child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  : null,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Viewing "${c['name']}" in read-only mode'), behavior: SnackBarBehavior.floating),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New announcement posted to CSE Announcements'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
          );
        },
        icon: const Icon(Icons.campaign_rounded),
        label: const Text('Announce'),
      ),
    );
  }
}
