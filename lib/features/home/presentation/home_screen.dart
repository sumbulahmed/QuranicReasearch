import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/evidence_level.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/evidence_badge.dart';
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
            Row(
              children: [
                Text(
                  'As-salāmu ʿalaykum',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryEmerald,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.waving_hand_rounded, size: 16, color: AppColors.accentGold),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Rabiʻ al-Awwal 1448 AH • Evidence-Based Research',
              style: AppTypography.labelSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline_rounded),
            onPressed: () => context.push('/library/bookmarks'),
            tooltip: 'Bookmarks',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: ListView(
        padding: AppDimensions.paddingScreen,
        children: [
          // 1. Search Bar Trigger
          _buildSearchTrigger(context, isDark),
          const SizedBox(height: 20),

          // 2. Quick Access Grid (Quran, Hadith, Science, Research)
          _buildQuickAccessGrid(context, isDark),
          const SizedBox(height: 24),

          // 3. Daily Ayah Card
          _buildDailyAyahCard(context, ref, isDark),
          const SizedBox(height: 20),

          // 4. Daily Hadith Card
          _buildDailyHadithCard(context, ref, isDark),
          const SizedBox(height: 20),

          // 5. Featured Scientific Insight Banner
          _buildFeaturedInsightCard(context, isDark),
          const SizedBox(height: 20),

          // 6. Continue Reading Widget
          _buildContinueReadingCard(context, isDark),
          const SizedBox(height: 24),

          // 7. Popular Topics Horizontal Carousel
          _buildPopularTopicsSection(context, isDark),
          const SizedBox(height: 24),

          // 8. Curated Scientific Research Topics List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Scientific Topics',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/science'),
                child: const Text('View All 10'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          topicsAsync.when(
            data: (topics) {
              final preview = topics.take(3).toList();
              return Column(
                children: preview.map((topic) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildTopicCard(context, topic, isDark),
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
            error: (err, _) => Text('Error: $err'),
          ),
          const SizedBox(height: 16),

          // 9. Recent Research Studies Section
          _buildResearchPapersSection(context, researchAsync, isDark),
          const SizedBox(height: 20),

          // 10. Epistemological Principle Card
          _buildIntegrityPrincipleCard(context, isDark),
          const SizedBox(height: 32),
        ],
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
          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: AppColors.primaryEmerald, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search Quran, Hadith, Science, or Research...',
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryEmerald.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'EXPLORE',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primaryEmerald,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
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
        'color': AppColors.primaryEmerald,
        'route': '/quran',
      },
      {
        'title': 'Hadith Sunnah',
        'subtitle': 'Authentic Collections',
        'icon': Icons.library_books_rounded,
        'color': AppColors.accentGold,
        'route': '/hadith',
      },
      {
        'title': 'Science Topics',
        'subtitle': '10 Empirical Domains',
        'icon': Icons.science_rounded,
        'color': AppColors.accentTeal,
        'route': '/science',
      },
      {
        'title': 'Research Hub',
        'subtitle': 'Papers & Citations',
        'icon': Icons.article_outlined,
        'color': AppColors.accentCyan,
        'route': '/research',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.1,
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: col.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'] as IconData, size: 20, color: col),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['title'] as String,
                      style: AppTypography.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['subtitle'] as String,
                      style: AppTypography.labelSmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 10,
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
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryEmerald.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wb_sunny_outlined, size: 13, color: AppColors.primaryEmerald),
                        const SizedBox(width: 4),
                        Text(
                          'VERSE OF THE DAY',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primaryEmerald,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Surah Al-Mu\'minun 23:14',
                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const EvidenceBadge(level: EvidenceLevel.strong, compact: true),
            ],
          ),
          const SizedBox(height: 14),
          // Arabic
          Text(
            'ثُمَّ خَلَقْنَا النُّطْفَةَ عَلَقَةً فَخَلَقْنَا الْعَلَقَةَ مُضْغَةً فَخَلَقْنَا الْمُضْغَةَ عِظَامًا...',
            style: AppTypography.quranTextMedium.copyWith(
              color: isDark ? Colors.white : AppColors.primaryEmeraldDark,
              height: 1.8,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          // Translation English
          Text(
            '"Then We made the sperm-drop into a clinging clot, and We made the clot into a lump of flesh, and We made from the lump, bones, and We covered the bones with flesh..."',
            style: AppTypography.bodyMedium.copyWith(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          // Translation Urdu
          Text(
            'پھر ہم نے نطفہ کو جما ہوا خون بنایا، پھر لوتھڑا، پھر ہڈیاں، پھر ہڈیوں پر گوشت چڑھایا...',
            style: AppTypography.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_circle_fill_rounded, color: AppColors.primaryEmerald, size: 28),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Playing recitation: Sheikh Mishary Rashid Alafasy')),
                      );
                    },
                    tooltip: 'Play Recitation',
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_add_outlined, size: 20),
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
                        const SnackBar(content: Text('Ayah 23:14 bookmarked')),
                      );
                    },
                    tooltip: 'Bookmark',
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => context.push('/quran/ayah/23/14'),
                icon: const Icon(Icons.explore_outlined, size: 14),
                label: const Text('Explore Insight'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryEmerald,
                  side: const BorderSide(color: AppColors.primaryEmerald),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, size: 13, color: AppColors.accentGold),
                    const SizedBox(width: 4),
                    Text(
                      'HADITH OF THE DAY',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.accentGold,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
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
          const SizedBox(height: 12),
          Text(
            'Sahih al-Bukhari 1904 • Narrated by Abu Hurairah (RA)',
            style: AppTypography.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'الصِّيَامُ جُنَّةٌ فَلَا يَرْفُثْ وَلَا يَجْهَلْ...',
            style: AppTypography.quranTextMedium.copyWith(
              color: isDark ? Colors.white : AppColors.primaryEmeraldDark,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 6),
          Text(
            '"Fasting is a protective shield. So when one of you is fasting, he should neither indulge in foul language nor act foolishly..."',
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.science_outlined, size: 14, color: AppColors.accentTeal),
                  const SizedBox(width: 4),
                  Text(
                    'Autophagy & Neuroplasticity',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.accentTeal,
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
                  foregroundColor: AppColors.primaryEmerald,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0F3E33), const Color(0xFF14241F)]
              : [AppColors.primaryEmerald, AppColors.primaryEmeraldLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryEmerald.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'FEATURED SCIENTIFIC SYNTHESIS',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.evidenceStrong,
                  borderRadius: BorderRadius.circular(12),
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
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Examining the cellular rejuvenation Nobel Prize-winning mechanisms of autophagy triggered by caloric restriction, aligning with Prophetic weekly fasting.',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () => context.push('/science/topic/fasting_autophagy'),
            icon: const Icon(Icons.menu_book_outlined, size: 16),
            label: const Text('Read Full Topic Breakdown'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryEmeraldDark,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accentTeal.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.history_rounded, color: AppColors.accentTeal, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CONTINUE READING',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.accentTeal,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Surah Al-Mu\'minun (23:14)',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: const LinearProgressIndicator(
                    value: 0.68,
                    minHeight: 4,
                    backgroundColor: AppColors.lightBorder,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryEmerald),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.play_arrow_rounded, color: AppColors.primaryEmerald, size: 28),
            onPressed: () => context.push('/quran/surah/23'),
            tooltip: 'Resume Reading',
          ),
        ],
      ),
    );
  }

  Widget _buildPopularTopicsSection(BuildContext context, bool isDark) {
    final categories = [
      {'label': '🧬 Human Body', 'id': 'embryology'},
      {'label': '💧 Water', 'id': 'water_oceans'},
      {'label': '😴 Sleep', 'id': 'sleep_circadian'},
      {'label': '🧘 Fasting', 'id': 'fasting_autophagy'},
      {'label': '🧠 Psychology', 'id': 'prefrontal_cortex'},
      {'label': '🍎 Nutrition', 'id': 'nutrition_moderation'},
      {'label': '⛰️ Mountains', 'id': 'mountains_isostasy'},
      {'label': '🌌 Universe', 'id': 'cosmic_expansion'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Research Topics',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((cat) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ActionChip(
                  label: Text(cat['label']!),
                  backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                  side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  labelStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
                  onPressed: () => context.push('/science/topic/${cat['id']}'),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTopicCard(BuildContext context, dynamic topic, bool isDark) {
    return AppCard(
      onTap: () => context.push('/science/topic/${topic.id}'),
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryEmerald.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                      child: Text(
                        topic.category.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryEmeraldLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      topic.title,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              EvidenceBadge(level: topic.evidenceLevel, compact: true),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            topic.summary,
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.link_rounded, size: 16, color: AppColors.accentTeal),
                  const SizedBox(width: 4),
                  Text(
                    '${topic.connectionsCount} Linked Texts',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentTeal,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Explore Evidence',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primaryEmerald,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: AppColors.primaryEmerald,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResearchPapersSection(
      BuildContext context, AsyncValue<List<dynamic>> researchAsync, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Peer-Reviewed Citations',
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            TextButton(
              onPressed: () => context.push('/research'),
              child: const Text('View All'),
            ),
          ],
        ),
        researchAsync.when(
          data: (papers) {
            final sample = papers.take(2).toList();
            return Column(
              children: sample.map((p) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: AppCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.accentCyan.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                p.field,
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.accentCyan,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'DEMO RECORD',
                                style: AppTypography.labelSmall.copyWith(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${p.authors.join(', ')} • ${p.journal} (${p.publicationYear})',
                          style: AppTypography.bodySmall.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 11,
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
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildIntegrityPrincipleCard(BuildContext context, bool isDark) {
    return AppCard(
      backgroundColor: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF0FDF4),
      borderColor: AppColors.evidenceStrong.withValues(alpha: 0.3),
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: AppColors.evidenceStrong,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Scholarly & Scientific Integrity',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.evidenceStrong,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'We strictly refuse to force speculative scientific theories onto immutable divine text. Science advances through progressive empirical falsification. Only peer-reviewed consensus and rigorous linguistic parallels are cataloged.',
            style: AppTypography.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
