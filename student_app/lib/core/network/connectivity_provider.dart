import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Monitors network connectivity and exposes current status.
final connectivityProvider = StreamProvider<bool>((ref) {
  return Connectivity().onConnectivityChanged.map((results) {
    return results.isNotEmpty &&
        !results.contains(ConnectivityResult.none);
  });
});

/// Synchronous accessor for last known connectivity state.
final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.when(
    data: (isOnline) => isOnline,
    loading: () => true, // Assume online initially
    error: (_, __) => false,
  );
});
