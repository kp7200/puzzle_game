import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Obx(
            () => Stack(
              children: [
                // Glitchy background flicker
                if (controller.isGlitching.value)
                  Positioned.fill(
                    child: Container(
                      color: AppColors.primaryGreen.withOpacity(0.05),
                    ),
                  ),

                Transform.translate(
                  offset: controller.isGlitching.value
                      ? Offset(Random().nextDouble() * 4 - 2, Random().nextDouble() * 4 - 2)
                      : Offset.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      
                      // Animated Logs
                      Expanded(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.activeLogs.length,
                          itemBuilder: (context, index) {
                            final log = controller.activeLogs[index];
                            final isLast = index == controller.activeLogs.length - 1;
                            
                            // Color variation for specific lines
                            Color textColor = AppColors.textPrimary;
                            if (log == '...' || log == 'oh.') {
                              textColor = AppColors.interactiveGreen;
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: isLast 
                                ? DefaultTextStyle(
                                    style: AppTextStyles.codeLabel.copyWith(color: textColor),
                                    child: AnimatedTextKit(
                                      animatedTexts: [
                                        TypewriterAnimatedText(
                                          log,
                                          speed: Duration(milliseconds: 40 + Random().nextInt(40)),
                                          cursor: '█',
                                        ),
                                      ],
                                      isRepeatingAnimation: false,
                                    ),
                                  )
                                : Text(log, style: AppTextStyles.codeLabel.copyWith(color: textColor)),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
