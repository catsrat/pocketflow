import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketflow/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const app.PocketFlowApp());
    await tester.pumpAndSettle();
    expect(find.text('PocketFlow'), findsOneWidget);
  });
}
