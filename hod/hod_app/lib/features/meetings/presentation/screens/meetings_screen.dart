import 'package:flutter/material.dart';

/// Department meetings — HOD + faculty meetings, all-hands.
class MeetingsScreen extends StatelessWidget {
  const MeetingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final meetings = [
      {'title': 'Monthly Faculty Review', 'type': 'Department', 'date': 'Today, 4:00 PM', 'duration': '60 min', 'status': 'upcoming', 'attendees': 24},
      {'title': 'Curriculum Committee — Sem 4', 'type': 'Committee', 'date': 'Feb 24, 11:00 AM', 'duration': '90 min', 'status': 'upcoming', 'attendees': 8},
      {'title': 'Lab Equipment Budget Discussion', 'type': 'Department', 'date': 'Feb 19, 3:00 PM', 'duration': '45 min', 'status': 'completed', 'attendees': 12},
      {'title': 'NAAC Preparation Meeting', 'type': 'All-Hands', 'date': 'Feb 15, 10:00 AM', 'duration': '120 min', 'status': 'completed', 'attendees': 24},
      {'title': 'Placement Coordination', 'type': 'Committee', 'date': 'Feb 10, 2:00 PM', 'duration': '60 min', 'status': 'completed', 'attendees': 6},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Department Meetings'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: meetings.length,
        itemBuilder: (context, idx) {
          final m = meetings[idx];
          final isUpcoming = m['status'] == 'upcoming';

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: isUpcoming ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      m['type'] == 'All-Hands' ? Icons.groups_3_rounded : (m['type'] == 'Committee' ? Icons.people_rounded : Icons.videocam_rounded),
                      color: isUpcoming ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text('${m['type']} • ${m['date']} • ${m['duration']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        Text('${m['attendees']} attendees', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                  if (isUpcoming)
                    FilledButton(onPressed: () {}, child: const Text('Start'))
                  else
                    OutlinedButton(onPressed: () {}, child: const Text('Watch')),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('Schedule'),
      ),
    );
  }
}
