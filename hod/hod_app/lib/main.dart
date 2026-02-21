import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: HodApp()));
}

class HodApp extends ConsumerWidget {
  const HodApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CampusSphere HOD',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
