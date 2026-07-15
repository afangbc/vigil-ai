import 'package:flutter/material.dart';

import '../models/driver_status.dart';
import '../theme/status_colors.dart';

/// The single most important element on the Driving Mode screen: a large
/// glowing status badge. Deliberately has no animation or secondary detail
/// beyond an icon — just the color/icon/label pairing the driver needs at
/// a glance, sized to be readable without looking away from the road long.
class StatusIndicator extends StatelessWidget {
  const StatusIndicator({super.key, required this.status});

  final DriverStatus status;

  IconData get _icon => switch (status) {
        DriverStatus.alert => Icons.visibility_rounded,
        DriverStatus.drowsy => Icons.visibility_off_rounded,
        DriverStatus.critical => Icons.warning_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final color = colorForStatus(status);

    return Column(
      children: [
        Container(
          width: 132,
          height: 132,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.12),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.28),
                blurRadius: 36,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(_icon, color: color, size: 56),
        ),
        const SizedBox(height: 20),
        Text(
          status.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
