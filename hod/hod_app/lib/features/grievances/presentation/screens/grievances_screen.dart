import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Grievance resolution screen — HOD views and resolves department grievances.
class GrievancesScreen extends ConsumerStatefulWidget {
  const GrievancesScreen({super.key});

  @override
  ConsumerState<GrievancesScreen> createState() => _GrievancesScreenState();
}

class _GrievancesScreenState extends ConsumerState<GrievancesScreen> {
  final List<Map<String, dynamic>> _grievances = [
    {'id': 'GRV-041', 'title': 'Lab AC not working since 2 weeks', 'by': 'Rahul Kumar (21CS101)', 'type': 'Infrastructure', 'level': 1, 'date': 'Feb 20', 'status': 'escalated'},
    {'id': 'GRV-039', 'title': 'WiFi connectivity issues in Block C', 'by': 'Priya Menon (21CS102)', 'type': 'IT', 'level': 1, 'date': 'Feb 18', 'status': 'open'},
    {'id': 'GRV-036', 'title': 'Faculty not providing assignment feedback', 'by': 'Deepika R (21CS104)', 'type': 'Academic', 'level': 1, 'date': 'Feb 15', 'status': 'open'},
    {'id': 'GRV-033', 'title': 'Library books shortage for DBMS', 'by': 'CSE-3A CR', 'type': 'Academic', 'level': 0, 'date': 'Feb 10', 'status': 'resolved'},
    {'id': 'GRV-030', 'title': 'Projector malfunction in Room 204', 'by': 'Prof. Karthik N', 'type': 'Infrastructure', 'level': 0, 'date': 'Feb 5', 'status': 'resolved'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Grievances'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _grievances.length,
        itemBuilder: (context, idx) {
          final g = _grievances[idx];
          final isOpen = g['status'] != 'resolved';
          final isEscalated = g['status'] == 'escalated';
          final statusColor = isEscalated ? Colors.red : (isOpen ? Colors.orange : Colors.green);
          final typeIcon = g['type'] == 'Infrastructure' ? Icons.build_rounded : (g['type'] == 'IT' ? Icons.wifi_rounded : Icons.school_rounded);

          return Card(
            child: InkWell(
              onTap: () => _showGrievance(g),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                      child: Icon(typeIcon, color: statusColor),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(g['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text('${g['by']} • ${g['date']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        isEscalated ? '🔴 Escalated' : (isOpen ? 'Open' : '✅ Resolved'),
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showGrievance(Map<String, dynamic> g) {
    final isOpen = g['status'] != 'resolved';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text(g['title'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${g['id']} • ${g['type']} • ${g['date']}', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 12),
            Text('Raised by: ${g['by']}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 20),
            if (isOpen)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => g['level'] = (g['level'] as int) + 1);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Escalated to Dean'), backgroundColor: Colors.orange));
                      },
                      child: const Text('Escalate to Dean'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: () {
                        setState(() => g['status'] = 'resolved');
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Grievance resolved'), backgroundColor: Colors.green));
                      },
                      child: const Text('Mark Resolved'),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
