import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Purchase request approvals — HOD approves/rejects requests from faculty.
class ApprovalsScreen extends ConsumerStatefulWidget {
  const ApprovalsScreen({super.key});

  @override
  ConsumerState<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends ConsumerState<ApprovalsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  final List<Map<String, dynamic>> _requests = [
    {'id': 'PR-2026-001', 'title': 'Lab Equipment — 20 Raspberry Pi 5', 'by': 'Prof. Lakshmi P', 'amount': 120000, 'justification': 'IoT Lab expansion for 3rd sem students. Current RPi 3 units are outdated and 8 are non-functional.', 'status': 'pending', 'date': 'Feb 20'},
    {'id': 'PR-2026-002', 'title': 'Conference Travel — IEEE ICML 2026', 'by': 'Dr. Arun K', 'amount': 85000, 'justification': 'Paper accepted at IEEE ICML. Reg: ₹25K, Flight: ₹35K, Stay: ₹25K.', 'status': 'pending', 'date': 'Feb 18'},
    {'id': 'PR-2026-003', 'title': 'Software Licenses — JetBrains All Products', 'by': 'Prof. Meera S', 'amount': 240000, 'justification': '50 seats of JetBrains for SE Lab. Annual license. Educational discount applied.', 'status': 'pending', 'date': 'Feb 15'},
    {'id': 'PR-2026-004', 'title': 'Books — Database Internals (50 copies)', 'by': 'Prof. Lakshmi P', 'amount': 45000, 'justification': 'Reference books for DBMS Lab.', 'status': 'approved', 'date': 'Feb 10'},
    {'id': 'PR-2026-005', 'title': 'Projector Repair — Lab Hall 3', 'by': 'Dr. Ravi V', 'amount': 12000, 'justification': 'Projector not functional since Jan 28.', 'status': 'approved', 'date': 'Feb 5'},
    {'id': 'PR-2026-006', 'title': 'AWS Credits — Final Year Projects', 'by': 'Dr. Suresh B', 'amount': 50000, 'justification': 'Cloud credits for 15 final year project teams.', 'status': 'rejected', 'date': 'Jan 30'},
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  void _showDetail(Map<String, dynamic> req) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) {
        final isPending = req['status'] == 'pending';
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text(req['title'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('${req['id']} • ${req['date']}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const SizedBox(height: 16),
              _detailRow('Requested By', req['by'] as String),
              _detailRow('Amount', '₹${(req['amount'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'),
              _detailRow('Status', (req['status'] as String).toUpperCase()),
              const SizedBox(height: 12),
              Text('Justification', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 4),
              Text(req['justification'] as String, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 24),
              if (isPending)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() => req['status'] = 'rejected');
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request rejected'), backgroundColor: Colors.red));
                        },
                        icon: const Icon(Icons.close_rounded, color: Colors.red),
                        label: const Text('Reject', style: TextStyle(color: Colors.red)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: () {
                          setState(() => req['status'] = 'approved');
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request approved! Forwarded to Admin.'), backgroundColor: Colors.green));
                        },
                        icon: const Icon(Icons.check_rounded),
                        label: const Text('Approve & Forward'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pending = _requests.where((r) => r['status'] == 'pending').toList();
    final approved = _requests.where((r) => r['status'] == 'approved').toList();
    final rejected = _requests.where((r) => r['status'] == 'rejected').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Approvals'),
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: [
            Tab(text: 'Pending (${pending.length})'),
            Tab(text: 'Approved (${approved.length})'),
            Tab(text: 'Rejected (${rejected.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _buildList(pending),
          _buildList(approved),
          _buildList(rejected),
        ],
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('No requests', style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, idx) {
        final r = items[idx];
        final isPending = r['status'] == 'pending';
        final isApproved = r['status'] == 'approved';
        final statusColor = isPending ? Colors.orange : (isApproved ? Colors.green : Colors.red);

        return Card(
          child: InkWell(
            onTap: () => _showDetail(r),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isPending ? Icons.hourglass_top_rounded : (isApproved ? Icons.check_circle_rounded : Icons.cancel_rounded),
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text('${r['by']} • ${r['date']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  Text(
                    '₹${((r['amount'] as int) / 1000).toStringAsFixed(0)}K',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: statusColor),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
