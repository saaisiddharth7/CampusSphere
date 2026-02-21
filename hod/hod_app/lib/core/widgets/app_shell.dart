import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Bottom navigation shell for HOD app.
class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    int currentIdx = 0;
    if (location.startsWith('/department')) currentIdx = 1;
    if (location.startsWith('/faculty-perf')) currentIdx = 2;
    if (location.startsWith('/approvals')) currentIdx = 3;
    if (location.startsWith('/profile')) currentIdx = 4;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIdx,
        onDestinationSelected: (idx) {
          switch (idx) {
            case 0: context.go('/dashboard'); break;
            case 1: context.go('/department'); break;
            case 2: context.go('/faculty-perf'); break;
            case 3: context.go('/approvals'); break;
            case 4: context.go('/profile'); break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.business_rounded), label: 'Department'),
          NavigationDestination(icon: Icon(Icons.people_rounded), label: 'Faculty'),
          NavigationDestination(icon: Icon(Icons.approval_rounded), label: 'Approvals'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
