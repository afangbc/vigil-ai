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
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 24),
                const VigilLogo(compact: true),
                const Spacer(),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.safe.withValues(alpha: 0.12),
                    border: Border.all(
                      color: AppColors.safe.withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.safe,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Drive Complete',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: SummaryStatTile(
                        label: 'Duration',
                        value: formatMinutes(state.elapsedDriving),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryStatTile(
                        label: 'Focus Score',
                        value: '${state.focusScore}%',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SummaryStatTile(
                        label: 'Drowsiness Alerts',
                        value: '${state.drowsinessAlertCount}',
                        valueColor: state.drowsinessAlertCount > 0
                            ? AppColors.warning
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryStatTile(
                        label: 'Pauses',
                        value: '${state.pauseCount}',
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
