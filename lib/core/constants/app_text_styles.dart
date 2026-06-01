import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppTextStyles {
  // ── Heading ──
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 1.4,
  );
  static const TextStyle heading1Medium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );
  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  // ── Body ──
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );
  static const TextStyle body1Medium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );
  static const TextStyle body1SemiBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );
  static const TextStyle body2 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );
  static const TextStyle body2SemiBold = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  // ── Caption ──
  static const TextStyle caption1 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.grey600,
  );
  static const TextStyle caption2 = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.grey600,
  );
  static const TextStyle caption3 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey600,
  );

  // ── Subtitle (muted) ──
  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.grey600,
  );

  // ── Button ──
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // ── App title ──
  static const TextStyle appTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.successNormal,
  );
}
