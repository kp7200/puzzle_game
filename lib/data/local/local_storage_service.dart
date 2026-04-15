import 'package:hive_flutter/hive_flutter.dart';

/// Low-level Hive wrapper.
/// MUST NOT be imported outside the data layer.
class LocalStorageService {
  static const String _boxName = 'game_box';

  // ── Keys ──────────────────────────────────────────────────────────────────
  static const String _currentLevelKey = 'current_level';
  static const String _completedLevelsKey = 'completed_levels';
  static const String _usernameKey = 'username';

  late final Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  // ── Game progress ─────────────────────────────────────────────────────────

  int getCurrentLevel() {
    return _box.get(_currentLevelKey, defaultValue: 0) as int;
  }

  Future<void> setCurrentLevel(int level) async {
    await _box.put(_currentLevelKey, level);
  }

  List<int> getCompletedLevels() {
    final raw = _box.get(_completedLevelsKey, defaultValue: <int>[]);
    return List<int>.from(raw as List);
  }

  Future<void> addCompletedLevel(int level) async {
    final levels = getCompletedLevels();
    if (!levels.contains(level)) {
      levels.add(level);
      await _box.put(_completedLevelsKey, levels);
    }
  }

  Future<void> resetProgress() async {
    await _box.put(_currentLevelKey, 0);
    await _box.put(_completedLevelsKey, <int>[]);
  }

  // ── User identity ─────────────────────────────────────────────────────────

  String? getUsername() {
    return _box.get(_usernameKey) as String?;
  }

  Future<void> saveUsername(String name) async {
    await _box.put(_usernameKey, name);
  }
}
