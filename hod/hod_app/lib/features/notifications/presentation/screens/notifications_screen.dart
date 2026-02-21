import 'package:flutter/material.dart';

/// Notifications screen for HOD.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {'title': 'Purchase request approved by Admin', 'sub': 'Books — Database Internals. Order placed.', 'time': '2h ago', 'icon': Icons.check_circle_rounded, 'color': Colors.green, 'read': false},
      {'title': 'Grievance escalated to you', 'sub': 'Lab AC not working — raised by Rahul Kumar', 'time': '3h ago', 'icon': Icons.warning_rounded, 'color': Colors.red, 'read': false},
      {'title': 'Faculty leave request', 'sub': 'Dr. Arun K — Medical leave Feb 25-26', 'time': '5h ago', 'icon': Icons.event_busy_rounded, 'color': Colors.orange, 'read': false},
      {'title': 'New AI dropout alert', 'sub': '2 new students flagged critical risk in CSE-3A', 'time': '1d ago', 'icon': Icons.psychology_rounded, 'color': Colors.purple, 'read': true},
      {'title': 'Attendance below threshold', 'sub': 'CSE-2B avg attendance dropped to 78.3%', 'time': '1d ago', 'icon': Icons.trending_down_rounded, 'color': Colors.orange, 'read': true},
      {'title': 'NAAC meeting reminder', 'sub': 'Tomorrow, 10:00 AM — all faculty required', 'time': '2d ago', 'icon': Icons.event_rounded, 'color': Colors.blue, 'read': true},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Notifications'),
        actions: [TextButton(onPressed: () {}, child: const Text('Mark all read'))],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, idx) {
          final n = notifications[idx];
          final isRead = n['read'] as bool;
          return Card(
            color: isRead ? null : Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: ListTile(
              leading: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: (n['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(n['icon'] as IconData, color: n['color'] as Color, size: 22),
              ),
              title: Text(n['title'] as String, style: TextStyle(fontWeight: isRead ? FontWeight.w500 : FontWeight.w700, fontSize: 14)),
              subtitle: Text(n['sub'] as String, style: const TextStyle(fontSize: 12)),
              trailing: Text(n['time'] as String, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ),
          );
        },
      ),
    );
  }
}
