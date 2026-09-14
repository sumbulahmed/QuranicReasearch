import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'step': 'EXPLORE',
      'title': 'Quran & Hadith',
      'subtitle':
          'Immerse yourself in the divine words of the Noble Quran and authentic Prophetic Hadith with pristine Arabic typography, English and Urdu translations.',
      'icon': Icons.menu_book_rounded,
      'badge': 'Sacred Text Core',
      'color': AppColors.primaryEmerald,
    },
    {
      'step': 'UNDERSTAND',
      'title': 'Tafseer & Explanations',
      'subtitle':
          'Gain profound clarity through authoritative classical Tafseer (Ibn Kathir, Al-Qurtubi, At-Tabari) and contextual scholarly commentary.',
      'icon': Icons.auto_stories_rounded,
      'badge': 'Scholarly Hermeneutics',
      'color': AppColors.accentGold,
    },
    {
      'step': 'DISCOVER',
      'title': 'Scientific Perspectives',
      'subtitle':
          'Explore empirical correlations in human embryology, oceanography, circadian neurology, and astrophysics through transparent, rigorous inquiry.',
      'icon': Icons.science_rounded,
      'badge': 'Natural Phenomena',
      'color': AppColors.accentTeal,
    },
    {
      'step': 'RESEARCH',
      'title': 'Credible Research & Sources',
      'subtitle':
          'Navigate peer-reviewed scientific literature with verifiable DOIs, academic journals, and a 4-tier taxonomy separating verified facts from internet myths.',
      'icon': Icons.verified_rounded,
      'badge': 'Evidence Taxonomy',
      'color': AppColors.accentCyan,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Skip'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  itemBuilder: (context, index) {
                    final p = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: (p['color'] as Color).withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            p['icon'] as IconData,
                            size: 54,
                            color: p['color'] as Color,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: (p['color'] as Color).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (p['color'] as Color).withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            p['step'] as String,
                            style: AppTypography.labelSmall.copyWith(
                              color: p['color'] as Color,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          p['title'] as String,
                          textAlign: TextAlign.center,
                          style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          p['subtitle'] as String,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Dots indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primaryEmerald
                          : AppColors.lightBorder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      context.go('/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryEmerald,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Start Journey' : 'Continue',
                    style: AppTypography.titleMedium.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
