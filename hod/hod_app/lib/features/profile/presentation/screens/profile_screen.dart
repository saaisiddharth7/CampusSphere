import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// HOD Profile screen — view details, settings, logout.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(authProvider).user ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.tertiary]),
                    ),
                    child: const Center(child: Text('VR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 28))),
                  ),
                  const SizedBox(height: 12),
                  Text(user['name'] as String? ?? 'Dr. Venkat R', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(user['designation'] as String? ?? 'Professor & Head', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  Text('${user['department'] ?? 'CSE'} • ${user['employee_id'] ?? 'FAC-001'}', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13)),
                ],
              ),
            ),
          ),

          // Academic details
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text('Academic Details', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                ),
                _DetailTile(icon: Icons.school_rounded, label: 'Qualification', value: user['qualification'] as String? ?? 'Ph.D. CSE'),
                _DetailTile(icon: Icons.work_rounded, label: 'Specialization', value: user['specialization'] as String? ?? 'ML & Data Science'),
                _DetailTile(icon: Icons.timer_rounded, label: 'Experience', value: user['experience'] as String? ?? '18 years'),
                _DetailTile(icon: Icons.people_rounded, label: 'Faculty Under', value: '${user['faculty_count'] ?? 24} members'),
                _DetailTile(icon: Icons.groups_rounded, label: 'Students', value: '${user['student_count'] ?? 480} across 8 sections'),
                _DetailTile(icon: Icons.email_rounded, label: 'Email', value: user['email'] as String? ?? 'venkat.r@campussphere.demo'),
                _DetailTile(icon: Icons.phone_rounded, label: 'Phone', value: user['phone'] as String? ?? '9876500100'),
              ],
            ),
          ),

          // Settings
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text('Settings', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                ),
                SwitchListTile(
                  title: const Text('Dark Mode', style: TextStyle(fontSize: 14)),
                  secondary: const Icon(Icons.dark_mode_rounded),
                  value: false,
                  onChanged: (v) {},
                ),
                SwitchListTile(
                  title: const Text('Push Notifications', style: TextStyle(fontSize: 14)),
                  secondary: const Icon(Icons.notifications_rounded),
                  value: true,
                  onChanged: (v) {},
                ),
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: const Text('Language', style: TextStyle(fontSize: 14)),
                  trailing: const Text('English'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout_rounded, color: Colors.red),
              label: const Text('Sign Out', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailTile({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, size: 20),
    title: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
    subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
  );
}
