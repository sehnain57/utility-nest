import 'package:flutter/material.dart';

/// "Aurora Neon" — a dark-first, glassmorphic 2026-style palette:
/// deep space background + vivid lime, electric blue, coral and violet accents.
class AppColors {
  AppColors._();

  static const Color bgDark = Color(0xFF0A0E17);
  static const Color bgDarkAlt = Color(0xFF101524);
  static const Color surfaceDark = Color(0xFF161C2C);
  static const Color bgLight = Color(0xFFF6F8FC);
  static const Color surfaceLight = Colors.white;
  static const Color cardLightSoft = Color(0xFFFFFFFF);
  static const Color cardDarkSoft = Color(0xFF151B2B);

  static const Color lime = Color(0xFFB6FF3C); // signature accent
  static const Color sky = Color(0xFF38BDF8);
  static const Color coral = Color(0xFFFF6B6B);
  static const Color violet = Color(0xFFA78BFA);
  static const Color mint = Color(0xFF2DD4BF);
  static const Color amber = Color(0xFFFFC65C);

  static const Color textPrimaryDark = Color(0xFFF3F5FB);
  static const Color textSecondaryDark = Color(0xFF9AA3B8);
  static const Color textPrimaryLight = Color(0xFF12141E);
  static const Color textSecondaryLight = Color(0xFF6C7285);

  static const List<Color> gradLime = [Color(0xFFB6FF3C), Color(0xFF2DD4BF)];
  static const List<Color> gradSky = [Color(0xFF38BDF8), Color(0xFF6366F1)];
  static const List<Color> gradCoral = [Color(0xFFFF6B6B), Color(0xFFFFC65C)];
  static const List<Color> gradViolet = [Color(0xFFA78BFA), Color(0xFFEC4899)];
  static const List<Color> gradMint = [Color(0xFF2DD4BF), Color(0xFF38BDF8)];
  static const List<Color> gradAmber = [Color(0xFFFFC65C), Color(0xFFFF6B6B)];
  static const List<Color> gradDeep = [Color(0xFF6366F1), Color(0xFF2DD4BF)];
  static const List<Color> gradRose = [Color(0xFFEC4899), Color(0xFFA78BFA)];

  static const List<List<Color>> toolGradients = [
    gradLime, gradSky, gradCoral, gradViolet, gradMint, gradAmber, gradDeep, gradRose,
  ];
}
