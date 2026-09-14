import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/evidence_level.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/evidence_badge.dart';
import '../../../core/widgets/research_citation_card.dart';
import '../../../core/providers/app_providers.dart';
import '../../user_library/domain/entities/bookmark.dart';

class TopicDetailScreen extends ConsumerWidget {
  final String topicId;

  const TopicDetailScreen({
    super.key,
    required this.topicId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicAsync = ref.watch(topicDetailProvider(topicId));
    final bookmarks = ref.watch(bookmarksProvider).value ?? [];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bookmarkId = 'bm_topic_$topicId';
    final isBookmarked = bookmarks.any((b) => b.id == bookmarkId);

    return Scaffold(
      appBar: AppBar(
        title: topicAsync.when(
          data: (topic) => Text(
            topic?.title ?? 'Scientific Topic',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          loading: () => const Text('Loading...'),
          error: (err, stack) => const Text('Topic Detail'),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isBookmarked ? AppColors.accentGold : null,
            ),
            onPressed: () {
              final topic = topicAsync.value;
              if (topic == null) return;
              final bm = Bookmark(
                id: bookmarkId,
                itemType: LibraryItemType.scientificTopic,
                itemId: topic.id,
                title: topic.title,
                subtitle: topic.category,
                createdAt: DateTime.now(),
              );
              ref.read(bookmarksProvider.notifier).toggleBookmark(bm);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isBookmarked ? 'Removed from bookmarks' : 'Added to bookmarks',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Bookmark',
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              final topic = topicAsync.value;
              if (topic == null) return;
              Clipboard.setData(ClipboardData(
                text: 'Exploring "${topic.title}" on Bayan - Islamic & Scientific Research App.',
              ));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Topic link copied for sharing!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Share',
          ),
        ],
      ),
      body: topicAsync.when(
        data: (topic) {
          if (topic == null) {
            return const Center(child: Text('Topic not found.'));
          }

          final EvidenceLevel level = topic.evidenceLevel;
          final papersAsync = topic.researchPaperIds.isNotEmpty
              ? ref.watch(researchPapersProvider(topic.researchPaperIds))
              : null;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF163229), const Color(0xFF0F261E)]
                        : [const Color(0xFFE8F5EE), const Color(0xFFF0FAF4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  border: Border.all(
                    color: AppColors.primaryEmerald.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            topic.category.toUpperCase(),
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primaryEmerald,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        EvidenceBadge(level: level),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      topic.title,
                      style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      topic.summary,
                      style: AppTypography.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                        height: 1.5,
                      ),
                    ),
                    if (topic.description.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        topic.description,
                        style: AppTypography.bodySmall.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Rubric Explanation Accordion
              _buildEvidenceRubricCard(context, level, isDark),

              const SizedBox(height: 16),

              // Islamic Perspective Section
              if (topic.islamicPerspective.isNotEmpty) ...[
                _buildSectionCard(
                  context,
                  'Islamic Perspective & Theological Foundation',
                  topic.islamicPerspective,
                  Icons.menu_book_rounded,
                  AppColors.primaryEmerald,
                  isDark,
                ),
                const SizedBox(height: 16),
              ],

              // Linked Quranic Verses
              if (topic.relatedAyahKeys.isNotEmpty) ...[
                Text(
                  'Connected Qur\'anic Verses (${topic.relatedAyahKeys.length})',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...topic.relatedAyahKeys.map((ayahKey) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: AppCard(
                      onTap: () {
                        // Parse ayah key e.g. "23:12-14" or "96:1-2"
                        final parts = ayahKey.split(':');
                        if (parts.length == 2) {
                          final surah = int.tryParse(parts[0]) ?? 1;
                          final firstAyah = int.tryParse(parts[1].split('-').first) ?? 1;
                          context.push('/quran/ayah/$surah/$firstAyah');
                        }
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_stories_rounded, size: 18, color: AppColors.primaryEmerald),
                              const SizedBox(width: 10),
                              Text(
                                'Surah Verse $ayahKey',
                                style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'View Verse & Tafseer',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primaryEmerald,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primaryEmerald),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],

              // Linked Prophetic Hadith
              if (topic.relatedHadithIds.isNotEmpty) ...[
                Text(
                  'Connected Prophetic Traditions (${topic.relatedHadithIds.length})',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...topic.relatedHadithIds.map((hadithId) {
                  final parts = hadithId.split(':');
                  final collectionKey = parts[0];
                  final hadithNum = parts.length > 1 ? parts[1] : '1';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: AppCard(
                      onTap: () => context.push('/hadith/detail/$collectionKey/$hadithNum'),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.library_books_rounded, size: 18, color: AppColors.accentTeal),
                              const SizedBox(width: 10),
                              Text(
                                '${collectionKey.toUpperCase()} #$hadithNum',
                                style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'View Hadith Analysis',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.accentTeal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.accentTeal),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],

              // Modern Scientific Explanation
              if (topic.scientificExplanation.isNotEmpty) ...[
                _buildSectionCard(
                  context,
                  'Modern Scientific Framework & Mechanism',
                  topic.scientificExplanation,
                  Icons.biotech_rounded,
                  AppColors.primaryEmeraldLight,
                  isDark,
                ),
                const SizedBox(height: 16),
              ],

              // What Research Says / Scientific Consensus
              if (topic.whatResearchSays.isNotEmpty) ...[
                _buildSectionCard(
                  context,
                  'What Empirical Research Demonstrates',
                  topic.whatResearchSays,
                  Icons.verified_rounded,
                  AppColors.evidenceStrong,
                  isDark,
                ),
                const SizedBox(height: 16),
              ],

              // Research Papers Section
              if (papersAsync != null) ...[
                Text(
                  'Indexed Peer-Reviewed Research (${topic.researchPaperIds.length})',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Demonstration references showcasing empirical methodology and literature citations.',
                  style: AppTypography.bodySmall.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 10),
                papersAsync.when(
                  data: (papers) {
                    if (papers.isEmpty) {
                      return const Text('No academic papers currently indexed.');
                    }
                    return Column(
                      children: papers.map((p) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: ResearchCitationCard(paper: p),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Text('Error loading papers: $err'),
                ),
                const SizedBox(height: 16),
              ],

              // Related Topics Chips
              if (topic.relatedTopicIds.isNotEmpty) ...[
                Text(
                  'Related Research Domains',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: topic.relatedTopicIds.map((relId) {
                    return ActionChip(
                      avatar: const Icon(Icons.explore_outlined, size: 16, color: AppColors.primaryEmerald),
                      label: Text(relId.replaceAll('_', ' ').toUpperCase()),
                      onPressed: () => context.push('/science/topic/$relId'),
                    );
                  }).toList(),
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildEvidenceRubricCard(BuildContext context, EvidenceLevel level, bool isDark) {
    String description = '';
    switch (level) {
      case EvidenceLevel.strong:
        description =
            'Level 1 (Direct Alignment): Clear linguistic congruence between original Arabic morphology and rigorous empirical peer-reviewed findings without allegorical straining.';
        break;
      case EvidenceLevel.moderate:
        description =
            'Level 2 (Moderate / Contextual Evidence): Peer-reviewed physiological literature providing contextual mechanism without proving religious doctrine.';
        break;
      case EvidenceLevel.emerging:
        description =
            'Level 2 (Emerging Correlation): Plausible physiological or astrophysical correlation corroborated by early clinical trials or observational studies.';
        break;
      case EvidenceLevel.possible:
        description =
            'Level 3 (Thematic Alignment): Broad philosophical harmony between holistic Qur\'anic principles and scientific paradigms.';
        break;
      case EvidenceLevel.unsupported:
        description =
            'Level 4 (Myth-Buster / Unsupported): Numerological or pseudoscientific claim that fails rigorous linguistic Arabic grammar or modern physics consensus.';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.accentTeal),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scientific Classification Rubric',
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentTeal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: AppTypography.bodyMedium.copyWith(
              height: 1.6,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

