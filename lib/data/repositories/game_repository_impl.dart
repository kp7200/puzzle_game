import '../repositories/game_repository.dart';
import '../local/local_storage_service.dart';

/// Hive-backed implementation of [GameRepository].
/// Swap this class for FirebaseGameRepository when migrating to cloud.
class HiveGameRepository implements GameRepository {
  final LocalStorageService _storage;

  HiveGameRepository(this._storage);

  @override
  int getCurrentLevel() => _storage.getCurrentLevel();

  @override
  Future<void> saveProgress(int level) => _storage.setCurrentLevel(level);

  @override
  Future<void> setCurrentLevel(int level) => _storage.setCurrentLevel(level);

  @override
  Future<void> resetProgress() => _storage.resetProgress();

  @override
  List<int> getCompletedLevels() => _storage.getCompletedLevels();
}

