import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shared rounded, bordered container used to group related content
/// (metrics, stats) into a visually distinct block instead of loose text
/// floating on the background.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: child,
    );
  }
}
