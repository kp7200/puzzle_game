class PuzzleModel {
  final int id;
  final String question;
  final List<String> hints;
  final bool Function(String input) validator;
  final bool allowsEmpty;

  /// Explains why the given input was rejected.
  /// Called only on failure — receives the raw (un-normalized) input.
  final String Function(String input) rejectionReason;

  PuzzleModel({
    required this.id,
    required this.question,
    required this.hints,
    required this.validator,
    this.allowsEmpty = false,
    String Function(String input)? rejectionReason,
  }) : rejectionReason =
            rejectionReason ?? ((input) => 'Input "$input" did not satisfy the condition');
}
