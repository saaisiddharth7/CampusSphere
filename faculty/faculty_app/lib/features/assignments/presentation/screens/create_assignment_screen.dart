import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Create a new assignment — full form matching roadmap wireframes.
class CreateAssignmentScreen extends ConsumerStatefulWidget {
  const CreateAssignmentScreen({super.key});

  @override
  ConsumerState<CreateAssignmentScreen> createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends ConsumerState<CreateAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _course = 'CS301';
  String _section = 'CSE-3A';
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _marksCtrl = TextEditingController(text: '20');
  DateTime _deadline = DateTime.now().add(const Duration(days: 7));
  String _submissionType = 'file';
  bool _allowLate = true;
  bool _allowResubmit = true;
  int _latePenalty = 2;
  int _maxLateDays = 3;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _marksCtrl.dispose();
    super.dispose();
  }

  void _publish() {
    if (!_formKey.currentState!.validate()) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 48),
        title: const Text('Assignment Published!'),
        content: const Text(
          'Notification sent to all students.\nPosted in class chatroom.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Create Assignment'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Course
            DropdownButtonFormField<String>(
              value: _course,
              decoration: const InputDecoration(labelText: 'Course'),
              items: const [
                DropdownMenuItem(value: 'CS301', child: Text('DBMS (CS301)')),
                DropdownMenuItem(value: 'CS301L', child: Text('DBMS Lab (CS301L)')),
              ],
              onChanged: (v) => setState(() => _course = v!),
            ),
            const SizedBox(height: 16),

            // Section
            DropdownButtonFormField<String>(
              value: _section,
              decoration: const InputDecoration(labelText: 'Section'),
              items: const [
                DropdownMenuItem(value: 'CSE-3A', child: Text('CSE-3A')),
                DropdownMenuItem(value: 'CSE-3B', child: Text('CSE-3B')),
              ],
              onChanged: (v) => setState(() => _section = v!),
            ),
            const SizedBox(height: 16),

            // Title
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            // Submission type
            Text('Submission Type', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'file', label: Text('File Upload')),
                ButtonSegment(value: 'text', label: Text('Text')),
                ButtonSegment(value: 'both', label: Text('Both')),
              ],
              selected: {_submissionType},
              onSelectionChanged: (s) => setState(() => _submissionType = s.first),
            ),
            const SizedBox(height: 16),

            // Max marks + Deadline
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _marksCtrl,
                    decoration: const InputDecoration(labelText: 'Max Marks'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _deadline,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 180)),
                      );
                      if (picked != null) setState(() => _deadline = picked);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Deadline'),
                      child: Text(
                        '${_deadline.day}/${_deadline.month}/${_deadline.year}',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Late submission toggle
            SwitchListTile(
              title: const Text('Allow late submission'),
              value: _allowLate,
              onChanged: (v) => setState(() => _allowLate = v),
              contentPadding: EdgeInsets.zero,
            ),
            if (_allowLate) ...[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: '$_latePenalty',
                      decoration: const InputDecoration(labelText: 'Penalty/day'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _latePenalty = int.tryParse(v) ?? 2,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: '$_maxLateDays',
                      decoration: const InputDecoration(labelText: 'Max late days'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _maxLateDays = int.tryParse(v) ?? 3,
                    ),
                  ),
                ],
              ),
            ],

            SwitchListTile(
              title: const Text('Allow resubmission'),
              value: _allowResubmit,
              onChanged: (v) => setState(() => _allowResubmit = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),

            // Publish
            ElevatedButton.icon(
              onPressed: _publish,
              icon: const Icon(Icons.publish_rounded),
              label: const Text('Publish Assignment'),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Notification will be sent to all students',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
