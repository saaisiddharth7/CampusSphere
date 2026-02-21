import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/theme/app_theme.dart';

/// Faculty profile screen — view/edit profile, settings, logout.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final profile = auth.profile;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      '${profile?.user.firstName[0] ?? 'F'}${profile?.user.lastName[0] ?? 'A'}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile?.user.fullName ?? 'Faculty',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile?.faculty.designation ?? 'Professor',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${profile?.departmentName ?? ''} • ${profile?.faculty.employeeId ?? ''}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Info section
          Card(
            child: Column(
              children: [
                _InfoTile(
                  icon: Icons.school_rounded,
                  label: 'Specialization',
                  value: profile?.faculty.specialization ?? '—',
                ),
                const Divider(height: 1),
                _InfoTile(
                  icon: Icons.badge_rounded,
                  label: 'Qualification',
                  value: profile?.faculty.qualification ?? '—',
                ),
                const Divider(height: 1),
                _InfoTile(
                  icon: Icons.work_history_rounded,
                  label: 'Experience',
                  value: '${profile?.faculty.experienceYears ?? '—'} years',
                ),
                const Divider(height: 1),
                _InfoTile(
                  icon: Icons.email_rounded,
                  label: 'Email',
                  value: profile?.user.email ?? '—',
                ),
                const Divider(height: 1),
                _InfoTile(
                  icon: Icons.phone_rounded,
                  label: 'Phone',
                  value: profile?.user.phone ?? '—',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Courses
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Assigned Courses',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...?profile?.assignedCourses.map(
                    (c) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            c.courseType == 'lab'
                                ? Icons.computer_rounded
                                : Icons.menu_book_rounded,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text('${c.courseCode} — ${c.courseName}'),
                          const Spacer(),
                          Text(
                            c.sectionName,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Settings
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.dark_mode_rounded),
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (_) {
                      ref.read(themeModeProvider.notifier).state =
                          isDark ? ThemeMode.light : ThemeMode.dark;
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('App Version'),
                  trailing: const Text('1.0.0'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Logout
          OutlinedButton.icon(
            onPressed: () => ref.read(authProvider.notifier).logout(),
            icon: const Icon(Icons.logout_rounded, color: Colors.red),
            label: const Text('Logout', style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      dense: true,
    );
  }
}
