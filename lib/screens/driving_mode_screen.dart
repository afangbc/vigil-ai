import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../debug/debug_controls.dart';
import '../models/driver_status.dart';
import '../state/session_controller.dart';
import '../theme/app_colors.dart';
import '../utils/duration_format.dart';
import '../widgets/primary_button.dart';
import '../widgets/status_indicator.dart';
import '../widgets/vigil_logo.dart';

/// The screen shown for the entire duration of a drive. Deliberately shows
/// nothing but status, duration, and focus score — no camera feed, no
/// landmarks, no technical detail — and needs no interaction from the
/// driver except Pause/End.
class DrivingModeScreen extends StatelessWidget {
  const DrivingModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SessionController>().state;
    final isTired = state.driverStatus != DriverStatus.alert;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                children: [
                  const VigilLogo(compact: true),
                  const Spacer(flex: 2),
                  StatusIndicator(status: state.driverStatus),
                  if (isTired) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'You seem tired. Consider taking a break.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                  ],
                  const Spacer(flex: 1),
                  _MetricRow(
                    duration: state.elapsedDriving,
                    focusScore: state.focusScore,
                  ),
                  const Spacer(flex: 2),
                  PrimaryButton(
                    label: 'Pause Driving Session',
                    onPressed: () =>
                        context.read<SessionController>().pauseSession(),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () =>
                        context.read<SessionController>().endSession(),
                    child: const Text('End Drive'),
                  ),
                ],
              ),
            ),
            const DebugControls(),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.duration, required this.focusScore});

  final Duration duration;
  final int focusScore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Metric(label: 'Duration', value: formatClock(duration)),
        _Metric(label: 'Focus Score', value: '$focusScore%'),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
