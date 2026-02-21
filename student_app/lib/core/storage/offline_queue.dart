import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';

/// Offline sync queue for actions performed without internet.
/// Stores attendance marks, assignment submissions, etc.
/// Background worker replays these when connectivity returns.

class OfflineQueueItem {
  final String id;
  final String endpoint;
  final String method; // POST, PUT
  final Map<String, dynamic> body;
  final DateTime createdAt;
  final int retryCount;
  final String? errorMessage;

  OfflineQueueItem({
    required this.id,
    required this.endpoint,
    required this.method,
    required this.body,
    required this.createdAt,
    this.retryCount = 0,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'endpoint': endpoint,
        'method': method,
        'body': body,
        'created_at': createdAt.toIso8601String(),
        'retry_count': retryCount,
        'error_message': errorMessage,
      };

  factory OfflineQueueItem.fromJson(Map<String, dynamic> json) {
    return OfflineQueueItem(
      id: json['id'],
      endpoint: json['endpoint'],
      method: json['method'],
      body: Map<String, dynamic>.from(json['body']),
      createdAt: DateTime.parse(json['created_at']),
      retryCount: json['retry_count'] ?? 0,
      errorMessage: json['error_message'],
    );
  }

  OfflineQueueItem copyWith({int? retryCount, String? errorMessage}) {
    return OfflineQueueItem(
      id: id,
      endpoint: endpoint,
      method: method,
      body: body,
      createdAt: createdAt,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Manages the offline queue in Hive.
class OfflineQueueManager {
  late Box<String> _box;

  Future<void> init() async {
    _box = await Hive.openBox<String>(HiveBoxes.offlineQueue);
  }

  /// Add an item to the queue.
  Future<void> enqueue(OfflineQueueItem item) async {
    await _box.put(item.id, jsonEncode(item.toJson()));
  }

  /// Get all pending items.
  List<OfflineQueueItem> getPending() {
    return _box.values
        .map((json) => OfflineQueueItem.fromJson(jsonDecode(json)))
        .where((item) => item.retryCount < 3)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  /// Update an item (e.g., increment retry count).
  Future<void> update(OfflineQueueItem item) async {
    await _box.put(item.id, jsonEncode(item.toJson()));
  }

  /// Remove a successfully synced item.
  Future<void> remove(String id) async {
    await _box.delete(id);
  }

  /// Get count of pending items.
  int get pendingCount => getPending().length;

  /// Clear all queued items.
  Future<void> clear() async {
    await _box.clear();
  }
}

final offlineQueueProvider = Provider<OfflineQueueManager>((ref) {
  return OfflineQueueManager();
});
