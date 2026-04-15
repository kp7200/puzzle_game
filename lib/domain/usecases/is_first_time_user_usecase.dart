import '../../data/repositories/user_repository.dart';

class IsFirstTimeUserUseCase {
  final UserRepository _repository;

  IsFirstTimeUserUseCase(this._repository);

  bool execute() => _repository.isFirstTimeUser();
}
