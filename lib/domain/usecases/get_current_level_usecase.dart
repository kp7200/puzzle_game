import '../../data/repositories/game_repository.dart';

class GetCurrentLevelUseCase {
  final GameRepository _repository;

  GetCurrentLevelUseCase(this._repository);

  int execute() => _repository.getCurrentLevel();
}
