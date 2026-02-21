import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Main app shell with bottom navigation bar.
/// This wraps all tabbed routes via GoRouter's ShellRoute.
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/calendar')) return 1;
    if (location.startsWith('/attendance')) return 2;
    if (location.startsWith('/chat')) return 3;
    if (location.startsWith('/more')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/calendar');
              break;
            case 2:
              context.go('/attendance');
              break;
            case 3:
              context.go('/chat');
              break;
            case 4:
              context.go('/more');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on_outlined),
            selectedIcon: Icon(Icons.location_on),
            label: 'Attendance',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.chat_bubble_outline),
            ),
            selectedIcon: Badge(
              label: Text('2'),
              child: Icon(Icons.chat_bubble),
            ),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
