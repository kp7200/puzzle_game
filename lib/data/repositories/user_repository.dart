/// Abstract contract for user identity persistence.
/// Controllers and use cases depend ONLY on this interface —
/// never on HiveUserRepository or any concrete implementation.
abstract class UserRepository {
  /// Returns null if no username has been set yet.
  String? getUsername();

  Future<void> saveUsername(String name);

  /// True when the user has never entered a username.
  bool isFirstTimeUser();
}
