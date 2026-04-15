import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../domain/usecases/get_current_level_usecase.dart';
import '../../../../domain/usecases/set_current_level_usecase.dart';
import '../../../../domain/usecases/is_first_time_user_usecase.dart';
import '../../../../domain/usecases/save_username_usecase.dart';
import '../../../../routes/app_routes.dart';

enum HomeState {
  tappingToBegin, // "Tap anywhere to begin"
  tooEasy,        // "That was too easy."
  puzzle,         // "Find the button."
  hinting,        // hint displayed, puzzle still active
  wrongTap,       // wrong area tapped — brief message then back to puzzle
  correct,        // "button" word tapped — "Finally."
  thinking,       // "You looked everywhere except where it was."
  done,           // returning user flow
  failed,         // 8+ wrong taps → restart
}

class HomeController extends GetxController {
  final GetCurrentLevelUseCase _getCurrentLevel = Get.find();
  final SetCurrentLevelUseCase _setCurrentLevel = Get.find();
  final IsFirstTimeUserUseCase _isFirstTimeUser = Get.find();
  final SaveUsernameUseCase _saveUsername = Get.find();

  final RxInt currentLevel = 0.obs;
  final Rx<HomeState> state = HomeState.tappingToBegin.obs;
  final RxString displayMessage = 'Tap anywhere to begin'.obs;

  // Username prompt overlay state
  final RxBool showUsernamePrompt = false.obs;
  final RxString usernameInputError = ''.obs;

  // Tracks wrong taps during the find-the-button puzzle
  int _wrongTapCount = 0;
  bool _isInteracting = false; // debounce concurrent interactions
  Timer? _hintTimer;

  final _wrongMessages = [
    "That's not a button.",
    "You're still looking for something else.",
    "Read it again.",
    "It's right there.",
    "You missed it.",
    "Not that.",
    "Closer. But no.",
  ];
  String _lastWrong = '';

  @override
  void onInit() {
    super.onInit();
    currentLevel.value = _getCurrentLevel.execute();

    // Returning user — skip intro
    if (currentLevel.value > 0) {
      state.value = HomeState.done;
      displayMessage.value = 'System ready.';
    }
  }

  // ── Stage 1: initial tap ─────────────────────────────────────────────────

  void handleScreenTap() async {
    // Failed state → restart from splash
    if (state.value == HomeState.failed) {
      Get.offAllNamed(Routes.splash);
      return;
    }

    // "Tap anywhere to begin" → begin intro
    if (state.value == HomeState.tappingToBegin) {
      _startIntro();
      return;
    }

    // Puzzle active → wrong tap
    if (state.value == HomeState.puzzle || state.value == HomeState.hinting) {
      handleWrongTap();
    }
  }

  Future<void> _startIntro() async {
    state.value = HomeState.tooEasy;
    displayMessage.value = 'That was too easy.';

    await Future.delayed(const Duration(milliseconds: 1600));

    _enterPuzzle();
  }

  // ── Stage 2: the puzzle ──────────────────────────────────────────────────

  void _enterPuzzle() {
    state.value = HomeState.puzzle;
    displayMessage.value = 'Find the button.';
    _wrongTapCount = 0;
    _isInteracting = false;
    _startHintTimer();
  }

  void _startHintTimer() {
    _hintTimer?.cancel();
    _hintTimer = Timer(const Duration(seconds: 5), () {
      if (state.value == HomeState.puzzle) {
        state.value = HomeState.hinting;
        displayMessage.value = 'You\'re overcomplicating this.';

        // Revert hint text after 2s but keep puzzle active
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (state.value == HomeState.hinting) {
            state.value = HomeState.puzzle;
            displayMessage.value = 'Find the button.';
          }
        });
      }
    });
  }

  // ── Wrong tap ────────────────────────────────────────────────────────────

  void handleWrongTap() async {
    if (_isInteracting) return;
    if (state.value != HomeState.puzzle && state.value != HomeState.hinting) return;

    _isInteracting = true;
    _wrongTapCount++;
    _hintTimer?.cancel();
    _audio?.playError();

    // Super-fail after 8 wrong taps
    if (_wrongTapCount >= 8) {
      state.value = HomeState.failed;
      displayMessage.value = 'Incompatible perception detected.\n\n[ tap to restart system ]';
      return;
    }

    // Pick a non-repeating wrong message
    String msg;
    do {
      msg = _wrongMessages[Random().nextInt(_wrongMessages.length)];
    } while (msg == _lastWrong && _wrongMessages.length > 1);
    _lastWrong = msg;

    final previousState = state.value;
    state.value = HomeState.wrongTap;
    displayMessage.value = msg;

    await Future.delayed(const Duration(milliseconds: 1400));

    // Restore puzzle
    state.value = previousState == HomeState.hinting ? HomeState.puzzle : previousState;
    displayMessage.value = 'Find the button.';
    _isInteracting = false;
    _startHintTimer();
  }

  // ── Correct tap ──────────────────────────────────────────────────────────

  void handleCorrectTap() async {
    if (_isInteracting) return;
    if (state.value != HomeState.puzzle && state.value != HomeState.hinting) return;

    _isInteracting = true;
    _hintTimer?.cancel();
    _audio?.playSuccess();

    state.value = HomeState.correct;
    displayMessage.value = 'Finally.';

    await Future.delayed(const Duration(milliseconds: 1400));

    _audio?.playCommandExecute();
    state.value = HomeState.thinking;
    displayMessage.value = 'You looked everywhere except where it was.';

    await Future.delayed(const Duration(milliseconds: 2400));

    // Persist level 1 before checking username
    currentLevel.value = 1;
    await _setCurrentLevel.execute(1);

    // Gate: show username prompt if this is first time
    if (_isFirstTimeUser.execute()) {
      showUsernamePrompt.value = true;
    } else {
      Get.offNamed(Routes.puzzle, arguments: currentLevel.value);
    }
  }

  // ── Username prompt ──────────────────────────────────────────────────────

  Future<void> submitUsername(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      usernameInputError.value = 'Enter a name to continue.';
      return;
    }
    usernameInputError.value = '';
    await _saveUsername.execute(trimmed);
    showUsernamePrompt.value = false;
    Get.offNamed(Routes.puzzle, arguments: currentLevel.value);
  }

  // ── Returning user ───────────────────────────────────────────────────────

  void startSystem() {
    Get.offNamed(Routes.puzzle, arguments: currentLevel.value);
  }

  void openSettings() {
    Get.toNamed(Routes.settings);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  bool get isPuzzleActive =>
      state.value == HomeState.puzzle || state.value == HomeState.hinting;

  AudioService? get _audio {
    try {
      return Get.find<AudioService>();
    } catch (_) {
      return null;
    }
  }

  @override
  void onClose() {
    _hintTimer?.cancel();
    super.onClose();
  }
}


