import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Faculty Performance overview — table of all dept faculty with detailed metrics.
class FacultyPerformanceScreen extends ConsumerWidget {
  const FacultyPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final faculty = [
      {'name': 'Prof. Lakshmi P', 'id': 'FAC-042', 'spec': 'Database Systems', 'teaching': 97, 'research': 3, 'feedback': 4.2, 'score': 8.5, 'assign_speed': '2.1d'},
      {'name': 'Dr. Arun K', 'id': 'FAC-015', 'spec': 'AI/ML', 'teaching': 100, 'research': 5, 'feedback': 4.6, 'score': 9.1, 'assign_speed': '1.5d'},
      {'name': 'Prof. Meera S', 'id': 'FAC-028', 'spec': 'Networks', 'teaching': 88, 'research': 2, 'feedback': 3.8, 'score': 7.2, 'assign_speed': '3.5d'},
      {'name': 'Dr. Ravi V', 'id': 'FAC-033', 'spec': 'Cloud Computing', 'teaching': 95, 'research': 4, 'feedback': 4.4, 'score': 8.8, 'assign_speed': '1.8d'},
      {'name': 'Prof. Sunitha M', 'id': 'FAC-051', 'spec': 'Data Science', 'teaching': 92, 'research': 6, 'feedback': 4.5, 'score': 8.9, 'assign_speed': '2.0d'},
      {'name': 'Dr. Karthik N', 'id': 'FAC-019', 'spec': 'Cybersecurity', 'teaching': 90, 'research': 1, 'feedback': 3.5, 'score': 6.8, 'assign_speed': '4.2d'},
      {'name': 'Prof. Deepa R', 'id': 'FAC-064', 'spec': 'Software Engg', 'teaching': 93, 'research': 3, 'feedback': 4.0, 'score': 8.1, 'assign_speed': '2.3d'},
      {'name': 'Dr. Suresh B', 'id': 'FAC-041', 'spec': 'Theory of Comp', 'teaching': 85, 'research': 8, 'feedback': 4.1, 'score': 8.3, 'assign_speed': '2.8d'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Performance'),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded, size: 18),
            label: const Text('Export'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary stats
          Row(
            children: [
              Expanded(child: _MiniStat(label: 'Avg Score', value: '8.2', color: Colors.green)),
              const SizedBox(width: 8),
              Expanded(child: _MiniStat(label: 'Avg Teaching', value: '92.5%', color: colorScheme.primary)),
              const SizedBox(width: 8),
              Expanded(child: _MiniStat(label: 'Avg Feedback', value: '4.1/5', color: Colors.orange)),
            ],
          ),
          const SizedBox(height: 16),

          // Faculty cards
          ...faculty.map((f) {
            final score = (f['score'] as num).toDouble();
            final scoreColor = score >= 8.5 ? Colors.green : (score >= 7.5 ? Colors.orange : Colors.red);
            final teaching = f['teaching'] as int;
            final feedback = (f['feedback'] as num).toDouble();

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: colorScheme.primaryContainer,
                          child: Text(
                            (f['name'] as String).split(' ').map((w) => w[0]).take(2).join(),
                            style: TextStyle(color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(f['name'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                              Text('${f['id']} • ${f['spec']}', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: scoreColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${score.toStringAsFixed(1)}/10',
                            style: TextStyle(fontWeight: FontWeight.w800, color: scoreColor, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _MetricChip(icon: Icons.class_rounded, label: 'Teaching', value: '$teaching%'),
                        const SizedBox(width: 8),
                        _MetricChip(icon: Icons.article_rounded, label: 'Research', value: '${f['research']} papers'),
                        const SizedBox(width: 8),
                        _MetricChip(icon: Icons.star_rounded, label: 'Feedback', value: '${feedback}/5'),
                        const SizedBox(width: 8),
                        _MetricChip(icon: Icons.speed_rounded, label: 'Verify', value: f['assign_speed'] as String),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Teaching bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: teaching / 100,
                        minHeight: 6,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(teaching >= 90 ? Colors.green : Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetricChip({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            Text(label, style: TextStyle(fontSize: 9, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
