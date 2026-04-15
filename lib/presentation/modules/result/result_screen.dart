import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'result_controller.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResultController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: controller.handleTap,
        child: SafeArea(
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Obx(() {
            final logs = controller.logs;
            final isProcessing = controller.isProcessing.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header — system label
                Text(
                  '> think.sys / result',
                  style: AppTextStyles.codeLabel.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 32),

                // Log list — rendered reactively as logs are emitted
                Expanded(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final line = logs[index];
                      final isLastLine = index == logs.length - 1;
                      final isResultLine = line.contains('ACCEPTED') || line.contains('REJECTED');

                      // Determine line color
                      Color lineColor;
                      if (line.contains('ACCEPTED') || line.contains('access granted') || line.contains('next sequence')) {
                        lineColor = AppColors.interactiveGreen;
                      } else if (line.contains('REJECTED') || line.contains('invalid input')) {
                        lineColor = AppColors.textMuted; // muted gray — not bright red
                      } else {
                        lineColor = AppColors.textSecondary;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                line,
                                style: AppTextStyles.codeLabel.copyWith(
                                  color: lineColor,
                                  fontSize: isResultLine ? 15 : 13,
                                ),
                              ),
                            ),
                            // Blinking cursor on the last active line
                            if (isLastLine && isProcessing)
                              _BlinkingCursor(),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom status — shows while processing
                if (isProcessing)
                  Text(
                    '> processing...',
                    style: AppTextStyles.codeLabel.copyWith(color: AppColors.textMuted),
                  ),
              ],
            );
          }),
        ),
      ),
    ));
  }
}

// Isolated blinking cursor widget — pure UI, no state leakage
class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: const Text(
        ' █',
        style: TextStyle(
          color: AppColors.primaryGreen,
          fontFamily: AppTextStyles.monospaceFont,
          fontSize: 13,
        ),
      ),
    );
  }
}
