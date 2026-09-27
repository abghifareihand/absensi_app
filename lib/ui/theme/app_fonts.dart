import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppFonts {
  static const String _family = 'Poppins';

  static TextStyle _textStyle({
    required FontWeight fontWeight,
    Color color = AppColors.textDark,
    double fontSize = 14.0,
    double? height,
  }) {
    return TextStyle(
      fontFamily: _family,
      fontWeight: fontWeight,
      color: color,
      fontSize: fontSize,
      height: height,
    );
  }

  static TextStyle get light => _textStyle(fontWeight: FontWeight.w300);
  static TextStyle get regular => _textStyle(fontWeight: FontWeight.w400);
  static TextStyle get medium => _textStyle(fontWeight: FontWeight.w500);
  static TextStyle get semiBold => _textStyle(fontWeight: FontWeight.w600);
  static TextStyle get bold => _textStyle(fontWeight: FontWeight.w700);

  // Modern Semantic Typographies
  static TextStyle get h1 => _textStyle(fontWeight: FontWeight.w700, fontSize: 24.0, height: 1.3);
  static TextStyle get h2 => _textStyle(fontWeight: FontWeight.w600, fontSize: 20.0, height: 1.3);
  static TextStyle get h3 => _textStyle(fontWeight: FontWeight.w600, fontSize: 16.0, height: 1.4);
  static TextStyle get body => _textStyle(fontWeight: FontWeight.w400, fontSize: 14.0, height: 1.5);
  static TextStyle get bodySemiBold => _textStyle(fontWeight: FontWeight.w600, fontSize: 14.0, height: 1.5);
  static TextStyle get caption => _textStyle(fontWeight: FontWeight.w400, fontSize: 12.0, color: AppColors.textSecondary, height: 1.4);
  static TextStyle get badge => _textStyle(fontWeight: FontWeight.w600, fontSize: 11.0, height: 1.2);
}