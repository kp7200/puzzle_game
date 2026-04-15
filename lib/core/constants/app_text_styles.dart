import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String primaryFont = 'Circular';
  static const String monospaceFont = 'Source Code Pro';

  static const TextStyle hero = TextStyle(
    fontFamily: primaryFont,
    fontSize: 72,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle sectionHeading = TextStyle(
    fontFamily: primaryFont,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: -0.16,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    color: AppColors.textPrimary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.14,
    color: AppColors.textPrimary,
  );

  static const TextStyle codeLabel = TextStyle(
    fontFamily: monospaceFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    color: AppColors.primaryGreen,
  );
}
