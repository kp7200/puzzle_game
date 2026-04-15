import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

/// Central audio service for the_game.
/// All sounds are loaded from bundled assets.
/// Every call is wrapped in try/catch — audio failure never crashes the app.
class AudioService extends GetxService {
  static AudioService get to => Get.find<AudioService>();

  // Individual players for sounds that can overlap
  late final AudioPlayer _typingPlayer;
  late final AudioPlayer _humPlayer;
  late final AudioPlayer _oneshotPlayer;

  // Debounce typing ticks to avoid spam
  DateTime _lastTickTime = DateTime.fromMillisecondsSinceEpoch(0);
  static const _tickDebounceMs = 80;

  // Master mute flag — fail-safe goes here
  bool _audioReady = false;

  Future<AudioService> init() async {
    await _initPlayers();
    return this;
  }

  Future<void> _initPlayers() async {
    try {
      _typingPlayer = AudioPlayer()..setPlayerMode(PlayerMode.lowLatency);
      _humPlayer = AudioPlayer();
      _oneshotPlayer = AudioPlayer()..setPlayerMode(PlayerMode.lowLatency);

      // Pre-configure volumes
      await _typingPlayer.setVolume(0.12);
      await _humPlayer.setVolume(0.06);
      await _oneshotPlayer.setVolume(0.30);

      _audioReady = true;
    } catch (e) {
      // Audio init failed — app continues silently
      _audioReady = false;
    }
  }

  // ── Splash sounds ────────────────────────────────────────────────────────

  /// Very subtle tick per character during typing animation.
  void playTypingTick() {
    if (!_audioReady) return;
    final now = DateTime.now();
    if (now.difference(_lastTickTime).inMilliseconds < _tickDebounceMs) return;
    _lastTickTime = now;
    _safePlay(_typingPlayer, 'audio/typing_tick.wav');
  }

  /// Low ambient hum — loops during splash boot sequence.
  Future<void> startAmbientHum() async {
    if (!_audioReady) return;
    try {
      await _humPlayer.setReleaseMode(ReleaseMode.loop);
      await _humPlayer.play(AssetSource('audio/ambient_hum.wav'));
    } catch (_) {}
  }

  Future<void> stopAmbientHum() async {
    if (!_audioReady) return;
    try {
      await _humPlayer.stop();
    } catch (_) {}
  }

  /// Short digital glitch burst.
  void playGlitch() => _safeOneshot('audio/glitch.wav', volume: 0.40);

  // ── Level 0 / Home sounds ────────────────────────────────────────────────

  /// Soft click when user submits input.
  void playInputClick() => _safeOneshot('audio/click.mp3', volume: 0.25);

  /// Subtle dull tone for wrong answer.
  void playError() => _safeOneshot('audio/error_sound.wav', volume: 0.28);

  /// Minimal two-tone chime for correct answer.
  void playSuccess() => _safeOneshot('audio/success_sound.wav', volume: 0.30);

  /// Soft digital confirm when the system transitions state.
  void playCommandExecute() => _safeOneshot('audio/command_execute.wav', volume: 0.25);

  // ── Internals ────────────────────────────────────────────────────────────

  void _safePlay(AudioPlayer player, String assetPath) {
    try {
      player.play(AssetSource(assetPath));
    } catch (_) {}
  }

  void _safeOneshot(String assetPath, {double volume = 0.30}) {
    if (!_audioReady) return;
    try {
      _oneshotPlayer.setVolume(volume);
      _oneshotPlayer.play(AssetSource(assetPath));
    } catch (_) {}
  }

  @override
  void onClose() {
    _typingPlayer.dispose();
    _humPlayer.dispose();
    _oneshotPlayer.dispose();
    super.onClose();
  }
}
