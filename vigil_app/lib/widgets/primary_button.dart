import 'package:flutter/material.dart';

/// Large, single-purpose button used for the one primary action on each
/// screen. Styling comes entirely from `AppTheme.dark`'s
/// `elevatedButtonTheme`, so this widget stays a thin wrapper.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: backgroundColor == null
            ? null
            : ElevatedButton.styleFrom(backgroundColor: backgroundColor),
        child: Text(label),
      ),
    );
  }
}
