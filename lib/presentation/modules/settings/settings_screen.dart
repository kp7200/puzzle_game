import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'settings_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsController controller;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SettingsController());
    _nameController = TextEditingController(text: controller.username.value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: Text(
                      '←',
                      style: AppTextStyles.sectionHeading.copyWith(
                        fontSize: 20,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'SETTINGS',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 3.0,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // ── Section: IDENTITY ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(label: 'IDENTITY'),
                  const SizedBox(height: 20),
                  // Username field
                  Obx(() {
                    final success = controller.saveSuccess.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'username',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 12,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
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
                            hintText: 'enter username',
                            hintStyle: AppTextStyles.body.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 16,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: success
                                    ? AppColors.primaryGreen
                                    : AppColors.primaryGreen,
                                width: 1.5,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onSubmitted: (value) =>
                              controller.saveUsername(value),
                        ),
                        // Inline error
                        if (controller.usernameInputError.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              controller.usernameInputError.value,
                              style: AppTextStyles.body.copyWith(
                                color: Colors.redAccent.shade100,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        if (success)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              'saved.',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.primaryGreen,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                  const SizedBox(height: 32),
                  // SAVE button
                  GestureDetector(
                    onTap: () => controller.saveUsername(_nameController.text),
                    child: Obx(() => Text(
                          controller.isSaving.value ? '...' : '[ SAVE ]',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.primaryGreen,
                            letterSpacing: 2.0,
                            fontSize: 13,
                          ),
                        )),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),
            const _Divider(),
            const SizedBox(height: 48),

            // ── Section: SYSTEM ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(label: 'SYSTEM'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'dark mode',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      // Placeholder — always enabled
                      Text(
                        'ON',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'this is the only theme.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Subcomponents ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.body.copyWith(
        color: AppColors.textMuted,
        fontSize: 11,
        letterSpacing: 3.0,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Divider(color: AppColors.divider, height: 1),
    );
  }
}
