import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import 'puzzle_controller.dart';

class PuzzleScreen extends StatelessWidget {
  const PuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PuzzleController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Obx(() {
            final puzzle = controller.currentPuzzle.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                if (puzzle != null) ...[
                  // Level ID
                  Text('> Level ${puzzle.id}', style: AppTextStyles.codeLabel),
                  const SizedBox(height: 24),

                  // Puzzle prompt
                  Text(
                    puzzle.question,
                    style: AppTextStyles.codeLabel.copyWith(color: AppColors.textPrimary),
                  ),

                  const SizedBox(height: 32),

                  // Revealed hints
                  if (controller.revealedHints.isNotEmpty) ...[
                    ...controller.revealedHints.map(
                      (hint) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '> hint: $hint',
                          style: AppTextStyles.codeLabel.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // "No more hints" system message
                  if (controller.noMoreHints.value)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        '> no more hints available',
                        style: AppTextStyles.codeLabel.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                ] else ...[
                  // End screen text mapped directly like terminal output
                  Text(
                    controller.feedbackMessage.value,
                    style: AppTextStyles.codeLabel.copyWith(color: AppColors.textSecondary),
                  ),
                ],

                const Spacer(),

                // Feedback message (for normal puzzle errors/inputs)
                if (puzzle != null && controller.feedbackMessage.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      controller.feedbackMessage.value,
                      style: AppTextStyles.codeLabel.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                // ALWAYS SHOW Input field so `reset` can be typed
                TextField(
                  controller: controller.inputText,
                  style: AppTextStyles.codeLabel.copyWith(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('>', style: AppTextStyles.codeLabel),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    hintText: 'Awaiting command...',
                  ),
                  onSubmitted: (_) => controller.submitAnswer(),
                  autofocus: false,
                ),

                const SizedBox(height: 12),

                // Action row
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.submitAnswer,
                        child: const Text('SUBMIT'),
                      ),
                    ),
                    if (puzzle != null) ...[
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: controller.requestHint,
                        child: Text(
                          'HINT',
                          style: AppTextStyles.codeLabel.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 24),
              ],
            );
          }),
        ),
      ),
    );
  }
}
