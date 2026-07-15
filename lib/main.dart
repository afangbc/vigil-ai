import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_root.dart';
import 'state/session_controller.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const VigilApp());
}

class VigilApp extends StatelessWidget {
  const VigilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SessionController(),
      child: MaterialApp(
        title: 'Vigil',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const AppRoot(),
      ),
    );
  }
}
