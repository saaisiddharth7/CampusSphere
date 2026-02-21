import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/app_config.dart';
import 'core/config/router.dart';
import 'core/storage/offline_queue.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // System UI style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize offline queue
  final offlineQueue = OfflineQueueManager();
  await offlineQueue.init();

  // Initialize Supabase (only if configured)
  if (AppConfig.supabaseUrl.isNotEmpty) {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        offlineQueueProvider.overrideWithValue(offlineQueue),
      ],
      child: const FacultyApp(),
    ),
  );
}

class FacultyApp extends ConsumerStatefulWidget {
  const FacultyApp({super.key});

  @override
  ConsumerState<FacultyApp> createState() => _FacultyAppState();
}

class _FacultyAppState extends ConsumerState<FacultyApp> {
  @override
  void initState() {
    super.initState();
    // Try to restore session
    Future.microtask(() {
      ref.read(authProvider.notifier).tryRestoreSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final tenantTheme = ref.watch(tenantThemeProvider);

    return MaterialApp.router(
      title: 'CampusSphere Faculty',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(tenantTheme),
      darkTheme: buildDarkTheme(tenantTheme),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
