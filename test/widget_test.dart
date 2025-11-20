import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:pocketflow/main.dart' as app;

void main() {
  testWidgets('App starts and shows title', (WidgetTester tester) async {
    await tester.pumpWidget(const app.PocketFlowApp());
    expect(find.text('PocketFlow'), findsOneWidget);
  });
}
