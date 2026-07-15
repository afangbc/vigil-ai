import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Rounded horizontal bar that depletes from full to empty as [fraction]
/// (1.0 -> 0.0) counts down. Used to make the Safe Pause timer legible at a
/// glance without reading the exact number.
class CountdownBar extends StatelessWidget {
  const CountdownBar({super.key, required this.fraction, required this.color});

  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 12,
        child: Stack(
          children: [
            Container(color: AppColors.surfaceMuted),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction.clamp(0.0, 1.0),
              child: Container(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
