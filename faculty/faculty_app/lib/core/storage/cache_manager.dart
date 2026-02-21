import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

/// Simple Hive-based cache manager for offline-first data.
class CacheManager {
  static const _boxName = 'faculty_cache';

  static Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  /// Store a JSON-serializable object with a key.
  static Future<void> put(String key, dynamic data) async {
    final box = await _getBox();
    await box.put(key, jsonEncode(data));
  }

  /// Retrieve and decode cached data.
  static Future<T?> get<T>(String key) async {
    final box = await _getBox();
    final raw = box.get(key);
    if (raw == null) return null;
    return jsonDecode(raw) as T;
  }

  /// Check if a key exists and is fresh.
  static Future<bool> isFresh(String key, Duration maxAge) async {
    final box = await _getBox();
    final timestamp = box.get('${key}_ts');
    if (timestamp == null) return false;
    final cachedAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(cachedAt) < maxAge;
  }

  /// Store with timestamp.
  static Future<void> putWithTimestamp(String key, dynamic data) async {
    final box = await _getBox();
    await box.put(key, jsonEncode(data));
    await box.put('${key}_ts', DateTime.now().millisecondsSinceEpoch);
  }

  /// Clear all cached data.
  static Future<void> clearAll() async {
    final box = await _getBox();
    await box.clear();
  }

  /// Delete specific key.
  static Future<void> delete(String key) async {
    final box = await _getBox();
    await box.delete(key);
    await box.delete('${key}_ts');
  }
}
