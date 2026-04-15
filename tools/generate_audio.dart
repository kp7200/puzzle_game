/// Auto-generates all required WAV audio files for the_game project.
/// Run with: dart run tools/generate_audio.dart
/// Output: assets/audio/
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void main() async {
  final outputDir = Directory('assets/audio');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
    print('Created assets/audio/');
  }

  await _generate('typing_tick', _sineWave(frequency: 800, durationMs: 50, amplitude: 0.15));
  await _generate('ambient_hum', _sineWave(frequency: 80, durationMs: 3000, amplitude: 0.08));
  await _generate('glitch', _glitchNoise(durationMs: 220, amplitude: 0.35));
  await _generate('input_click', _sineWave(frequency: 600, durationMs: 80, amplitude: 0.20));
  await _generate('error_sound', _sineWave(frequency: 220, durationMs: 350, amplitude: 0.25, fadeOut: true));
  await _generate('success_sound', _twoToneSine(f1: 523, f2: 659, durationMs: 400, amplitude: 0.22));
  await _generate('command_execute', _sineWave(frequency: 440, durationMs: 160, amplitude: 0.20, fadeOut: true));

  print('\nDone. All audio files written to assets/audio/');
}

// ── WAV writer ──────────────────────────────────────────────────────────────

Future<void> _generate(String name, List<int> samples) async {
  final path = 'assets/audio/$name.wav';
  final bytes = _buildWav(samples);
  await File(path).writeAsBytes(bytes);
  final kb = (bytes.length / 1024).toStringAsFixed(1);
  print('  ✓ $name.wav  ($kb KB)');
}

Uint8List _buildWav(List<int> samples) {
  const sampleRate = 44100;
  const numChannels = 1;
  const bitsPerSample = 16;
  final byteRate = sampleRate * numChannels * (bitsPerSample ~/ 8);
  final blockAlign = numChannels * (bitsPerSample ~/ 8);
  final dataSize = samples.length * 2; // 16-bit = 2 bytes per sample
  final totalSize = 36 + dataSize;

  final buf = ByteData(totalSize + 8);
  var o = 0;

  // RIFF header
  _writeChars(buf, o, 'RIFF'); o += 4;
  buf.setUint32(o, totalSize, Endian.little); o += 4;
  _writeChars(buf, o, 'WAVE'); o += 4;

  // fmt chunk
  _writeChars(buf, o, 'fmt '); o += 4;
  buf.setUint32(o, 16, Endian.little); o += 4;          // chunk size
  buf.setUint16(o, 1, Endian.little); o += 2;           // PCM format
  buf.setUint16(o, numChannels, Endian.little); o += 2;
  buf.setUint32(o, sampleRate, Endian.little); o += 4;
  buf.setUint32(o, byteRate, Endian.little); o += 4;
  buf.setUint16(o, blockAlign, Endian.little); o += 2;
  buf.setUint16(o, bitsPerSample, Endian.little); o += 2;

  // data chunk
  _writeChars(buf, o, 'data'); o += 4;
  buf.setUint32(o, dataSize, Endian.little); o += 4;
  for (final s in samples) {
    buf.setInt16(o, s.clamp(-32768, 32767), Endian.little);
    o += 2;
  }
  return buf.buffer.asUint8List();
}

void _writeChars(ByteData buf, int offset, String s) {
  for (var i = 0; i < s.length; i++) {
    buf.setUint8(offset + i, s.codeUnitAt(i));
  }
}

// ── Signal generators ───────────────────────────────────────────────────────

List<int> _sineWave({
  required double frequency,
  required int durationMs,
  required double amplitude,
  bool fadeOut = false,
}) {
  const sampleRate = 44100;
  final numSamples = (sampleRate * durationMs / 1000).round();
  final samples = <int>[];
  for (var i = 0; i < numSamples; i++) {
    double env = 1.0;
    if (fadeOut) {
      env = 1.0 - (i / numSamples); // linear fade
    } else {
      // short attack + decay envelope
      final attack = (numSamples * 0.1).round();
      final release = (numSamples * 0.3).round();
      if (i < attack) {
        env = i / attack;
      } else if (i > numSamples - release) {
        env = (numSamples - i) / release;
      }
    }
    final t = i / sampleRate;
    final value = amplitude * env * sin(2 * pi * frequency * t) * 32767;
    samples.add(value.round());
  }
  return samples;
}

List<int> _twoToneSine({
  required double f1,
  required double f2,
  required int durationMs,
  required double amplitude,
}) {
  const sampleRate = 44100;
  final numSamples = (sampleRate * durationMs / 1000).round();
  final half = numSamples ~/ 2;
  final samples = <int>[];

  for (var i = 0; i < numSamples; i++) {
    final freq = i < half ? f1 : f2;
    final phase = i < half
        ? i / sampleRate
        : (i - half) / sampleRate;
    final env = i < half
        ? (i / half).clamp(0, 1)
        : (1.0 - ((i - half) / half)).clamp(0, 1);
    final value = amplitude * env * sin(2 * pi * freq * phase) * 32767;
    samples.add(value.round());
  }
  return samples;
}

List<int> _glitchNoise({required int durationMs, required double amplitude}) {
  const sampleRate = 44100;
  final numSamples = (sampleRate * durationMs / 1000).round();
  final rng = Random();
  final samples = <int>[];

  for (var i = 0; i < numSamples; i++) {
    // Clusters of short sine bursts at shifting frequencies
    final freqShift = 200.0 + (i % 17) * 80;
    final t = i / sampleRate;
    // Mix sine with random noise for digital glitch feel
    final sine = 0.6 * sin(2 * pi * freqShift * t);
    final noise = 0.4 * (rng.nextDouble() * 2 - 1);
    // Envelope: sharp on, sharp off
    final env = (i < numSamples * 0.15 || i > numSamples * 0.85) ? 0.3 : 1.0;
    final value = amplitude * env * (sine + noise) * 32767;
    samples.add(value.round());
  }
  return samples;
}
