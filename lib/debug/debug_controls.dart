import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/session_controller.dart';
import '../theme/app_colors.dart';

/// Demo-only trigger for the drowsy/critical states, since Phase 1 has no
/// real detector. Only renders in debug builds ([kDebugMode]), stays
/// visually secondary (small, corner-anchored, muted), and lives entirely
/// in this file so it can be deleted as a unit once real detection lands.
class DebugControls extends StatelessWidget {
  const DebugControls({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    final controller = context.read<SessionController>();

    return Positioned(
      right: 12,
      bottom: 12,
      child: Opacity(
        opacity: 0.6,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DebugChip(
              label: 'Simulate drowsy',
              onTap: () => controller.debugTriggerDrowsy(true),
            ),
            const SizedBox(width: 8),
            _DebugChip(
              label: 'Clear',
              onTap: () => controller.debugTriggerDrowsy(false),
            ),
          ],
        ),
      ),
    );
  }
}

class _DebugChip extends StatelessWidget {
  const _DebugChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
