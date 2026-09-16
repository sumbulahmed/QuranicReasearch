import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/vintage_letter_splash.dart';

/// Single, consolidated Splash Screen for the application.
/// Displays a cinematic 2D animated vintage sealed parchment letter being opened,
/// revealing the BAYAN sacred brand emblem, and dissolving directly into the Home screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  void _navigateToHome() {
    if (!mounted || _navigated) return;
    _navigated = true;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return VintageLetterSplash(
      onComplete: _navigateToHome,
    );
  }
}
