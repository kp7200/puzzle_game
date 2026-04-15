import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        // Full-screen wrong-tap handler
        behavior: HitTestBehavior.opaque,
        onTap: controller.handleScreenTap,
        child: Stack(
          children: [
            const Positioned.fill(child: _LivingBackground()),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Obx(() {
                  final s = controller.state.value;
                  final isPuzzle = s == HomeState.puzzle ||
                      s == HomeState.hinting ||
                      s == HomeState.wrongTap;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // --- Puzzle state: split RichText ---
                      if (isPuzzle)
                        _FindTheButtonText(controller: controller)
                      // --- Done state: returning user ---
                      else if (s == HomeState.done)
                        _ReturningUserContent(controller: controller)
                      // --- All other states: plain animated text ---
                      else
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          transitionBuilder: (child, animation) => FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                                CurvedAnimation(parent: animation, curve: Curves.easeOut),
                              ),
                              child: child,
                            ),
                          ),
                          child: Text(
                            controller.displayMessage.value,
                            key: ValueKey<String>(controller.displayMessage.value),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.sectionHeading.copyWith(
                              fontSize: 24,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ),
            // ── Username prompt overlay ──────────────────────────────────────
            Obx(() {
              if (!controller.showUsernamePrompt.value) return const SizedBox.shrink();
              return _UsernamePromptOverlay(controller: controller);
            }),
          ],
        ),
      ),
    );
  }
}

// ── Returning user content ─────────────────────────────────────────────────
//
// Shown when HomeState.done — player has played before.
// Displays "System ready." with a START tap cue and a minimal SETTINGS link.

class _ReturningUserContent extends StatelessWidget {
  final HomeController controller;
  const _ReturningUserContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary message
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: Text(
            controller.displayMessage.value,
            key: ValueKey<String>(controller.displayMessage.value),
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionHeading.copyWith(
              fontSize: 24,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 40),
        // START button
        GestureDetector(
          onTap: controller.startSystem,
          child: Text(
            '[ START ]',
            style: AppTextStyles.body.copyWith(
              color: AppColors.primaryGreen,
              letterSpacing: 2.0,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // SETTINGS link — minimal, muted
        GestureDetector(
          onTap: controller.openSettings,
          child: Text(
            'SETTINGS',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 3.0,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Username prompt overlay ────────────────────────────────────────────────
//
// Overlays the entire screen after completing the home puzzle for the first
// time. Uses a terminal-style text field consistent with the design system.

class _UsernamePromptOverlay extends StatefulWidget {
  final HomeController controller;
  const _UsernamePromptOverlay({required this.controller});

  @override
  State<_UsernamePromptOverlay> createState() => _UsernamePromptOverlayState();
}

class _UsernamePromptOverlayState extends State<_UsernamePromptOverlay> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background.withValues(alpha: 0.92),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'identify yourself.',
                style: AppTextStyles.sectionHeading.copyWith(
                  fontSize: 22,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'this is for the record.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 32),
              // Terminal-style text field
              TextField(
                controller: _textController,
                autofocus: false,
                autocorrect: false,
                enableSuggestions: false,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
                cursorColor: AppColors.primaryGreen,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(24),
                ],
                decoration: InputDecoration(
                  hintText: 'your name',
                  hintStyle: AppTextStyles.body.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 16,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaryGreen,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onSubmitted: (value) =>
                    widget.controller.submitUsername(value),
              ),
              // Error text
              Obx(() {
                final err = widget.controller.usernameInputError.value;
                if (err.isEmpty) return const SizedBox(height: 20);
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    err,
                    style: AppTextStyles.body.copyWith(
                      color: Colors.redAccent.shade100,
                      fontSize: 12,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => widget.controller.submitUsername(_textController.text),
                child: Text(
                  '[ CONFIRM ]',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primaryGreen,
                    letterSpacing: 2.0,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── The "Find the button." widget ──────────────────────────────────────────


class _FindTheButtonText extends StatelessWidget {
  final HomeController controller;
  const _FindTheButtonText({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isWrongState = controller.state.value == HomeState.wrongTap;

    // During wrong-tap state, show the sarcastic message
    if (isWrongState) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Text(
          controller.displayMessage.value,
          key: ValueKey<String>(controller.displayMessage.value),
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionHeading.copyWith(
            fontSize: 22,
            letterSpacing: -0.5,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    // Normal puzzle state — split text with tappable "button" word
    final textStyle = AppTextStyles.sectionHeading.copyWith(
      fontSize: 24,
      letterSpacing: -0.5,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Text.rich(
        key: const ValueKey('puzzle_text'),
        textAlign: TextAlign.center,
        TextSpan(
          style: textStyle,
          children: [
            const TextSpan(text: 'Find the '),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              // Single widget: owns hit-testing, visual feedback, AND the tap
              child: _TappableButtonWord(
                style: textStyle,
                onCorrectTap: controller.handleCorrectTap,
              ),
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }
}

// ── The "button" word with subtle press feedback ───────────────────────────
//
// ONE GestureDetector handles everything:
//   onTap          → triggers correct-tap game logic
//   onTapDown/Up   → drives the scale animation
//
// No nested detectors — avoids gesture arena conflict with the outer
// full-screen wrong-tap handler.

class _TappableButtonWord extends StatefulWidget {
  final TextStyle style;
  final VoidCallback onCorrectTap;
  const _TappableButtonWord({required this.style, required this.onCorrectTap});

  @override
  State<_TappableButtonWord> createState() => _TappableButtonWordState();
}

class _TappableButtonWordState extends State<_TappableButtonWord>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Single detector — wins the arena, owns all events
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _anim.forward(),
      onTapUp: (_) {
        _anim.reverse();
        widget.onCorrectTap(); // ← fires after visual feedback starts
      },
      onTapCancel: () => _anim.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Text(
          'button',
          style: widget.style.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}


// ── Living background ──────────────────────────────────────────────────────

class _LivingBackground extends StatefulWidget {
  const _LivingBackground();

  @override
  State<_LivingBackground> createState() => _LivingBackgroundState();
}

class _LivingBackgroundState extends State<_LivingBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        painter: _BackgroundPainter(_controller.value),
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final double progress;
  _BackgroundPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGreen.withValues(alpha: 0.015)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100)
      ..style = PaintingStyle.fill;

    final x = size.width * (0.5 + 0.2 * sin(progress * 2 * pi));
    final y = size.height * (0.5 + 0.2 * cos(progress * 2 * pi));
    canvas.drawCircle(Offset(x, y), size.width * 0.6, paint);
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter old) => true;
}
