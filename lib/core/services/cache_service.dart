import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  static const String _boxName = 'appCache';
  Box? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  Box get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception('Cache service not initialized. Call init() first.');
    }
    return _box!;
  }

  Future<void> put(String key, dynamic value) async {
    await box.put(key, value);
  }

  T? get<T>(String key, {T? defaultValue}) {
    try {
      return box.get(key, defaultValue: defaultValue) as T?;
    } catch (_) {
      return defaultValue;
    }
  }

  bool containsKey(String key) {
    return box.containsKey(key);
  }

  Future<void> delete(String key) async {
    await box.delete(key);
  }

  Future<void> clear() async {
    await box.clear();
  }

  Future<void> dispose() async {
    await _box?.close();
    _box = null;
  }
}
