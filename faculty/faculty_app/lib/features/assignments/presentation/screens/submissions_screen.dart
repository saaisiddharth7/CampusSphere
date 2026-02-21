import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Submissions review screen — lists student submissions with verify/reject actions.
class SubmissionsScreen extends ConsumerWidget {
  final String assignmentId;
  const SubmissionsScreen({super.key, required this.assignmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final submissions = [
      {'roll': '21CS101', 'name': 'Rahul Kumar', 'status': 'pending', 'submitted_at': 'Feb 25, 8:30 PM', 'late': false, 'file': 'normalization_solution.pdf'},
      {'roll': '21CS102', 'name': 'Priya Menon', 'status': 'verified', 'submitted_at': 'Feb 24', 'marks': 18, 'remark': 'Excellent decomposition', 'late': false, 'file': 'priya_dbms.pdf'},
      {'roll': '21CS103', 'name': 'Arun Krishnan', 'status': 'pending', 'submitted_at': 'Feb 26, 11:58 PM', 'late': true, 'late_days': 1, 'file': 'arun_dbms_assignment.docx'},
      {'roll': '21CS104', 'name': 'Deepika R', 'status': 'missing', 'submitted_at': null, 'late': false, 'file': null},
      {'roll': '21CS105', 'name': 'Suresh V', 'status': 'verified', 'submitted_at': 'Feb 24', 'marks': 16, 'remark': 'Good', 'late': false, 'file': 'suresh_solution.pdf'},
      {'roll': '21CS106', 'name': 'Anita S', 'status': 'pending', 'submitted_at': 'Feb 25, 3:00 PM', 'late': false, 'file': 'anita_normalization.pdf'},
    ];

    final submitted = submissions.where((s) => s['status'] != 'missing').length;
    final verified = submissions.where((s) => s['status'] == 'verified').length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Submissions'),
      ),
      body: Column(
        children: [
          // Progress
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DB Normalization — CSE-3A',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '$submitted/${submissions.length} submitted • $verified verified',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: submissions.isNotEmpty ? submitted / submissions.length : 0,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),

          // Submissions list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: submissions.length,
              itemBuilder: (context, idx) {
                final s = submissions[idx];
                final status = s['status'] as String;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${s['roll']} ${s['name']}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (s['submitted_at'] != null)
                                    Text(
                                      'Submitted: ${s['submitted_at']}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                ],
                              ),
                            ),
                            _StatusBadge(status: status),
                          ],
                        ),
                        if (s['late'] == true)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '🔴 LATE (${s['late_days']} day) • -2 marks',
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        if (status == 'verified') ...[
                          const Divider(),
                          Text(
                            'Marks: ${s['marks']}/20 — "${s['remark']}"',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                            ),
                          ),
                        ],
                        if (status == 'pending') ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (s['file'] != null)
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.download_rounded, size: 16),
                                  label: const Text('Download'),
                                  style: OutlinedButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                              const SizedBox(width: 8),
                              FilledButton.tonal(
                                onPressed: () => _showVerifyDialog(context, s),
                                child: const Text('Verify'),
                                style: FilledButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showVerifyDialog(BuildContext context, Map<String, dynamic> submission) {
    final marksCtrl = TextEditingController();
    final remarkCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verify: ${submission['name']}',
              style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: marksCtrl,
              decoration: const InputDecoration(labelText: 'Marks (out of 20)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: remarkCtrl,
              decoration: const InputDecoration(labelText: 'Remarks'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('✅ Verify'),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('🔄 Resubmit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = switch (status) {
      'verified' => (Colors.green, Icons.check_circle_rounded, 'Verified'),
      'pending' => (Colors.orange, Icons.hourglass_top_rounded, 'Pending'),
      'missing' => (Colors.red, Icons.cancel_rounded, 'Missing'),
      _ => (Colors.grey, Icons.help_outline_rounded, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
