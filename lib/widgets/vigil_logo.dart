import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shared wordmark used on every screen. No imagery/iconography beyond
/// text — keeps the "extremely minimal" look and avoids needing real art
/// assets for a prototype.
class VigilLogo extends StatelessWidget {
  const VigilLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Text(
      'VIGIL',
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: compact ? 22 : 40,
        fontWeight: FontWeight.w700,
        letterSpacing: compact ? 4 : 8,
      ),
    );
  }
}
