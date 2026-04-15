import '../../core/engine/puzzle_engine.dart';

class GetHintsUseCase {
  final PuzzleEngine _engine = PuzzleEngine.instance;

  List<String> execute(int levelId) {
    return _engine.getHints(levelId);
  }
}
