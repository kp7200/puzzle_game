import '../../data/repositories/user_repository.dart';

class SaveUsernameUseCase {
  final UserRepository _repository;

  SaveUsernameUseCase(this._repository);

  Future<void> execute(String name) => _repository.saveUsername(name);
}
