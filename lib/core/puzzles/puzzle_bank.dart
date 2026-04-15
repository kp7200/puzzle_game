import '../../data/models/puzzle_model.dart';
import '../engine/puzzle_validators.dart';

final List<PuzzleModel> puzzleBank = [
  PuzzleModel(
    id: 0,
    question: 'Input required.\n\nType:\nSTART',
    hints: [
      'The system is waiting for a specific word.',
      'The word is displayed on screen.',
      'Type exactly: START',
    ],
    validator: PuzzleValidators.exact('start'),
    rejectionReason: (input) => "Expected 'START', got: '${input.isEmpty ? '<empty>' : input}'",
  ),
  PuzzleModel(
    id: 1,
    question: 'The answer is nothing.\n\nSay nothing.',
    hints: [
      'The puzzle is asking you to provide nothing.',
      'An empty input is not the same as zero.',
      'Clear whatever you typed. Submit with no characters.',
    ],
    allowsEmpty: true,
    validator: PuzzleValidators.custom((input) => input.isEmpty),
    rejectionReason: (input) => "Expected silence. You typed: '$input'",
  ),
  PuzzleModel(
    id: 2,
    question: 'What you seek cannot be found\nif you refuse to make it\n\nvisible.',
    hints: [
      'Read the puzzle carefully — a word hides in plain sight.',
      'The last line contradicts itself.',
      'The answer is the word that should not be visible.',
    ],
    validator: PuzzleValidators.contains('visible'),
    rejectionReason: (input) => "The word 'visible' is not present in '${input.isEmpty ? '<empty>' : input}'",
  ),
];
