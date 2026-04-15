import '../../data/repositories/game_repository.dart';

class SetCurrentLevelUseCase {
  final GameRepository _repository;

  SetCurrentLevelUseCase(this._repository);

  Future<void> execute(int level) => _repository.setCurrentLevel(level);
}
