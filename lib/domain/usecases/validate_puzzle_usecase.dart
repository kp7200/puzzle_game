import '../../core/engine/puzzle_engine.dart';

class ValidatePuzzleUseCase {
  final PuzzleEngine _engine = PuzzleEngine.instance;

  bool execute(int levelId, String input) {
    return _engine.validate(levelId, input);
  }
}
