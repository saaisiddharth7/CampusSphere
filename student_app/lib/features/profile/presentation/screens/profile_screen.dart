import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Profile screen — fetches from /v1/student/profile (real API).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authProvider);
    final profile = authState.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ref.read(authProvider.notifier).logout();
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.logout, color: colorScheme.error),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: colorScheme.primaryContainer,
              backgroundImage: profile?.user.avatarUrl != null
                  ? CachedNetworkImageProvider(profile!.user.avatarUrl!)
                  : null,
              child: profile?.user.avatarUrl == null
                  ? Text(
                      profile?.user.firstName.substring(0, 1) ?? 'S',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              profile?.user.fullName ?? 'Student',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${profile?.student.rollNumber ?? '—'} | ${profile?.departmentCode ?? 'CSE'} Sem ${profile?.student.currentSemester ?? '—'}',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            Text(
              profile?.user.email ?? '',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),

            const SizedBox(height: 32),

            // Info Cards
            _infoCard(theme, 'Personal Details', [
              _infoRow('Phone', profile?.user.phone ?? '—'),
              _infoRow('Gender', profile?.user.gender ?? '—'),
              _infoRow('DOB', profile?.user.dateOfBirth?.toString().substring(0, 10) ?? '—'),
              _infoRow('Blood Group', profile?.student.bloodGroup ?? '—'),
            ]),

            const SizedBox(height: 16),

            _infoCard(theme, 'Academic Details', [
              _infoRow('Department', profile?.departmentName ?? '—'),
              _infoRow('Program', profile?.programName ?? '—'),
              _infoRow('Section', profile?.sectionName ?? '—'),
              _infoRow('Batch', '${profile?.student.batchYear ?? '—'}'),
              _infoRow('Reg. No', profile?.student.registrationNumber ?? '—'),
            ]),

            const SizedBox(height: 16),

            _infoCard(theme, 'Parent/Guardian', [
              _infoRow('Name', profile?.student.parentName ?? '—'),
              _infoRow('Phone', profile?.student.parentPhone ?? '—'),
              _infoRow('Email', profile?.student.parentEmail ?? '—'),
            ]),

            const SizedBox(height: 32),

            // Settings
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notification Preferences'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text('Theme'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(ThemeData theme, String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
