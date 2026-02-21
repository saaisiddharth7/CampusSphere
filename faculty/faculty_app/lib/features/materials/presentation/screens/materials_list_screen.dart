import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Study materials list — organized by course and unit.
class MaterialsListScreen extends ConsumerWidget {
  const MaterialsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final materials = [
      {
        'course': 'DBMS (CS301)',
        'units': [
          {'title': 'Unit 1: Introduction to DBMS', 'files': 3, 'views': 156},
          {'title': 'Unit 2: ER Model & Relational Algebra', 'files': 5, 'views': 234},
          {'title': 'Unit 3: SQL & Normalization', 'files': 4, 'views': 312},
          {'title': 'Unit 4: Transactions & Concurrency', 'files': 2, 'views': 89},
        ],
      },
      {
        'course': 'DBMS Lab (CS301L)',
        'units': [
          {'title': 'Lab 1-3: SQL Basics', 'files': 3, 'views': 198},
          {'title': 'Lab 4-5: Joins & Subqueries', 'files': 2, 'views': 145},
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Study Materials'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: materials.length,
        itemBuilder: (context, courseIdx) {
          final course = materials[courseIdx];
          final units = course['units'] as List;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (courseIdx > 0) const SizedBox(height: 16),
              Text(
                course['course'] as String,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...units.map((unit) {
                final u = unit as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Icon(Icons.folder_rounded,
                          color: colorScheme.onPrimaryContainer, size: 20),
                    ),
                    title: Text(
                      u['title'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text('${u['files']} files • ${u['views']} views'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {},
                  ),
                );
              }),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.upload_file_rounded),
        label: const Text('Upload'),
      ),
    );
  }
}
