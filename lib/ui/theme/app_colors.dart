import 'package:flutter/material.dart';

class AppColors {
  // Brand Solid Colors (Original Preserved)
  static const Color primary = Color(0xFF1B9256);
  static const Color primaryDark = Color(0xFF136E40);
  static const Color primarySubtle = Color(0xFFE8F7EE);

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF1F5F9);

  static const Color gray = Color(0xFFDBDBDB);
  static const Color grayLight = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);

  static const Color black = Color(0xFF000000);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color white = Color(0xFFFFFFFF);

  // Status & Feedback Solid Colors
  static const Color red = Color(0xFFFF383C);
  static const Color redSubtle = Color(0xFFFEE2E2);

  static const Color orange = Color(0xFFFF8D28);
  static const Color orangeSubtle = Color(0xFFFEF3C7);

  static const Color green = Color(0xFF34C759);
  static const Color greenSubtle = Color(0xFFDCFCE7);

  static const Color blue = Color(0xFF2563EB);
  static const Color blueSubtle = Color(0xFFEFF6FF);

  static const Color purple = Color(0xFF7C3AED);
  static const Color purpleSubtle = Color(0xFFF3E8FF);

  // Modern Soft Shadows
  static List<BoxShadow> get softShadow => const [
    BoxShadow(
      color: Color(0x080F172A),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get cardShadow => const [
    BoxShadow(
      color: Color(0x0C0F172A),
      blurRadius: 20,
      offset: Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get floatShadow => const [
    BoxShadow(
      color: Color(0x140F172A),
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];
}
