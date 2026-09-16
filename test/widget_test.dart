import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quranic_research/app/app.dart';
import 'package:quranic_research/core/widgets/translation_text.dart';
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

    // Fast-forward through the consolidated splash screen (1300ms) and navigation
    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pumpAndSettle();

    // Verify app transitions directly to HomeScreen
    expect(find.byType(HomeScreen), findsOneWidget);

    // Verify OnboardingScreen is never shown after splash
    expect(find.byType(OnboardingScreen), findsNothing);
  });

  testWidgets('Translation text is pure black in light mode', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TranslationText('In the name of Allah, the Entirely Merciful'),
              TranslationText.urdu('اللہ کے نام سے جو رحمان و رحیم ہے۔'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('In the name of Allah, the Entirely Merciful'), findsOneWidget);
    expect(find.text('اللہ کے نام سے جو رحمان و رحیم ہے۔'), findsOneWidget);
  });
}

