import 'package:flutter/material.dart';

/// Single source of truth for Vigil's color palette. Screens and widgets
/// should never construct `Color(...)` literals directly — reference these
/// so the dark/safety-first look stays consistent everywhere.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0B0D10);
  static const Color surface = Color(0xFF15181C);
  static const Color surfaceMuted = Color(0xFF1D2126);

  static const Color textPrimary = Color(0xFFE8EAED);
  static const Color textSecondary = Color(0xFF8A9099);

  static const Color safe = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF5C518);
  static const Color danger = Color(0xFFE74C3C);
}
