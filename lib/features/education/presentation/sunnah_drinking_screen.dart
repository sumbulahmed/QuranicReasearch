import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/models/evidence_level.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/arabic_text.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/evidence_badge.dart';
import '../../../../core/widgets/research_citation_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/providers/app_providers.dart';
import '../domain/entities/practice_step.dart';
import '../domain/entities/sunnah_practice.dart';
import 'widgets/animated_water_glass.dart';
import 'widgets/breathing_animation_widget.dart';
import 'widgets/posture_swallowing_diagram.dart';
import 'widgets/practice_walkthrough_sheet.dart';

class SunnahDrinkingScreen extends ConsumerStatefulWidget {
  const SunnahDrinkingScreen({super.key});

  @override
  ConsumerState<SunnahDrinkingScreen> createState() =>
      _SunnahDrinkingScreenState();
}

class _SunnahDrinkingScreenState extends ConsumerState<SunnahDrinkingScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _scienceSectionKey = GlobalKey();

  int _selectedStepIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToScience() {
    final context = _scienceSectionKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final practiceAsync = ref.watch(sunnahDrinkingPracticeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sunnah & Science',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Sunnah',
            onPressed: () {
              Clipboard.setData(
                const ClipboardData(
                  text:
                      'The Sunnah of Drinking Water: Drink calmly in three sips, pause, and breathe outside the vessel (Sahih Muslim 2028a). Explore on Quranic Research.',
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sunnah citation copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: AppBackground(
        child: practiceAsync.when(
          data: (practice) => _buildContent(context, practice, isDark),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Text('Error loading feature: $err'),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SunnahPractice practice,
    bool isDark,
  ) {
    final activeStep = practice.steps[_selectedStepIndex];

    return ListView(
      controller: _scrollController,
      padding: AppDimensions.paddingScreen,
      children: [
        // 1. FEATURE TITLE & HERO HEADER
        _buildHeroHeader(context, practice, isDark),
        const SizedBox(height: 16),

        // Quick Interaction Action Buttons
        _buildActionButtons(context, practice, isDark),
        const SizedBox(height: 24),

        // 2. SECTION 1 — THE SUNNAH (Sahih Muslim 2028a & 2028b)
        SectionHeader(
          title: 'The Prophetic Sunnah',
          subtitle: 'Authentic Hadiths on the Etiquette of Drinking',
        ),
        const SizedBox(height: 10),
        _buildPrimaryHadithCard(context, practice, isDark),
        const SizedBox(height: 14),
        _buildSecondaryHadithCard(context, practice, isDark),
        const SizedBox(height: 24),

        // 3. SECTION 2 — SITTING WHILE DRINKING (Sahih Muslim 2024a & Scholarly Nuance)
        SectionHeader(
          title: 'Posture & Scholarly Nuance',
          subtitle: 'Drinking Seated vs. Standing in Authentic Tradition',
        ),
        const SizedBox(height: 10),
        _buildStandingNuanceCard(context, practice, isDark),
        const SizedBox(height: 24),

        // 4. SECTION 3 — HOW TO PRACTICE THE SUNNAH (Interactive 9-Step Guide)
        SectionHeader(
          title: 'How to Practice the Sunnah',
          subtitle: 'Interactive Step-by-Step Deglutition & Respiratory Guide',
        ),
        const SizedBox(height: 10),
        _buildInteractiveStepComponent(context, practice, activeStep, isDark),
        const SizedBox(height: 28),

        // 5. SECTION 4 — 🔬 SCIENTIFIC PERSPECTIVE
        Container(key: _scienceSectionKey),
        SectionHeader(
          title: '🔬 Scientific Perspective',
          subtitle:
              'Modern Physiological Research on Posture, Bolus Volume & Breathing',
        ),
        const SizedBox(height: 10),
        _buildScientificPerspectiveIntro(context, practice, isDark),
        const SizedBox(height: 14),

        // Anatomical Diagram of Upright Deglutition
        const PostureSwallowingDiagram(),
        const SizedBox(height: 14),

        // 4 Scientific Findings Cards
        ...practice.scientificFindings.map(
          (finding) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildScientificFindingCard(context, finding, isDark),
          ),
        ),
        const SizedBox(height: 20),

        // 6. SECTION 5 — EVIDENCE LEVEL BADGE & EVALUATION
        SectionHeader(
          title: 'Evidence Classification',
          subtitle: 'Epistemological Evaluation & Degree of Empirical Support',
        ),
        const SizedBox(height: 10),
        _buildEvidenceEvaluationCard(context, practice, isDark),
        const SizedBox(height: 24),

        // 7. SECTION 6 — VERIFIED RESEARCH PAPERS
        SectionHeader(
          title: 'Peer-Reviewed Research',
          subtitle: 'Verified Citations from Swallowing & Respiratory Literature',
        ),
        const SizedBox(height: 10),
        ...practice.researchPapers.map(
          (paper) => Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: ResearchCitationCard(paper: paper),
          ),
        ),
        const SizedBox(height: 16),

        // 8. SECTION 7 — EDUCATIONAL DISCLAIMER
        _buildDisclaimerCard(context, practice, isDark),
        const SizedBox(height: 36),
      ],
    );
  }

  // --- 1. HERO HEADER ---
  Widget _buildHeroHeader(
    BuildContext context,
    SunnahPractice practice,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF28151A) : AppColors.primaryMaroon,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : AppColors.accentGold.withValues(alpha: 0.45),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryMaroon.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.accentGoldLight.withValues(alpha: 0.4),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  'AUTHENTIC PROPHETIC PRACTICE',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.accentGoldLight,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    fontSize: 9.5,
                  ),
                ),
              ),
              const EvidenceBadge(
                level: EvidenceLevel.moderate,
                compact: true,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ArabicText(
            practice.titleArabic,
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          const SizedBox(height: 4),
          Text(
            practice.titleEnglish,
            style: AppTypography.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            practice.subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              fontStyle: FontStyle.italic,
              fontSize: 13.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- QUICK ACTION BUTTONS ---
  Widget _buildActionButtons(
    BuildContext context,
    SunnahPractice practice,
    bool isDark,
  ) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () =>
                PracticeWalkthroughSheet.show(context, practice.steps),
            icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
            label: const Text('Watch How to Practice'),
            style: FilledButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.accentGoldLight
                  : AppColors.primaryMaroon,
              foregroundColor: isDark ? Colors.black : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _scrollToScience,
            icon: const Icon(Icons.science_outlined, size: 18),
            label: const Text('Explore the Science'),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark
                  ? AppColors.accentGoldLight
                  : AppColors.primaryMaroon,
              side: BorderSide(
                color: isDark
                    ? AppColors.darkBorder
                    : AppColors.primaryMaroon.withValues(alpha: 0.4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  // --- SECTION 1: PRIMARY HADITH CARD ---
  Widget _buildPrimaryHadithCard(
    BuildContext context,
    SunnahPractice practice,
    bool isDark,
  ) {
    final hadith = practice.hadiths.firstWhere(
      (h) => h.id == 'hadith_muslim_2028a',
      orElse: () => practice.hadiths.first,
    );

    return AppCard(
      showMaroonAccent: true,
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${hadith.collection} ${hadith.hadithNumber}',
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.evidenceStrong.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  hadith.grade,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.evidenceStrong,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ArabicText(
            hadith.textArabic,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 10),
          Text(
            hadith.textEnglish,
            style: AppTypography.hadithMatnEnglish.copyWith(
              color: isDark ? AppColors.translationTextDark : AppColors.translationTextLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const CustomDivider(showOrnament: true, verticalPadding: 10),
          Text(
            hadith.commentary,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hadith.book,
            style: AppTypography.labelSmall.copyWith(
              color: isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTION 1: SECONDARY HADITH CARD ---
  Widget _buildSecondaryHadithCard(
    BuildContext context,
    SunnahPractice practice,
    bool isDark,
  ) {
    final hadith = practice.hadiths.firstWhere(
      (h) => h.id == 'hadith_muslim_2028b',
      orElse: () => practice.hadiths[1],
    );

    return AppCard(
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${hadith.collection} ${hadith.hadithNumber}',
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.evidenceStrong.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  hadith.grade,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.evidenceStrong,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ArabicText(
            hadith.textArabic,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          Text(
            hadith.textEnglish,
            style: AppTypography.hadithMatnEnglish.copyWith(
              color: isDark ? AppColors.translationTextDark : AppColors.translationTextLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hadith.commentary,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTION 2: STANDING WHILE DRINKING & NUANCE ---
  Widget _buildStandingNuanceCard(
    BuildContext context,
    SunnahPractice practice,
    bool isDark,
  ) {
    final hadith = practice.hadiths.firstWhere(
      (h) => h.id == 'hadith_muslim_2024a',
      orElse: () => practice.hadiths.last,
    );

    return AppCard(
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${hadith.collection} ${hadith.hadithNumber}',
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.evidenceStrong.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  hadith.grade,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.evidenceStrong,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ArabicText(
            hadith.textArabic,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 6),
          Text(
            hadith.textEnglish,
            style: AppTypography.hadithMatnEnglish.copyWith(
              color: isDark ? AppColors.translationTextDark : AppColors.translationTextLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          // Scholarly Nuance Highlight Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon)
                  .withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              border: Border.all(
                color: (isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon)
                    .withValues(alpha: 0.3),
                width: 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.balance_rounded,
                      size: 16,
                      color: isDark
                          ? AppColors.accentGoldLight
                          : AppColors.primaryMaroon,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Essential Scholarly Nuance',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.accentGoldLight
                            : AppColors.primaryMaroon,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  hadith.scholarlyNuance ??
                      '“The Sunnah encourages drinking while seated. However, other authentic narrations report that the Prophet ﷺ also drank while standing on some occasions. Therefore, the app should not tell users that drinking while standing is medically dangerous or forbidden in every circumstance.”',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextHeading,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTION 3: INTERACTIVE STEP-BY-STEP COMPONENT ---
  Widget _buildInteractiveStepComponent(
    BuildContext context,
    SunnahPractice practice,
    PracticeStep activeStep,
    bool isDark,
  ) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Selector Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${activeStep.stepNumber} of ${practice.steps.length}',
                style: AppTypography.labelMedium.copyWith(
                  color: isDark
                      ? AppColors.accentGoldLight
                      : AppColors.primaryMaroon,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton.icon(
                onPressed: () =>
                    PracticeWalkthroughSheet.show(context, practice.steps),
                icon: const Icon(Icons.fullscreen_rounded, size: 16),
                label: const Text('Fullscreen Mode'),
                style: TextButton.styleFrom(
                  foregroundColor: isDark
                      ? AppColors.accentGoldLight
                      : AppColors.primaryMaroon,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Horizontal step pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(practice.steps.length, (index) {
                final isSelected = _selectedStepIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ChoiceChip(
                    label: Text('${index + 1}'),
                    selected: isSelected,
                    onSelected: (_) =>
                        setState(() => _selectedStepIndex = index),
                    selectedColor: isDark
                        ? AppColors.accentGoldLight.withValues(alpha: 0.3)
                        : AppColors.primaryMaroon.withValues(alpha: 0.15),
                    backgroundColor: isDark
                        ? AppColors.darkSurfaceSubtle
                        : AppColors.parchmentSubtle,
                    side: BorderSide(
                      color: isSelected
                          ? (isDark
                              ? AppColors.accentGoldLight
                              : AppColors.primaryMaroon)
                          : (isDark
                              ? AppColors.darkBorder
                              : AppColors.parchmentBorder),
                      width: 0.8,
                    ),
                    labelStyle: AppTypography.labelSmall.copyWith(
                      color: isSelected
                          ? (isDark
                              ? AppColors.darkTextHeading
                              : AppColors.primaryMaroon)
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Interactive Stage Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                // Fluid/Breathing Animation
                SizedBox(
                  width: 100,
                  height: 150,
                  child: activeStep.isBreathingPhase
                      ? const BreathingAnimationWidget(size: 90, active: true)
                      : AnimatedWaterGlass(
                          targetLevel: activeStep.waterLevel,
                          width: 90,
                          height: 140,
                        ),
                ),
                const SizedBox(width: 16),

                // Step Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (activeStep.arabicPhrase != null) ...[
                        ArabicText(
                          activeStep.arabicPhrase!,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        activeStep.title,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextHeading
                              : AppColors.lightTextHeading,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        activeStep.instruction,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Step Stepper Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: _selectedStepIndex > 0
                    ? () => setState(() => _selectedStepIndex--)
                    : null,
                icon: const Icon(Icons.chevron_left_rounded),
                label: const Text('Previous'),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
              FilledButton.icon(
                onPressed: _selectedStepIndex < practice.steps.length - 1
                    ? () => setState(() => _selectedStepIndex++)
                    : null,
                icon: const Icon(Icons.chevron_right_rounded),
                label: const Text('Next Step'),
                style: FilledButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.accentGoldLight
                      : AppColors.primaryMaroon,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- SECTION 4: SCIENTIFIC PERSPECTIVE INTRO ---
  Widget _buildScientificPerspectiveIntro(
    BuildContext context,
    SunnahPractice practice,
    bool isDark,
  ) {
    return AppCard(
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.science_rounded,
                size: 20,
                color: isDark ? AppColors.accentGoldLight : AppColors.evidenceStrong,
              ),
              const SizedBox(width: 8),
              Text(
                'Objective Scientific Context',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextHeading
                      : AppColors.lightTextHeading,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            practice.scientificIntro,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextHeading,
              fontStyle: FontStyle.italic,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  // --- SCIENTIFIC FINDING CARD ---
  Widget _buildScientificFindingCard(
    BuildContext context,
    dynamic finding,
    bool isDark,
  ) {
    return AppCard(
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  finding.title,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextHeading
                        : AppColors.lightTextHeading,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                    width: 0.8,
                  ),
                ),
                child: Text(
                  finding.domain,
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            finding.finding,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.accentGoldLight : AppColors.primaryEmerald)
                  .withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: (isDark ? AppColors.accentGoldLight : AppColors.primaryEmerald)
                    .withValues(alpha: 0.25),
                width: 0.8,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 15,
                  color: isDark
                      ? AppColors.accentGoldLight
                      : AppColors.primaryEmerald,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    finding.relevanceNuance,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextHeading,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTION 5: EVIDENCE EVALUATION CARD ---
  Widget _buildEvidenceEvaluationCard(
    BuildContext context,
    SunnahPractice practice,
    bool isDark,
  ) {
    return AppCard(
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Assigned Epistemological Rating',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextHeading
                      : AppColors.lightTextHeading,
                ),
              ),
              const EvidenceBadge(
                level: EvidenceLevel.moderate,
                compact: false,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            practice.evidenceExplanation,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.evidenceUnsupported.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: AppColors.evidenceUnsupported.withValues(alpha: 0.3),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.not_interested_rounded,
                  size: 14,
                  color: AppColors.evidenceUnsupported,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Editorial standard: Never labelled "Scientifically proven Sunnah".',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.evidenceUnsupported,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTION 7: DISCLAIMER CARD ---
  Widget _buildDisclaimerCard(
    BuildContext context,
    SunnahPractice practice,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
          width: 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 18,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              practice.educationalDisclaimer,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                fontSize: 11.5,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
