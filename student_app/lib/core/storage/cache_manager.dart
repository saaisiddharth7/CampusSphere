import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

/// Generic local cache manager using Hive.
/// Each cache entry stores data with a TTL (time-to-live).
class CacheManager {
  /// Get cached data if it exists and hasn't expired.
  static Future<T?> get<T>(String boxName, String key) async {
    final box = await Hive.openBox<String>(boxName);
    final raw = box.get(key);
    if (raw == null) return null;

    final entry = jsonDecode(raw);
    final expiresAt = DateTime.parse(entry['expires_at']);

    if (DateTime.now().isAfter(expiresAt)) {
      // Cache expired
      await box.delete(key);
      return null;
    }

    return entry['data'] as T;
  }

  /// Store data with a TTL in minutes.
  static Future<void> put(
    String boxName,
    String key,
    dynamic data, {
    int ttlMinutes = 60,
  }) async {
    final box = await Hive.openBox<String>(boxName);
    final entry = {
      'data': data,
      'cached_at': DateTime.now().toIso8601String(),
      'expires_at':
          DateTime.now().add(Duration(minutes: ttlMinutes)).toIso8601String(),
    };
    await box.put(key, jsonEncode(entry));
  }

  /// Clear a specific box.
  static Future<void> clearBox(String boxName) async {
    final box = await Hive.openBox<String>(boxName);
    await box.clear();
  }

  /// Clear all caches.
  static Future<void> clearAll() async {
    final boxes = [
      HiveBoxes.timetableCache,
      HiveBoxes.attendanceCache,
      HiveBoxes.notificationsCache,
      HiveBoxes.chatroomCache,
      HiveBoxes.feeCache,
      HiveBoxes.resultsCache,
    ];
    for (final boxName in boxes) {
      await clearBox(boxName);
    }
  }
}
