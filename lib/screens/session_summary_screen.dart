import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/session_controller.dart';
import '../theme/app_colors.dart';
import '../utils/duration_format.dart';
import '../widgets/primary_button.dart';
import '../widgets/summary_stat_tile.dart';
import '../widgets/vigil_logo.dart';

class SessionSummaryScreen extends StatelessWidget {
  const SessionSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SessionController>().state;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const VigilLogo(compact: true),
              const Spacer(),
              const Text(
                'Drive Complete',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 32),
              SummaryStatTile(
                label: 'Duration',
                value: formatMinutes(state.elapsedDriving),
              ),
              SummaryStatTile(
                label: 'Focus Score',
                value: '${state.focusScore}%',
              ),
              SummaryStatTile(
                label: 'Drowsiness Alerts',
                value: '${state.drowsinessAlertCount}',
              ),
              SummaryStatTile(
                label: 'Pauses',
                value: '${state.pauseCount}',
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Done',
                onPressed: () =>
                    context.read<SessionController>().resetToHome(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
