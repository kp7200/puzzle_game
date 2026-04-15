import '../repositories/user_repository.dart';
import '../local/local_storage_service.dart';

/// Hive-backed implementation of [UserRepository].
/// Swap this class for FirebaseUserRepository when migrating to cloud.
class HiveUserRepository implements UserRepository {
  final LocalStorageService _storage;

  HiveUserRepository(this._storage);

  @override
  String? getUsername() => _storage.getUsername();

  @override
  Future<void> saveUsername(String name) => _storage.saveUsername(name.trim());

  @override
  bool isFirstTimeUser() {
    final username = _storage.getUsername();
    return username == null || username.trim().isEmpty;
  }
}
