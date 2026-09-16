import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/arabic_text.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/evidence_badge.dart';
import '../../../../core/widgets/research_citation_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../education/presentation/widgets/animated_water_glass.dart';
import '../../data/models/sunnah_practice.dart';
import '../providers/sunnah_providers.dart';
import '../widgets/sunnah_step_card.dart';

class SunnahDetailScreen extends ConsumerStatefulWidget {
  final String sunnahId;

  const SunnahDetailScreen({
    super.key,
    required this.sunnahId,
  });

  @override
  ConsumerState<SunnahDetailScreen> createState() => _SunnahDetailScreenState();
}

class _SunnahDetailScreenState extends ConsumerState<SunnahDetailScreen> {
  bool _isDisclaimerExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sunnahAsync = ref.watch(sunnahDetailProvider(widget.sunnahId));
    final isBookmarked = ref.watch(sunnahBookmarksProvider).contains(widget.sunnahId);
    final isChildMode = ref.watch(sunnahChildModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sunnah Detail',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isBookmarked ? AppColors.accentGold : null,
            ),
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Save Bookmark',
            onPressed: () {
              ref.read(sunnahBookmarksProvider.notifier).toggleBookmark(widget.sunnahId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isBookmarked
                        ? 'Removed from Bookmarks'
                        : 'Saved to Sunnah Bookmarks',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Sunnah',
            onPressed: () {
              final practice = sunnahAsync.value;
              if (practice != null) {
                Clipboard.setData(
                  ClipboardData(
                    text: '${practice.title} (${practice.arabicTitle}): ${practice.description}',
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sunnah copied to clipboard!')),
                );
              }
            },
          ),
        ],
      ),
      body: AppBackground(
        child: sunnahAsync.when(
          data: (practice) {
            if (practice == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48),
                    const SizedBox(height: 12),
                    Text('Sunnah not found', style: AppTypography.titleMedium),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Return to Sunnah List'),
                    ),
                  ],
                ),
              );
            }

            return _buildContent(context, practice, isDark, isChildMode);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error loading Sunnah: $err')),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SunnahPractice practice,
    bool isDark,
    bool isChildMode,
  ) {
    final displayTitle = (isChildMode && practice.childTitle != null)
        ? practice.childTitle!
        : practice.title;
    final displayDescription = (isChildMode && practice.childDescription != null)
        ? practice.childDescription!
        : practice.description;

    return ListView(
      padding: AppDimensions.paddingScreen,
      children: [
        // SECTION A — SUNNAH HERO
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF28151A) : AppColors.primaryMaroon,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorder
                  : AppColors.accentGold.withValues(alpha: 0.4),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryMaroon.withValues(alpha: 0.2),
                blurRadius: 10,
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      practice.category.toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.accentGoldLight,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        fontSize: 9.5,
                      ),
                    ),
                  ),
                  EvidenceBadge(level: practice.evidenceLevel, compact: true),
                ],
              ),
              const SizedBox(height: 12),
              ArabicText(
                practice.arabicTitle,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              Text(
                displayTitle,
                style: AppTypography.headlineMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                displayDescription,
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.88),
                  height: 1.5,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Science Animation Button (if video / science available)
        if (practice.hasScience) ...[
          FilledButton.icon(
            onPressed: () => context.push('/sunnah/${practice.id}/video'),
            icon: const Icon(Icons.play_circle_outline_rounded, size: 20),
            label: const Text('Watch Scientific Animation'),
            style: FilledButton.styleFrom(
              backgroundColor: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
              foregroundColor: isDark ? Colors.black : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // SECTION B — WHAT THE PROPHET ﷺ DID (AUTHENTIC HADITH)
        SectionHeader(
          title: 'What the Prophet ﷺ Did',
          subtitle: 'Authentic Prophetic Narrations',
        ),
        const SizedBox(height: 10),
        ...practice.hadithReferences.map((hadith) {
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
                        hadith.authenticity,
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
                  hadith.arabicText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                Text(
                  hadith.englishTranslation,
                  style: AppTypography.hadithMatnEnglish.copyWith(
                    color: isDark ? AppColors.translationTextDark : AppColors.translationTextLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (hadith.commentary != null) ...[
                  const CustomDivider(showOrnament: true, verticalPadding: 8),
                  Text(
                    hadith.commentary!,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
                if (hadith.scholarlyNuance != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon)
                          .withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                      border: Border.all(
                        color: (isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon)
                            .withValues(alpha: 0.25),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      hadith.scholarlyNuance!,
                      style: AppTypography.bodySmall.copyWith(
                        fontStyle: FontStyle.italic,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
        const SizedBox(height: 24),

        // SECTION C — HOW TO PRACTICE IT
        SectionHeader(
          title: 'How to Practice It',
          subtitle: 'Step-by-Step Prophetic Etiquette',
        ),
        const SizedBox(height: 10),
        if (practice.id == 'drinking-water') ...[
          // Animated interactive showcase for drinking water
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const AnimatedWaterGlass(targetLevel: 0.67, width: 85, height: 130),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Interactive Deglutition Guide',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextHeading : AppColors.lightTextHeading,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Drink calmly in 3 measured sips, pause, and breathe outside the cup.',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        ...practice.steps.map((step) => SunnahStepCard(step: step)),
        const SizedBox(height: 24),

        // SECTION D — SCIENTIFIC PERSPECTIVE
        SectionHeader(
          title: 'Scientific Perspective',
          subtitle: 'Human Physiology & Biomechanics',
        ),
        const SizedBox(height: 10),

        if (practice.hasScience) ...[
          AppCard(
            padding: AppDimensions.paddingCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.science_rounded,
                      size: 20,
                      color: isDark ? AppColors.accentGoldLight : AppColors.evidenceModerate,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Physiological Context',
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextHeading : AppColors.lightTextHeading,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  practice.scientificPerspective!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
                    height: 1.55,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          ...practice.scientificInsights.map((insight) {
            return AppCard(
              padding: AppDimensions.paddingCard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.title,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextHeading : AppColors.lightTextHeading,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    insight.summary,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      insight.limitations,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 11.5,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ] else ...[
          AppCard(
            padding: AppDimensions.paddingCard,
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'No relevant scientific research has been identified for this Sunnah. The Sunnah is observed as an act of prophetic devotion and spiritual emulation.',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),

        // SECTION E — RESEARCH PAPERS
        if (practice.researchStudies.isNotEmpty) ...[
          SectionHeader(
            title: 'Research Literature',
            subtitle: 'Peer-Reviewed Scientific Citations',
          ),
          const SizedBox(height: 10),
          ...practice.researchStudies.map(
            (paper) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ResearchCitationCard(paper: paper),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // SECTION F — EVIDENCE LEVEL BADGE
        SectionHeader(
          title: 'Evidence Classification',
          subtitle: 'Empirical Correlation Status',
        ),
        const SizedBox(height: 10),
        AppCard(
          padding: AppDimensions.paddingCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Classification Rating',
                    style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                  ),
                  EvidenceBadge(level: practice.evidenceLevel, compact: false),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                practice.evidenceExplanation.isNotEmpty
                    ? practice.evidenceExplanation
                    : 'Observed as pure prophetic tradition; not contingent on empirical confirmation.',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // SECTION G — SCIENTIFIC DISCLAIMER
        AppCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => setState(() => _isDisclaimerExpanded = !_isDisclaimerExpanded),
                child: Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 16,
                      color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Scientific Disclaimer',
                        style: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                        ),
                      ),
                    ),
                    Icon(
                      _isDisclaimerExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                    ),
                  ],
                ),
              ),
              if (_isDisclaimerExpanded) ...[
                const SizedBox(height: 10),
                Text(
                  '“Scientific research can help us understand human physiology, but it should not be used to force scientific explanations onto religious texts. The Sunnah is followed because it is the Sunnah. Scientific evidence presented here describes research findings and possible physiological connections.”',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 36),
      ],
    );
  }
}
