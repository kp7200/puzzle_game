/// Abstract contract for game progress persistence.
/// Controllers and use cases depend ONLY on this interface —
/// never on HiveGameRepository or any concrete implementation.
abstract class GameRepository {
  int getCurrentLevel();
  Future<void> saveProgress(int level);
  Future<void> setCurrentLevel(int level); // kept for backward compat
  Future<void> resetProgress();
  List<int> getCompletedLevels();
}

