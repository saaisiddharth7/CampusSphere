import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Assignment list screen — shows faculty's assignments with submission stats.
class AssignmentListScreen extends ConsumerWidget {
  const AssignmentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final assignments = [
      {
        'id': 'asgn-1',
        'title': 'Database Normalization Exercise',
        'course': 'DBMS (CS301)',
        'section': 'CSE-3A',
        'deadline': 'Feb 28, 2026',
        'max_marks': 20,
        'submitted': 38,
        'verified': 12,
        'total': 52,
        'status': 'active',
      },
      {
        'id': 'asgn-2',
        'title': 'ER Diagram Design',
        'course': 'DBMS (CS301)',
        'section': 'CSE-3A',
        'deadline': 'Feb 20, 2026',
        'max_marks': 15,
        'submitted': 48,
        'verified': 48,
        'total': 52,
        'status': 'completed',
      },
      {
        'id': 'asgn-3',
        'title': 'SQL Queries Practice',
        'course': 'DBMS Lab (CS301L)',
        'section': 'CSE-3A',
        'deadline': 'Mar 5, 2026',
        'max_marks': 25,
        'submitted': 0,
        'verified': 0,
        'total': 52,
        'status': 'active',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Assignments'),
        actions: [
          IconButton(
            onPressed: () => context.push('/assignments/create'),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: assignments.length,
        itemBuilder: (context, idx) {
          final a = assignments[idx];
          final submitted = a['submitted'] as int;
          final verified = a['verified'] as int;
          final total = a['total'] as int;
          final isCompleted = a['status'] == 'completed';

          return Card(
            child: InkWell(
              onTap: () => context.push('/assignments/${a['id']}/submissions'),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            a['title'] as String,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Chip(
                          label: Text(
                            isCompleted ? 'Done' : 'Active',
                            style: TextStyle(
                              fontSize: 11,
                              color: isCompleted ? Colors.green : colorScheme.primary,
                            ),
                          ),
                          backgroundColor: isCompleted
                              ? Colors.green.withOpacity(0.1)
                              : colorScheme.primaryContainer,
                          side: BorderSide.none,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${a['course']} • ${a['section']} • Max: ${a['max_marks']} marks',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Due: ${a['deadline']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: total > 0 ? submitted / total : 0,
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '$submitted/$total submitted',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    if (!isCompleted && submitted > verified)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${submitted - verified} pending review',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/assignments/create'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Assignment'),
      ),
    );
  }
}
