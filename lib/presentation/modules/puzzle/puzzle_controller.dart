import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../domain/usecases/get_puzzle_usecase.dart';
import '../../../../data/models/puzzle_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';

class PuzzleController extends GetxController {
  final GetPuzzleUseCase _getPuzzle = GetPuzzleUseCase();

  late final Rx<PuzzleModel?> currentPuzzle = Rx<PuzzleModel?>(null);

  final inputText = CommandTextEditingController();
  final RxString feedbackMessage = ''.obs;

  // Hint state — resets on every level load
  final RxList<String> revealedHints = <String>[].obs;
  final RxInt _revealedHintIndex = (-1).obs;
  final RxBool noMoreHints = false.obs;

  final RxBool isSubmitting = false.obs;

  int levelId = 0;
  int failedAttempts = 0;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      levelId = args['levelId'] as int? ?? 0;
    } else {
      levelId = args as int? ?? 0;
    }
    failedAttempts = 0;
    _loadPuzzle();
  }

  void _loadPuzzle() {
    try {
      currentPuzzle.value = _getPuzzle.execute(levelId);
      AppLogger.puzzleLoaded(levelId);
      feedbackMessage.value = '';
      // Reset hint state for the new level
      revealedHints.clear();
      _revealedHintIndex.value = -1;
      noMoreHints.value = false;
    } catch (e) {
      currentPuzzle.value = null;
      feedbackMessage.value = 'system awaiting further instructions\n\navailable commands: reset';
    }
  }

  void requestHint() {
    final puzzle = currentPuzzle.value;
    if (puzzle == null) return;

    final nextIndex = _revealedHintIndex.value + 1;

    if (nextIndex < puzzle.hints.length) {
      _revealedHintIndex.value = nextIndex;
      revealedHints.add(puzzle.hints[nextIndex]);
      noMoreHints.value = false;
    } else {
      // No more hints left — signal the UI without a popup
      noMoreHints.value = true;
    }
  }

  bool isCommand(String input) {
    return input.trim().startsWith('/');
  }

  String parseCommand(String input) {
    return input.trim().substring(1).toLowerCase();
  }

  void submitAnswer() async {
    if (isSubmitting.value) return;

    final input = inputText.text.trim();

    if (input.isEmpty) {
      if (currentPuzzle.value != null && !currentPuzzle.value!.allowsEmpty) {
        return;
      }
    }

    isSubmitting.value = true;
    inputText.clear();

    if (isCommand(input)) {
      AppLogger.navigatingToResult(levelId, input);
      final result = await Get.toNamed(
        Routes.result,
        arguments: {
          'type': 'command',
          'command': parseCommand(input),
          'levelId': levelId,
          'failedAttempts': failedAttempts,
        },
      );
      _handleResultBack(result);
      return;
    }

    if (currentPuzzle.value == null) {
      isSubmitting.value = false;
      return;
    }
    
    AppLogger.answerSubmitted(levelId, input);
    AppLogger.navigatingToResult(levelId, input);

    final result = await Get.toNamed(
      Routes.result,
      arguments: {
        'input': input,
        'levelId': levelId,
        'failedAttempts': failedAttempts,
      },
    );
    _handleResultBack(result);
  }

  void _handleResultBack(dynamic result) {
    if (result == true) {
      levelId++;
      failedAttempts = 0;
      _loadPuzzle();
    } else if (result == false) {
      failedAttempts++;
      AppLogger.retryingLevel(levelId);
    } else if (result == 'reset') {
      levelId = 0;
      failedAttempts = 0;
      _loadPuzzle();
    } else if (result == 'home') {
      Get.offAllNamed(Routes.home);
    }
    isSubmitting.value = false;
  }

  @override
  void onClose() {
    inputText.dispose();
    super.onClose();
  }
}

class CommandTextEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (text.trimLeft().startsWith('/')) {
      final slashIndex = text.indexOf('/');
      final firstSpaceAfterSlash = text.indexOf(' ', slashIndex);
      final commandEndIndex = firstSpaceAfterSlash == -1 ? text.length : firstSpaceAfterSlash;

      final String commandPart = text.substring(0, commandEndIndex);
      final String restPart = text.substring(commandEndIndex);

      return TextSpan(
        style: style,
        children: [
          TextSpan(
            text: commandPart,
            style: style?.copyWith(color: AppColors.primaryGreen) ??
                const TextStyle(color: AppColors.primaryGreen),
          ),
          if (restPart.isNotEmpty)
            TextSpan(
              text: restPart,
              style: style,
            ),
        ],
      );
    }
    return super.buildTextSpan(
      context: context,
      style: style,
      withComposing: withComposing,
    );
  }
}
