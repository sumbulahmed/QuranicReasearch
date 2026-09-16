import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/evidence_level.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/arabic_text.dart';
import '../../../core/widgets/custom_divider.dart';
import '../../../core/widgets/evidence_badge.dart';
import '../../../core/widgets/scientific_insight_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/translation_text.dart';
import '../../../core/providers/app_providers.dart';
import '../../user_library/domain/entities/bookmark.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topicsAsync = ref.watch(scientificTopicsProvider);
    final researchAsync = ref.watch(allResearchPapersProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quran & Science',
              style: AppTypography.appTitle.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Evidence-Based Islamic Research • Classical & Empirical Inquest',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
            onPressed: () => context.push('/library/bookmarks'),
            tooltip: 'Bookmarks',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: AppBackground(
        child: ListView(
          padding: AppDimensions.paddingScreen,
          children: [
            // 1. Manuscript Library Search Trigger
            _buildSearchTrigger(context, isDark),
            const SizedBox(height: 18),

            // 2. Classical Compendium Quick Access
            _buildQuickAccessGrid(context, isDark),
            const SizedBox(height: 20),

            // 2b. Educational Spotlight: Sunnah of Drinking Water
            _buildSunnahDrinkingSpotlightBanner(context, isDark),
            const SizedBox(height: 22),

            // 3. Daily Reflective Ayah
            _buildDailyAyahCard(context, ref, isDark),
            const SizedBox(height: 18),

            // 4. Daily Hadith Narration
            _buildDailyHadithCard(context, ref, isDark),
            const SizedBox(height: 18),

            // 5. Featured Scientific Synthesis Banner (Classic Maroon & Gold)
            _buildFeaturedInsightCard(context, isDark),
            const SizedBox(height: 20),

            // 6. Continue Reading / Archival Marker
            _buildContinueReadingCard(context, isDark),
            const SizedBox(height: 22),

            // 7. Popular Research Domains
            _buildPopularTopicsSection(context, isDark),
            const SizedBox(height: 22),

            // 8. Curated Scientific Research Topics
            SectionHeader(
              title: 'Curated Scientific Research',
              subtitle: 'Empirically evaluated against classical tafseer',
              trailing: TextButton(
                onPressed: () => context.go('/science'),
                child: Text(
                  'View All',
                  style: AppTypography.labelMedium.copyWith(
                    color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            topicsAsync.when(
              data: (topics) {
                final preview = topics.take(3).toList();
                return Column(
                  children: preview.map((topic) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ScientificInsightCard(
                        category: topic.category,
                        title: topic.title,
                        summary: topic.summary,
                        connectionsCount: topic.connectionsCount,
                        evidenceLevel: topic.evidenceLevel,
                        onTap: () => context.push('/science/topic/${topic.id}'),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => Text('Error loading topics: $err'),
            ),
            const SizedBox(height: 18),

            // 9. Peer-Reviewed Research Citations
            _buildResearchPapersSection(context, researchAsync, isDark),
            const SizedBox(height: 20),

            // 10. Epistemological Principle Card
            _buildIntegrityPrincipleCard(context, isDark),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTrigger(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () => context.go('/search'),
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.parchmentCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : const Color(0xFF6B5848).withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search Quran, Hadith, or Scientific Domains...',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceSubtle
                    : AppColors.parchmentSubtle,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                  width: 0.8,
                ),
              ),
              child: Text(
                'FOLIO',
                style: AppTypography.labelSmall.copyWith(
                  color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context, bool isDark) {
    final items = [
      {
        'title': 'Noble Quran',
        'subtitle': '114 Surahs & Tafseer',
        'icon': Icons.menu_book_rounded,
        'color': AppColors.primaryMaroon,
        'route': '/quran',
      },
      {
        'title': 'Hadith Sunnah',
        'subtitle': 'Authentic Compendiums',
        'icon': Icons.library_books_rounded,
        'color': AppColors.accentSepia,
        'route': '/hadith',
      },
      {
        'title': 'Science Topics',
        'subtitle': '10 Empirical Domains',
        'icon': Icons.science_outlined,
        'color': AppColors.evidenceStrong,
        'route': '/science',
      },
      {
        'title': 'Research Hub',
        'subtitle': 'Peer-Reviewed Literature',
        'icon': Icons.auto_stories_outlined,
        'color': AppColors.accentGold,
        'route': '/research',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.3,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final col = item['color'] as Color;
        return AppCard(
          onTap: () {
            final route = item['route'] as String;
            if (route == '/quran' || route == '/hadith' || route == '/science') {
              context.go(route);
            } else {
              context.push(route);
            }
          },
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceSubtle
                      : AppColors.parchmentSubtle,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                    width: 0.8,
                  ),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  size: 18,
                  color: isDark ? AppColors.accentGoldLight : col,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['title'] as String,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      item['subtitle'] as String,
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                        fontSize: 10.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDailyAyahCard(BuildContext context, WidgetRef ref, bool isDark) {
    return AppCard(
      showMaroonAccent: true,
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primaryMaroonDark
                            : AppColors.parchmentSubtle,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.primaryMaroon.withValues(alpha: 0.25),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            size: 12,
                            color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'DAILY REFLECTION',
                            style: AppTypography.labelSmall.copyWith(
                              color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                              fontWeight: FontWeight.w800,
                              fontSize: 9.5,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Surah Al-Mu\'minun 23:14',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const EvidenceBadge(level: EvidenceLevel.strong, compact: true),
            ],
          ),
          const SizedBox(height: 14),

          // Arabic Calligraphy
          ArabicText(
            'ثُمَّ خَلَقْنَا النُّطْفَةَ عَلَقَةً فَخَلَقْنَا الْعَلَقَةَ مُضْغَةً فَخَلَقْنَا الْمُضْغَةَ عِظَامًا...',
            fontSize: 23,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 10),

          // English Translation
          TranslationText(
            '"Then We made the sperm-drop into a clinging clot, and We made the clot into a lump of flesh, and We made from the lump, bones, and We covered the bones with flesh..."',
          ),
          const SizedBox(height: 6),

          // Urdu Translation
          TranslationText.urdu(
            'پھر ہم نے نطفہ کو جما ہوا خون بنایا، پھر لوتھڑا، پھر ہڈیاں، پھر ہڈیوں پر گوشت چڑھایا...',
          ),
          const SizedBox(height: 12),
          const CustomDivider(verticalPadding: 4),
          const SizedBox(height: 4),

          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.play_circle_outline_rounded,
                      color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                      size: 26,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Playing recitation: Sheikh Mishary Rashid Alafasy')),
                      );
                    },
                    tooltip: 'Play Recitation',
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border_rounded, size: 20),
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    onPressed: () {
                      ref.read(bookmarksProvider.notifier).toggleBookmark(
                            Bookmark(
                              id: 'bm_23_14',
                              itemType: LibraryItemType.ayah,
                              itemId: '23:14',
                              title: 'Surah Al-Mu\'minun (23:14)',
                              subtitle: 'Human embryological progression stages',
                              createdAt: DateTime.now(),
                            ),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ayah 23:14 saved to Bookmarks')),
                      );
                    },
                    tooltip: 'Bookmark',
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => context.push('/quran/ayah/23/14'),
                icon: const Icon(Icons.auto_stories_outlined, size: 14),
                label: const Text('Explore Insight'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.primaryMaroon.withValues(alpha: 0.4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyHadithCard(BuildContext context, WidgetRef ref, bool isDark) {
    return AppCard(
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceSubtle
                      : AppColors.parchmentSubtle,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history_edu_rounded,
                      size: 13,
                      color: isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'HADITH NARRATION',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
                        fontWeight: FontWeight.w800,
                        fontSize: 9.5,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.evidenceStrong.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.evidenceStrong.withValues(alpha: 0.35),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  'Sahih (Authentic)',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.evidenceStrong,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Sahih al-Bukhari 1904 • Narrated by Abu Hurairah (RA)',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          ArabicText(
            'الصِّيَامُ جُنَّةٌ فَلَا يَرْفُثْ وَلَا يَجْهَلْ...',
            fontSize: 21,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          TranslationText(
            '"Fasting is a protective shield. So when one of you is fasting, he should neither indulge in foul language nor act foolishly..."',
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.science_outlined,
                    size: 14,
                    color: isDark ? AppColors.accentGoldLight : AppColors.evidenceStrong,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Autophagy & Neuroplasticity',
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark ? AppColors.accentGoldLight : AppColors.evidenceStrong,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => context.push('/hadith/detail/bukhari/1904'),
                icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                label: const Text('Read Hadith'),
                style: TextButton.styleFrom(
                  foregroundColor: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedInsightCard(BuildContext context, bool isDark) {
    return Container(
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
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'FEATURED RESEARCH SYNTHESIS',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.accentGoldLight,
                    fontWeight: FontWeight.w800,
                    fontSize: 9.5,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.evidenceStrong,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Strong Evidence',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Intermittent Fasting & Cellular Autophagy',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.parchmentCard,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Examining the cellular rejuvenation Nobel Prize-winning mechanisms of autophagy triggered by caloric restriction, correlating with Prophetic weekly fasting routines.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.parchmentCard.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () => context.push('/science/topic/fasting_autophagy'),
            icon: const Icon(Icons.menu_book_outlined, size: 15),
            label: const Text('Read Full Manuscript Folio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.parchmentCard,
              foregroundColor: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                side: BorderSide(
                  color: AppColors.accentGold.withValues(alpha: 0.4),
                  width: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueReadingCard(BuildContext context, bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceSubtle
                  : AppColors.parchmentSubtle,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                width: 0.8,
              ),
            ),
            child: Icon(
              Icons.bookmark_added_outlined,
              color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CONTINUE READING',
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                    fontWeight: FontWeight.w800,
                    fontSize: 9.5,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Surah Al-Mu\'minun (23:14)',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
                  ),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: 0.68,
                    minHeight: 3.5,
                    backgroundColor: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_rounded,
              color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
              size: 22,
            ),
            onPressed: () => context.push('/quran/surah/23'),
            tooltip: 'Resume Reading',
          ),
        ],
      ),
    );
  }

  Widget _buildPopularTopicsSection(BuildContext context, bool isDark) {
    final categories = [
      {'label': '🧬 Human Embryology', 'id': 'embryology'},
      {'label': '💧 Hydrology & Oceans', 'id': 'water_oceans'},
      {'label': '😴 Sleep & Circadian Rhythms', 'id': 'sleep_circadian'},
      {'label': '🧘 Fasting & Autophagy', 'id': 'fasting_autophagy'},
      {'label': '🧠 Neurobiology of the Forelock', 'id': 'prefrontal_cortex'},
      {'label': '🍎 Dietary Moderation', 'id': 'nutrition_moderation'},
      {'label': '⛰️ Mountains as Pegs', 'id': 'mountains_isostasy'},
      {'label': '🌌 Expanding Universe', 'id': 'cosmic_expansion'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Popular Research Domains',
          subtitle: 'Empirical inquiries across cosmology, anatomy, and geology',
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((cat) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ActionChip(
                  label: Text(cat['label']!),
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.parchmentCard,
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                    width: 0.8,
                  ),
                  labelStyle: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  onPressed: () => context.push('/science/topic/${cat['id']}'),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildResearchPapersSection(
      BuildContext context, AsyncValue<List<dynamic>> researchAsync, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Peer-Reviewed Academic Studies',
          subtitle: 'Indexed literature with verifiable citations and DOIs',
          trailing: TextButton(
            onPressed: () => context.push('/research'),
            child: Text(
              'View All',
              style: AppTypography.labelMedium.copyWith(
                color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        researchAsync.when(
          data: (papers) {
            final sample = papers.take(2).toList();
            return Column(
              children: sample.map((p) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkSurfaceSubtle
                                    : AppColors.parchmentSubtle,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                p.field,
                                style: AppTypography.labelSmall.copyWith(
                                  color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.evidenceStrong.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: AppColors.evidenceStrong.withValues(alpha: 0.35),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                'PEER-REVIEWED',
                                style: AppTypography.labelSmall.copyWith(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.evidenceStrong,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.title,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${p.authors.join(', ')} • ${p.journal} (${p.publicationYear})',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (err, stack) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildIntegrityPrincipleCard(BuildContext context, bool isDark) {
    return AppCard(
      backgroundColor: isDark
          ? AppColors.darkSurface
          : AppColors.parchmentSubtle,
      borderColor: AppColors.evidenceStrong.withValues(alpha: 0.35),
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_outlined,
                color: AppColors.evidenceStrong,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Epistemic & Scholarly Integrity',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.evidenceStrong,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'We strictly refuse to force speculative scientific theories onto immutable divine revelation. Science advances through progressive empirical falsification. Divine text conveys transcendent wisdom. Only peer-reviewed consensus and rigorous linguistic parallels are cataloged.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSunnahDrinkingSpotlightBanner(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () => context.push('/education/sunnah-drinking'),
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF2B161B),
                    const Color(0xFF1C222A),
                  ]
                : [
                    AppColors.parchmentCard,
                    AppColors.parchmentSubtle,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder
                : AppColors.accentGold.withValues(alpha: 0.5),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.25)
                  : const Color(0xFF6B5848).withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: (isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon)
                    .withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: (isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon)
                      .withValues(alpha: 0.3),
                  width: 1.0,
                ),
              ),
              child: Icon(
                Icons.water_drop_rounded,
                size: 25,
                color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          'EDUCATIONAL SPOTLIGHT',
                          style: AppTypography.labelSmall.copyWith(
                            color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                            fontWeight: FontWeight.w800,
                            fontSize: 9,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Text(
                        'سُنَّةُ الشُّرْبِ',
                        style: AppTypography.labelSmall.copyWith(
                          color: isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'The Sunnah of Drinking Water',
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextHeading : AppColors.lightTextHeading,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Prophetic etiquette • Swallowing physiology & posture research',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
            ),
          ],
        ),
      ),
    );
  }
}
