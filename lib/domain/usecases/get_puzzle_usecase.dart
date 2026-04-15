import '../../core/engine/puzzle_engine.dart';
import '../../data/models/puzzle_model.dart';

class GetPuzzleUseCase {
  final PuzzleEngine _engine = PuzzleEngine.instance;

  PuzzleModel execute(int levelId) {
    return _engine.getPuzzle(levelId);
  }
}
