import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/session_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/primary_button.dart';
import '../widgets/vigil_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.safe.withValues(alpha: 0.12),
                    border: Border.all(
                      color: AppColors.safe.withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.remove_red_eye_rounded,
                    color: AppColors.safe,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 28),
                const VigilLogo(),
                const SizedBox(height: 16),
                const Text(
                  'Vigil monitors alertness and helps reduce '
                  'distracted driving.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 56),
                PrimaryButton(
                  label: 'Start Driving Session',
                  onPressed: () =>
                      context.read<SessionController>().startSession(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
