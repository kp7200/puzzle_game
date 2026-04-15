import 'package:flutter/foundation.dart';

/// Centralized logger for the game engine.
///
/// All output uses [debugPrint] so it is stripped in release builds.
/// Never use print() directly — use this instead.
class AppLogger {
  AppLogger._();

  // ── Puzzle Engine ──────────────────────────────────────────────

  static void puzzleLoaded(int levelId) {
    _log('PUZZLE', 'Level $levelId loaded');
  }

  static void answerSubmitted(int levelId, String input) {
    final display = input.isEmpty ? '<empty>' : '"$input"';
    _log('INPUT ', 'Level $levelId → submitted $display');
  }

  static void answerAccepted(int levelId) {
    _log('VALID ', '✓ Level $levelId → ACCEPTED');
  }

  static void answerRejected(int levelId, String input, String reason) {
    final display = input.isEmpty ? '<empty>' : '"$input"';
    _log('VALID ', '✗ Level $levelId → REJECTED  input=$display  reason=$reason');
  }

  // ── Navigation ─────────────────────────────────────────────────

  static void navigatingToResult(int levelId, String input) {
    _log('NAV   ', 'Level $levelId → going to result screen  (input="${input.isEmpty ? '<empty>' : input}")');
  }

  static void navigatingToLevel(int levelId) {
    _log('NAV   ', '→ going to level $levelId');
  }

  static void retryingLevel(int levelId) {
    _log('NAV   ', '↩ retrying level $levelId');
  }

  // ── Internal ───────────────────────────────────────────────────

  static void _log(String tag, String message) {
    debugPrint('[THE_GAME][$tag] $message');
  }
}
