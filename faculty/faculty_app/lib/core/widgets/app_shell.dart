import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Bottom navigation shell for the faculty app.
class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  static const _tabs = [
    (icon: Icons.dashboard_rounded, label: 'Home', path: '/dashboard'),
    (icon: Icons.calendar_today_rounded, label: 'Timetable', path: '/timetable'),
    (icon: Icons.fact_check_rounded, label: 'Attend', path: '/attendance'),
    (icon: Icons.chat_bubble_outline_rounded, label: 'Chat', path: '/chat'),
    (icon: Icons.person_outline_rounded, label: 'Profile', path: '/profile'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (idx) {
          context.go(_tabs[idx].path);
        },
        destinations: _tabs
            .map((tab) => NavigationDestination(
                  icon: Icon(tab.icon),
                  label: tab.label,
                ))
            .toList(),
      ),
    );
  }
}
