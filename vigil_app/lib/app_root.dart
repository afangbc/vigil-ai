import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/session_phase.dart';
import 'screens/driving_mode_screen.dart';
import 'screens/home_screen.dart';
import 'screens/safe_pause_screen.dart';
import 'screens/session_summary_screen.dart';
import 'state/session_controller.dart';

/// Selects the active screen from [SessionPhase] alone — the app has no
/// navigation stack. [PopScope] blocks the back gesture except on the idle
/// (Home) screen, so a driver can't accidentally back out of Driving Mode
/// or Safe Pause into a stale screen.
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final phase = context.watch<SessionController>().state.phase;

    return PopScope(
      canPop: phase == SessionPhase.idle,
      child: switch (phase) {
        SessionPhase.idle => const HomeScreen(),
        SessionPhase.driving => const DrivingModeScreen(),
        SessionPhase.paused => const SafePauseScreen(),
        SessionPhase.summary => const SessionSummaryScreen(),
      },
    );
  }
}
