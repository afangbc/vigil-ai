import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shared wordmark used on every screen, paired with a small eye mark so
/// the brand reads as more than plain text without needing real art assets.
class VigilLogo extends StatelessWidget {
  const VigilLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 20.0 : 32.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.remove_red_eye_rounded, color: AppColors.safe, size: iconSize),
        SizedBox(width: compact ? 8 : 12),
        Text(
          'VIGIL',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: compact ? 22 : 40,
            fontWeight: FontWeight.w700,
            letterSpacing: compact ? 4 : 8,
          ),
        ),
      ],
    );
  }
}
