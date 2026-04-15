import '../../data/repositories/game_repository.dart';

class ResetProgressUseCase {
  final GameRepository _repository;

  ResetProgressUseCase(this._repository);

  Future<void> execute() => _repository.resetProgress();
}
