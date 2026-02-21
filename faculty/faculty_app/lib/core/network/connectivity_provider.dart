import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Watches network connectivity state.
final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Convenience provider that returns true when online.
final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.whenData((results) {
    return results.isNotEmpty &&
        !results.contains(ConnectivityResult.none);
  }).value ?? true;
});
