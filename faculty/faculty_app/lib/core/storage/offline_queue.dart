import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../config/app_config.dart';

/// Manages a queue of API actions made while offline.
/// When connectivity returns, pending actions are synced.
class OfflineQueueManager {
  static const _boxName = 'offline_queue';
  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  /// Enqueue an action to be retried when online.
  Future<void> enqueue({
    required String method,
    required String path,
    Map<String, dynamic>? body,
  }) async {
    final action = {
      'method': method,
      'path': path,
      'body': body,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _box.add(jsonEncode(action));
  }

  /// Process all queued actions.
  Future<void> sync(Dio dio) async {
    final keys = _box.keys.toList();
    for (final key in keys) {
      final raw = _box.get(key);
      if (raw == null) continue;

      final action = jsonDecode(raw) as Map<String, dynamic>;
      try {
        switch (action['method']) {
          case 'POST':
            await dio.post(action['path'], data: action['body']);
            break;
          case 'PUT':
            await dio.put(action['path'], data: action['body']);
            break;
          case 'DELETE':
            await dio.delete(action['path']);
            break;
        }
        await _box.delete(key);
      } catch (_) {
        // Will retry next sync
        break;
      }
    }
  }

  /// Number of pending actions.
  int get pendingCount => _box.length;

  /// Clear the queue.
  Future<void> clear() async => await _box.clear();
}

/// Global offline queue provider.
final offlineQueueProvider = Provider<OfflineQueueManager>((ref) {
  throw UnimplementedError('Override in main()');
});
