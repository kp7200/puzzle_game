import '../../../data/models/puzzle_model.dart';
import '../utils/app_logger.dart';
import '../puzzles/puzzle_bank.dart';

/// Central source of truth for all puzzles.
///
/// This engine owns the puzzle registry. Logic is now driven by the centralized
/// puzzleBank for better scalability.
class PuzzleEngine {
  PuzzleEngine._();

  static final PuzzleEngine instance = PuzzleEngine._();

  /// Total number of puzzles registered in the bank.
  int get totalLevels => puzzleBank.length;

  /// Returns true if the given level ID is within the bounds of the bank.
  bool hasLevel(int levelId) => levelId >= 0 && levelId < puzzleBank.length;

  /// Retrieves a puzzle by level ID from the bank. Throws if out of bounds.
  PuzzleModel getPuzzle(int levelId) {
    if (!hasLevel(levelId)) {
      throw Exception('Puzzle for level $levelId not found');
    }
    return puzzleBank[levelId];
  }

  /// Returns the hints for the given level ID. Throws if level not found.
  List<String> getHints(int levelId) {
    return getPuzzle(levelId).hints;
  }

  /// Validates input by calling the puzzle's own validator function.
  /// Input normalization is handled inside PuzzleValidators — not here.
  bool validate(int levelId, String input) {
    try {
      final puzzle = getPuzzle(levelId);
      final isValid = puzzle.validator(input);
      if (isValid) {
        AppLogger.answerAccepted(levelId);
      } else {
        AppLogger.answerRejected(levelId, input, puzzle.rejectionReason(input));
      }
      return isValid;
    } catch (_) {
      return false;
    }
  }
}
