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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
    );
  }
}
