import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/pause_config.dart';
import '../state/session_controller.dart';
import '../theme/app_colors.dart';
import '../utils/duration_format.dart';
import '../widgets/countdown_bar.dart';
import '../widgets/surface_card.dart';
import '../widgets/vigil_logo.dart';

/// Shown when the driver manually pauses (e.g. at a red light). The break
/// always runs the full [PauseConfig.duration] and auto-resumes when the
/// countdown ends — deliberately no early-resume affordance, so pausing
/// doesn't become an invitation to browse the phone past a real stop.
class SafePauseScreen extends StatelessWidget {
  const SafePauseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final remaining = context.watch<SessionController>().state.pauseRemaining;
    final totalMs = PauseConfig.duration.inMilliseconds;
    final fraction = totalMs == 0 ? 0.0 : remaining.inMilliseconds / totalMs;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const VigilLogo(compact: true),
                const SizedBox(height: 40),
                const Text(
                  'Session Paused',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.warning,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Only use your phone when stopped safely.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),
                SurfaceCard(
                  child: Column(
                    children: [
                      Text(
                        formatClock(remaining),
                        style: const TextStyle(
                          color: AppColors.warning,
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'until driving resumes',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CountdownBar(fraction: fraction, color: AppColors.warning),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () =>
                      context.read<SessionController>().endSession(),
                  child: const Text('End Drive Instead'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
