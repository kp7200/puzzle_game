import 'package:get/get.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../routes/app_routes.dart';

enum SplashState { initializing, booting, awaitingInteraction, verified }

class SplashController extends GetxController {
  final RxList<String> activeLogs = <String>[].obs;
  final RxBool isGlitching = false.obs;
  final RxBool showBlinkingPrompt = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startBootSequence();
  }

  Future<void> _startBootSequence() async {
    // Start ambient hum at the very beginning
    _audio?.startAmbientHum();

    // Stage 1: Robotic start
    await _addLog('booting...', const Duration(milliseconds: 800));
    await _addLog('wait...', const Duration(milliseconds: 1200));
    
    // Stage 2: Recognition
    await _addLog('why are you here?', const Duration(milliseconds: 1500));
    
    // Stage 3: Realization
    await _addLog('...', const Duration(milliseconds: 1000));
    
    // Glitch with sound
    _audio?.playGlitch();
    isGlitching.value = true;
    await Future.delayed(const Duration(milliseconds: 400));
    isGlitching.value = false;

    await _addLog('oh.', const Duration(milliseconds: 800));
    await _addLog('you actually opened it.', const Duration(milliseconds: 1200));

    // Stop hum, play command-execute, then navigate
    await Future.delayed(const Duration(milliseconds: 800));
    _audio?.stopAmbientHum();
    _audio?.playCommandExecute();
    await Future.delayed(const Duration(milliseconds: 400));
    Get.offNamed(Routes.home);
  }

  Future<void> _addLog(String text, Duration delay) async {
    await Future.delayed(delay);
    activeLogs.add(text);
    // Play a subtle tick with each character-worth of typing time
    final charDelay = 40;
    for (var i = 0; i < text.length; i++) {
      _audio?.playTypingTick();
      await Future.delayed(Duration(milliseconds: charDelay));
    }
  }

  AudioService? get _audio {
    try {
      return Get.find<AudioService>();
    } catch (_) {
      return null; // Not yet registered — fail silently
    }
  }
}
