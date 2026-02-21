import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'live_meeting_screen.dart';
import 'watch_recording_screen.dart';

/// Meeting list — upcoming and past meetings/live classes with full navigation.
class MeetingListScreen extends ConsumerStatefulWidget {
  const MeetingListScreen({super.key});

  @override
  ConsumerState<MeetingListScreen> createState() => _MeetingListScreenState();
}

class _MeetingListScreenState extends ConsumerState<MeetingListScreen> {
  List<Map<String, dynamic>> meetings = [
    {
      'id': 'meet-1',
      'title': 'DBMS — Query Optimization',
      'section': 'CSE-3A',
      'date': 'Today, 3:00 PM',
      'duration': '60 min',
      'status': 'upcoming',
      'participants': 0,
    },
    {
      'id': 'meet-2',
      'title': 'DBMS Lab — Joins Tutorial',
      'section': 'CSE-3A',
      'date': 'Feb 23, 10:00 AM',
      'duration': '42 min',
      'status': 'completed',
      'participants': 48,
    },
    {
      'id': 'meet-3',
      'title': 'DBMS — ER Diagrams Revision',
      'section': 'CSE-3B',
      'date': 'Feb 20, 2:00 PM',
      'duration': '35 min',
      'status': 'completed',
      'participants': 44,
    },
  ];

  void _startMeeting(Map<String, dynamic> meeting) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => LiveMeetingScreen(
          meetingId: meeting['id'] as String,
          title: meeting['title'] as String,
          section: meeting['section'] as String,
        ),
      ),
    );

    // When meeting ends, move it to completed
    if (result == true && mounted) {
      setState(() {
        final idx = meetings.indexWhere((m) => m['id'] == meeting['id']);
        if (idx >= 0) {
          meetings[idx] = {
            ...meetings[idx],
            'status': 'completed',
            'participants': 8,
            'duration': '${DateTime.now().difference(DateTime.now()).inMinutes.abs()} min',
          };
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 12),
                Text('Meeting ended. Recording saved.'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _watchRecording(Map<String, dynamic> meeting) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WatchRecordingScreen(
          meetingId: meeting['id'] as String,
          title: meeting['title'] as String,
          section: meeting['section'] as String,
          date: meeting['date'] as String,
          duration: meeting['duration'] as String,
          participants: meeting['participants'] as int,
        ),
      ),
    );
  }

  void _showScheduleDialog() {
    final titleCtrl = TextEditingController();
    String selectedCourse = 'DBMS (CS301) — CSE-3A';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);
    int durationMins = 60;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final theme = Theme.of(ctx);
            final colorScheme = theme.colorScheme;

            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Schedule Meeting',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                      labelText: 'Meeting Title',
                      hintText: 'e.g., DBMS — Unit 4 Revision',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.title_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Course
                  DropdownButtonFormField<String>(
                    value: selectedCourse,
                    decoration: InputDecoration(
                      labelText: 'Course & Section',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.school_rounded),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'DBMS (CS301) — CSE-3A', child: Text('DBMS (CS301) — CSE-3A')),
                      DropdownMenuItem(value: 'DBMS (CS301) — CSE-3B', child: Text('DBMS (CS301) — CSE-3B')),
                      DropdownMenuItem(value: 'DBMS Lab (CS301L) — CSE-3A', child: Text('DBMS Lab (CS301L) — CSE-3A')),
                    ],
                    onChanged: (v) => setSheetState(() => selectedCourse = v!),
                  ),
                  const SizedBox(height: 16),

                  // Date & Time row
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final d = await showDatePicker(
                              context: ctx,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 90)),
                            );
                            if (d != null) setSheetState(() => selectedDate = d);
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: const Icon(Icons.calendar_today_rounded),
                            ),
                            child: Text(
                              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final t = await showTimePicker(
                              context: ctx,
                              initialTime: selectedTime,
                            );
                            if (t != null) setSheetState(() => selectedTime = t);
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Time',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: const Icon(Icons.access_time_rounded),
                            ),
                            child: Text(
                              selectedTime.format(ctx),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Duration
                  DropdownButtonFormField<int>(
                    value: durationMins,
                    decoration: InputDecoration(
                      labelText: 'Duration',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.timer_rounded),
                    ),
                    items: const [
                      DropdownMenuItem(value: 30, child: Text('30 minutes')),
                      DropdownMenuItem(value: 45, child: Text('45 minutes')),
                      DropdownMenuItem(value: 60, child: Text('60 minutes')),
                      DropdownMenuItem(value: 90, child: Text('90 minutes')),
                      DropdownMenuItem(value: 120, child: Text('2 hours')),
                    ],
                    onChanged: (v) => setSheetState(() => durationMins = v!),
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: () {
                            final title = titleCtrl.text.trim().isEmpty
                                ? selectedCourse.split('—').first.trim()
                                : titleCtrl.text.trim();
                            final section = selectedCourse.split('—').last.trim();

                            setState(() {
                              meetings.insert(0, {
                                'id': 'meet-${DateTime.now().millisecondsSinceEpoch}',
                                'title': title,
                                'section': section,
                                'date': '${selectedDate.day}/${selectedDate.month}, ${selectedTime.format(ctx)}',
                                'duration': '$durationMins min',
                                'status': 'upcoming',
                                'participants': 0,
                              });
                            });
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle_rounded, color: Colors.white),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text('Meeting "$title" scheduled!')),
                                  ],
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Schedule'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final upcoming = meetings.where((m) => m['status'] == 'upcoming').toList();
    final completed = meetings.where((m) => m['status'] == 'completed').toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Meetings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Upcoming section
          if (upcoming.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.upcoming_rounded, size: 18, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Upcoming',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            ...upcoming.map((m) => _meetingCard(m, isUpcoming: true)),
            const SizedBox(height: 20),
          ],

          // Completed section
          if (completed.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.history_rounded, size: 18, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    'Past Recordings',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            ...completed.map((m) => _meetingCard(m, isUpcoming: false)),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showScheduleDialog,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Schedule'),
      ),
    );
  }

  Widget _meetingCard(Map<String, dynamic> m, {required bool isUpcoming}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isUpcoming
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isUpcoming ? Icons.videocam_rounded : Icons.play_circle_rounded,
                color: isUpcoming
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m['title'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${m['section']} • ${m['date']}',
                    style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 12, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        m['duration'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      if (!isUpcoming) ...[
                        const SizedBox(width: 12),
                        Icon(Icons.people_outline_rounded, size: 12, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          '${m['participants']} attended',
                          style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Action button
            if (isUpcoming)
              FilledButton.icon(
                onPressed: () => _startMeeting(m),
                icon: const Icon(Icons.videocam_rounded, size: 18),
                label: const Text('Start'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              )
            else
              OutlinedButton.icon(
                onPressed: () => _watchRecording(m),
                icon: const Icon(Icons.play_arrow_rounded, size: 18),
                label: const Text('Watch'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
