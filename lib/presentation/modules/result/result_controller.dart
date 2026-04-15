import 'package:get/get.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/engine/puzzle_engine.dart';
import '../../../../domain/usecases/validate_puzzle_usecase.dart';
import '../../../../domain/usecases/set_current_level_usecase.dart';

class ResultController extends GetxController {
  final ValidatePuzzleUseCase _validatePuzzle = ValidatePuzzleUseCase();
  final SetCurrentLevelUseCase _setCurrentLevel = Get.find();

  final RxList<String> logs = <String>[].obs;
  final RxBool isProcessing = true.obs;
  final RxBool isAccepted = false.obs;
  final RxBool waitingForTap = false.obs;

  late final String _type;
  late final String _input;
  late final String _command;
  late final int _levelId;
  late final int _failedAttempts;

  final List<String> _processingSteps = const [
    '> validating input...',
    '> parsing command...',
    '> checking integrity...',
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    _type = args?['type'] as String? ?? 'puzzle';
    _input = args?['input'] as String? ?? '';
    _command = args?['command'] as String? ?? '';
    _levelId = args?['levelId'] as int? ?? 0;
    _failedAttempts = args?['failedAttempts'] as int? ?? 0;
    
    if (_type == 'command') {
      _runCommandSequence(_command);
    } else {
      _runValidationSequence();
    }
  }

  Future<void> _runCommandSequence(String command) async {
    logs.add('> parsing command...');
    await Future.delayed(const Duration(milliseconds: 400));
    
    switch (command) {
      case 'reset':
        logs.add('> executing /reset');
        await Future.delayed(const Duration(milliseconds: 300));
        logs.add('> clearing level progression...');
        await Future.delayed(const Duration(milliseconds: 400));
        await _setCurrentLevel.execute(0);
        logs.add('> progress cleared');
        isProcessing.value = false;
        await Future.delayed(const Duration(milliseconds: 800));
        AppLogger.navigatingToLevel(0);
        Get.back(result: 'reset');
        break;

      case 'home':
        logs.add('> executing /home');
        await Future.delayed(const Duration(milliseconds: 300));
        logs.add('> returning to home hub...');
        isProcessing.value = false;
        await Future.delayed(const Duration(milliseconds: 800));
        Get.back(result: 'home');
        break;

      case 'help':
        logs.add('> executing /help');
        await Future.delayed(const Duration(milliseconds: 300));
        logs.add('> available commands:');
        await Future.delayed(const Duration(milliseconds: 150));
        logs.add('> /reset');
        await Future.delayed(const Duration(milliseconds: 150));
        logs.add('> /home');
        await Future.delayed(const Duration(milliseconds: 150));
        logs.add('> /help');
        await Future.delayed(const Duration(milliseconds: 600));
        logs.add('');
        logs.add('> tap anywhere to return to input sequence');
        isProcessing.value = false;
        waitingForTap.value = true;
        break;

      default:
        logs.add('> unknown command: /$command');
        await Future.delayed(const Duration(milliseconds: 300));
        logs.add('> type /help for available commands');
        await Future.delayed(const Duration(milliseconds: 600));
        logs.add('');
        logs.add('> tap anywhere to return to input sequence');
        isProcessing.value = false;
        waitingForTap.value = true;
        break;
    }
  }

  Future<void> _runValidationSequence() async {
    final delays = [500, 380, 420];
    for (int i = 0; i < _processingSteps.length; i++) {
      await Future.delayed(Duration(milliseconds: delays[i]));
      logs.add(_processingSteps[i]);
    }

    final result = _validatePuzzle.execute(_levelId, _input);
    isAccepted.value = result;
    isProcessing.value = false;

    if (result) {
      final nextLevel = _levelId + 1;
      await _setCurrentLevel.execute(nextLevel);
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (result) {
      logs.add('> result: ACCEPTED');
      await Future.delayed(const Duration(milliseconds: 250));
      logs.add('> access granted');
      await Future.delayed(const Duration(milliseconds: 600));
      
      final nextLevel = _levelId + 1;
      if (nextLevel >= PuzzleEngine.instance.totalLevels) {
        logs.add('');
        logs.add('> system awaiting further instructions');
        await Future.delayed(const Duration(milliseconds: 600));
        logs.add('> available commands: reset');
        await Future.delayed(const Duration(milliseconds: 2000));
      } else {
        logs.add('> loading next sequence...');
      }
    } else {
      logs.add('> result: REJECTED');
      await Future.delayed(const Duration(milliseconds: 250));
      logs.add('> invalid input');
      
      if (_failedAttempts + 1 >= 3) {
        await Future.delayed(const Duration(milliseconds: 300));
        logs.add('> or reset');
      }
    }

    await Future.delayed(const Duration(milliseconds: 800));
    await _navigate(result);
  }

  Future<void> _navigate(bool accepted) async {
    Get.back(result: accepted);
  }

  void handleTap() {
    if (waitingForTap.value) {
      Get.back(result: 'ignore');
    }
  }
}
