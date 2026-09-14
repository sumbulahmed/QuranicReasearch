import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quranic_research/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: QuranicResearchApp(),
      ),
    );

    // Initial frame builds successfully
    expect(find.byType(QuranicResearchApp), findsOneWidget);

    // Fast-forward past splash screen delay so no timers remain pending
    await tester.pump(const Duration(milliseconds: 1500));
  });
}
