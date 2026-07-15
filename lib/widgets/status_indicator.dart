import 'package:flutter/material.dart';

import '../models/driver_status.dart';
import '../theme/status_colors.dart';

/// The single most important element on the Driving Mode screen: a large
/// colored status word. Deliberately has no icon, animation, or secondary
/// detail — just the color/label pairing the driver needs at a glance.
class StatusIndicator extends StatelessWidget {
  const StatusIndicator({super.key, required this.status});

  final DriverStatus status;

  @override
  Widget build(BuildContext context) {
    final color = colorForStatus(status);
    return Text(
      status.label,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: 34,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
