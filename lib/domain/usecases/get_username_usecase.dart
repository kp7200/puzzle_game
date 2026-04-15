import '../../data/repositories/user_repository.dart';

class GetUsernameUseCase {
  final UserRepository _repository;

  GetUsernameUseCase(this._repository);

  String? execute() => _repository.getUsername();
}
