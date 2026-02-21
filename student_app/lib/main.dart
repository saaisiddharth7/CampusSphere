import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/app_config.dart';
import 'core/config/router.dart';
import 'core/theme/app_theme.dart';
import 'core/storage/offline_queue.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize Supabase (for Realtime subscriptions)
  if (AppConfig.supabaseUrl.isNotEmpty) {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  }

  // Initialize offline queue
  final offlineQueue = OfflineQueueManager();
  await offlineQueue.init();

  // Set system UI style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  runApp(
    ProviderScope(
      overrides: [
        offlineQueueProvider.overrideWithValue(offlineQueue),
      ],
      child: const CampusSphereApp(),
    ),
  );
}

class CampusSphereApp extends ConsumerStatefulWidget {
  const CampusSphereApp({super.key});

  @override
  ConsumerState<CampusSphereApp> createState() => _CampusSphereAppState();
}

class _CampusSphereAppState extends ConsumerState<CampusSphereApp> {
  @override
  void initState() {
    super.initState();
    // Try to restore session on app launch
    Future.microtask(() {
      ref.read(authProvider.notifier).tryRestoreSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeConfig = ref.watch(tenantThemeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: themeConfig.appName ?? 'CampusSphere',
      debugShowCheckedModeBanner: false,

      // Dynamic theming from tenant config
      theme: buildLightTheme(themeConfig),
      darkTheme: buildDarkTheme(themeConfig),
      themeMode: themeMode,

      // GoRouter
      routerConfig: router,
    );
  }
}
