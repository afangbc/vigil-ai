import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/session_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/primary_button.dart';
import '../widgets/vigil_logo.dart';

/// Shown when the driver manually pauses (e.g. at a red light). Deliberately
/// bare — no free-use affordances — so pausing doesn't become an invitation
/// to browse the phone.
class SafePauseScreen extends StatelessWidget {
  const SafePauseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const VigilLogo(compact: true),
              const SizedBox(height: 48),
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
              const SizedBox(height: 48),
              PrimaryButton(
                label: 'Resume Driving',
                onPressed: () =>
                    context.read<SessionController>().resumeSession(),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () =>
                    context.read<SessionController>().endSession(),
                child: const Text('End Drive Instead'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
