/// Represents the player identity.
///
/// Auth-ready design:
/// - [id] is null for guest/offline users; will hold Firebase UID or
///   Google Play Games player ID when cloud auth is enabled.
/// - [isGuest] is always true until a real auth provider is wired in.
class UserModel {
  final String? id;
  final String username;
  final bool isGuest;

  const UserModel({
    this.id,
    required this.username,
    this.isGuest = true,
  });

  UserModel copyWith({
    String? id,
    String? username,
    bool? isGuest,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, username: $username, isGuest: $isGuest)';
}
