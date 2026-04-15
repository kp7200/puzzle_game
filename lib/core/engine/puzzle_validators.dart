/// Centralized library of reusable validator factory functions.
///
/// All validators receive input AFTER normalization (trimmed + lowercased).
/// This is the single place where normalization is enforced — never per-puzzle.
class PuzzleValidators {
  PuzzleValidators._();

  /// Normalize any input before passing to a validator.
  static String normalize(String input) => input.trim().toLowerCase();

  /// Matches a single exact word (case-insensitive, trimmed).
  /// Usage: PuzzleValidators.exact('start')
  static bool Function(String) exact(String answer) {
    return (input) => normalize(input) == answer.toLowerCase();
  }

  /// Accepts any of the provided answers.
  /// Usage: PuzzleValidators.anyOf(['start', 'begin', 'go'])
  static bool Function(String) anyOf(List<String> answers) {
    final normalized = answers.map((a) => a.toLowerCase()).toList();
    return (input) => normalized.contains(normalize(input));
  }

  /// Input must contain the given substring.
  /// Usage: PuzzleValidators.contains('system')
  static bool Function(String) contains(String substring) {
    return (input) => normalize(input).contains(substring.toLowerCase());
  }

  /// Validates input against a regex pattern.
  /// Normalization is applied before the pattern match.
  /// Usage: PuzzleValidators.regex(r'^level\s?\d+$')
  static bool Function(String) regex(String pattern) {
    return (input) => RegExp(pattern).hasMatch(normalize(input));
  }

  /// Passes a fully custom validator closure.
  /// Normalization is still applied before calling [fn].
  /// Usage: PuzzleValidators.custom((input) => input.split('').reversed.join('') == 'abc')
  static bool Function(String) custom(bool Function(String normalizedInput) fn) {
    return (input) => fn(normalize(input));
  }
}
