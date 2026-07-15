import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vigil_app/main.dart';

void main() {
  testWidgets('VigilApp builds and shows the home screen', (tester) async {
    await tester.pumpWidget(const VigilApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
