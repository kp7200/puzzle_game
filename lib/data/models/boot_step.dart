class BootStep {
  final String text;
  final Duration delayBefore;
  final Duration typingDuration;

  const BootStep({
    required this.text,
    required this.delayBefore,
    this.typingDuration = const Duration(milliseconds: 300),
  });
}
