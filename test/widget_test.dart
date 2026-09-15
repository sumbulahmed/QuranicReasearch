import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quranic_research/app/app.dart';
import 'package:quranic_research/features/home/presentation/home_screen.dart';
import 'package:quranic_research/features/onboarding/presentation/onboarding_screen.dart';
import 'package:quranic_research/features/splash/presentation/splash_screen.dart';

void main() {
  testWidgets('App startup flow: Launch -> Splash -> Home (No Onboarding)', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: QuranicResearchApp(),
      ),
    );

    // Initial frame builds successfully and shows SplashScreen
    expect(find.byType(QuranicResearchApp), findsOneWidget);
    expect(find.byType(SplashScreen), findsOneWidget);

    // Verify OnboardingScreen is not shown initially
    expect(find.byType(OnboardingScreen), findsNothing);

    // Fast-forward through the letter animation (3600ms) and navigation timer (350ms)
    await tester.pump(const Duration(milliseconds: 3700));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify app transitions directly to HomeScreen
    expect(find.byType(HomeScreen), findsOneWidget);

    // Verify OnboardingScreen is never shown after splash
    expect(find.byType(OnboardingScreen), findsNothing);
  });
}

